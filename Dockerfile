FROM python:latest

WORKDIR /app

COPY ./app/requirements.txt /app/

RUN apt-get update && apt-get install -y python3-dev default-libmysqlclient-dev build-essential pkg-config

RUN pip install --no-cache-dir -r requirements.txt

COPY ./app /app/

RUN paython manage.py migrate 

CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]