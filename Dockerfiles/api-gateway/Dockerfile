FROM python:3.12-alpine

WORKDIR /usr/src/

RUN apk add --no-cache gcc musl-dev libffi-dev && \
    pip install --no-cache-dir flask requests pika python-dotenv flask-restx importlib-metadata

COPY . .

EXPOSE 3000

CMD ["python", "server.py"]
