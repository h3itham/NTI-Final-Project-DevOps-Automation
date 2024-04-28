FROM python:3.10-alpine

WORKDIR /django

COPY ./django/requirements.txt /django/

RUN apk update && \
    apk add --no-cache python3-dev mariadb-dev build-base libffi-dev openssl-dev && \
    pip install --no-cache-dir -r requirements.txt

COPY ./django /django//

RUN python manage.py migrate

CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]