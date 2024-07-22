# Multiple Resouces Config to Single Docker Image

* Docker Build
```
docker build -t airflow-redis-sql .
```
* Run Docker Image With Multiple Resources in One Image with user login for airflow 
```
docker run -d \             
    -p 8080:8080 -p 6379:6379 -p 3306:3306 \
    -e AIRFLOW_USERNAME='admin' \
    -e AIRFLOW_FIRSTNAME='Admin' \
    -e AIRFLOW_LASTNAME='User' \
    -e AIRFLOW_ROLE='Admin' \
    -e AIRFLOW_EMAIL='admin@example.com' \
    -e AIRFLOW_PASSWORD='admin' \
    airflow-redis-sql
```
