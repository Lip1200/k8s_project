FROM python:3.12-alpine

WORKDIR /emailservice

RUN apt-get update && apt-get install -y wget g++

COPY requirements.txt . 

RUN pip install -r requirements.txt

COPY . . 

EXPOSE 8080

ENTRYPOINT [ "python", "email_server.py" ]