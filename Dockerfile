FROM python:3.10

WORKDIR /django

ENV PYTHONUNBUFFERED=1

RUN pip install --upgrade pip

COPY ./django/requirements.txt .

RUN pip install -r requirements.txt

COPY ./django/ .

RUN python manage.py migrate 

CMD ["gunicorn", "core.wsgi", "--bind", "0.0.0.0:80"]

