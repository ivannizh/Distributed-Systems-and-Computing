#FROM python:3.7-alpine
FROM ubuntu:latest

WORKDIR /root

ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0

EXPOSE 5000


COPY requirements.txt requirements.txt

# RUN \
# apk add --no-cache postgresql-libs && \
# apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
# python3 -m pip install -r requirements.txt --no-cache-dir && \
# apk --purge del .build-deps


RUN apt-get update -y

RUN apt-get install -y python3-pip python3-dev build-essential
RUN apt-get install -y libpq-dev python-dev

RUN python3 -m pip install -r requirements.txt --no-cache-dir


COPY . .

# CMD ["python3", "-m", "flask", "run"]

CMD ["python3", "app.py"]
