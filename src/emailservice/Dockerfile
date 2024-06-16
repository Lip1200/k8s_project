FROM python:3.12-slim

WORKDIR /emailservice

RUN apt-get update && apt-get install -y \
    wget \
    g++ 

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8080

ENTRYPOINT ["python", "email_server.py"]
