FROM python:3.12-alpine

WORKDIR /usr/src/

# COPY requirements.txt ./

RUN pip3 install flask sqlalchemy psycopg2-binary python-dotenv Flask-SQLAlchemy


COPY . .

EXPOSE 8080

CMD ["python", "server.py"]

