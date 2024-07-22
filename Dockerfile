# Use the official Apache Airflow image as the base
FROM apache/airflow:2.5.0-python3.8

# Set environment variables
ENV AIRFLOW_HOME=/opt/airflow
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
# SequentialExecutor,LocalExecutor
ENV AIRFLOW__CORE__SQL_ALCHEMY_CONN="mysql+pymysql://airflow:airflow@localhost:3306/airflow"
ENV AIRFLOW__CORE__EXECUTOR=LocalExecutor 

# MySQL Environment variables
ENV MYSQL_DATABASE=airflow
ENV MYSQL_USER=airflow
ENV MYSQL_PASSWORD=airflow
ENV MYSQL_ROOT_PASSWORD=root

USER root
RUN apt-get update && apt-get install -y \
    curl \
    redis-server \
    sudo \
    mariadb-server

# Allow airflow user to run commands as root without a password
RUN echo "airflow ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/airflow

# Install supervisord
RUN apt-get install -y supervisor

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# # Switch to the airflow user before copying files to respect ownership
# USER airflow

# # Copy and set permissions for the Redis configuration
# COPY redis.conf /etc/redis/redis.conf
# USER root
# RUN chown redis:redis /etc/redis/redis.conf
# RUN chmod 644 /etc/redis/redis.conf

# Copy and set permissions for the Redis configuration
COPY redis.conf /etc/redis/redis.conf
RUN chown redis:redis /etc/redis/redis.conf && chmod 644 /etc/redis/redis.conf

# Copy the MariaDB setup script from your host to the container
COPY setup_mysql.sh /setup_mysql.sh
RUN chmod +x /setup_mysql.sh

# Run the setup_mysql script to initialize MariaDB
RUN /bin/bash /setup_mysql.sh

# Switch back to airflow user to install Python packages
USER airflow
RUN pip install --no-cache-dir redis pymysql

# Copy your DAGs into the image
COPY dags/ $AIRFLOW_HOME/dags/

# Expose ports for web server and Redis
EXPOSE 8080 6379 3306

# Use the entrypoint script as the entrypoint for the container
ENTRYPOINT ["/entrypoint.sh"]