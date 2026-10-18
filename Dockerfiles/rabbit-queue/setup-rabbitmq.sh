#!/bin/sh

# Start RabbitMQ in the background
rabbitmq-server &

# Wait for RabbitMQ to be ready
/usr/local/bin/wait-for-it localhost:5672 -t 30

# Wait for RabbitMQ to start
sleep 10

# Add user and set permissions
rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASSWORD
rabbitmqctl set_user_tags $RABBITMQ_USER administrator
rabbitmqctl set_permissions -p / $RABBITMQ_USER ".*" ".*" ".*"

wait
