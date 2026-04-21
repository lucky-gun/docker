FROM python:3.9-alpine
WORKDIR usr/src/program
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY ./program .
RUN mkdir -p ./log
