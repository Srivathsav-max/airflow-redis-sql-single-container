#!/bin/bash

# Start MariaDB
sudo /usr/bin/mysqld_safe &

# Wait for MariaDB to be fully up and running
while ! mysqladmin ping --silent; do
    sleep 1
done

# Start Redis in the background
sudo redis-server /etc/redis/redis.conf &

# Initialize the database
airflow db init

# Check if the default user already exists
if ! airflow users list | grep -q "${AIRFLOW_USERNAME}"; then
    echo "Creating an admin user..."
    airflow users create \
        --username "${AIRFLOW_USERNAME}" \
        --firstname "${AIRFLOW_FIRSTNAME}" \
        --lastname "${AIRFLOW_LASTNAME}" \
        --role "${AIRFLOW_ROLE}" \
        --email "${AIRFLOW_EMAIL}" \
        --password "${AIRFLOW_PASSWORD}"
else
    echo "Admin user already exists."
fi

# Start the scheduler in the background
airflow scheduler &

# Start the web server in the foreground
exec airflow webserver

#!setup for supervisord to handle multiple processes
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf