# Base image: Use the official PostgreSQL image
FROM postgres:14-alpine

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Expose port 5432 for database access
EXPOSE 5432

# Use a volume for persistent database storage
VOLUME ["/var/lib/postgresql/data"]

