FROM rajneeshsharma76/jmeterbase
MAINTAINER Rajneesh sharma
ADD bin/rabbitmq-start /usr/local/bin/
# Install RabbitMQ.
RUN \
  wget -qO - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - && \
  echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y  --allow-unauthenticated rabbitmq-server && \
  rm -rf /var/lib/apt/lists/* && \
  rabbitmq-plugins enable rabbitmq_management && \
  echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config && \
  chmod +x /usr/local/bin/rabbitmq-start

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Define mount points.
VOLUME ["/data/log", "/data/mnesia"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["rabbitmq-start"]

# Expose ports.
EXPOSE 5672
EXPOSE 15672
# Set Jmeter Home

#ENV JMETER_HOME /jmeter/

# Add Jmeter to the Path
#ENV PATH $JMETER_HOME/bin:$PATH
COPY amqp-client-3.0.3.jar /jmeter/apache-jmeter-3.2/lib/
COPY JMeterAMQP.jar /jmeter/apache-jmeter-3.2/lib/ext/
#COPY Test_Plan-RabbitMQ.jmx /jmeter/apache-jmeter-3.2/bin/
#ENTRYPOINT /bin/bash
#ENTRYPOINT  /jmeter/apache-jmeter-3.2/bin/jmeter -n -t   /jmeter/apache-jmeter-3.2//bin/Test_Plan-RabbitMQ.jmx -l  /jmeter/apache-jmeter-3.2/RabbitAMQ.jtl
