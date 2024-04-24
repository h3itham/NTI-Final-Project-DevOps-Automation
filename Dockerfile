FROM python:3.10-alpine

WORKDIR /app

COPY ./app/requirements.txt /app/

RUN apk update && \
    apk add --no-cache python3-dev mariadb-dev build-base libffi-dev openssl-dev && \
    pip install --no-cache-dir -r requirements.txt

COPY ./app /app/

RUN python manage.py migrate

CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]
