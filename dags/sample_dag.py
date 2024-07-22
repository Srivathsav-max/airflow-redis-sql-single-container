from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from datetime import datetime

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2023, 1, 1),
    'retries': 1
}

dag = DAG(
    'sample_dag',
    default_args=default_args,
    description='A simple sample DAG',
    schedule_interval='@daily',
)

t1 = DummyOperator(
    task_id='task1',
    dag=dag,
)

t2 = DummyOperator(
    task_id='task2',
    dag=dag,
)

t1 >> t2