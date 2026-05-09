FROM python:3.12-alpine

RUN apk add --no-cache openssh-client && \
    pip install --no-cache-dir ansible boto3 botocore

WORKDIR /workspace
