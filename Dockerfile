# Use the ARM version of the Telegraf base image
FROM arm64v8/telegraf:1.27

# Install Python 3 and pip
RUN apt-get update && apt-get install -y \
  python3 \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy your Python script into the container
COPY scd30.py .

# Install scd30_i2c library
RUN pip3 install scd30_i2c

# Copy Telegraf configuration into the container
COPY ./telegraf/telegraf.conf /etc/telegraf/telegraf.conf

# Set the entrypoint to use Telegraf with the provided configuration
ENTRYPOINT ["/usr/bin/telegraf", "--config", "/etc/telegraf/telegraf.conf"]

