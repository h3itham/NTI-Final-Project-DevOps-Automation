FROM python:3.10

WORKDIR /django

ENV PYTHONUNBUFFERED=1

RUN pip install --upgrade pip

COPY ./requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["gunicorn", "core.wsgi", "--bind", "0.0.0.0:8001"]

