FROM rabbitmq:3-management-alpine

# Enable RabbitMQ management plugin
RUN rabbitmq-plugins enable rabbitmq_management

# Add wait-for-it script
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod +x /usr/local/bin/wait-for-it

# Add a script to set up RabbitMQ
COPY setup-rabbitmq.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-rabbitmq.sh

# Set the script to run when the container starts
CMD ["/usr/local/bin/setup-rabbitmq.sh"]

EXPOSE 5672
