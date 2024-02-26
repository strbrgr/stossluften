# Use the ARM version of the Telegraf base image
FROM arm64v8/telegraf:1.27

# Install any dependencies required by scd30_i2c and install pip
RUN apt-get update && apt-get install -y \
  python3 \
  python3-venv \
  && rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python3 -m venv /venv

# Activate the virtual environment and install pip within it
RUN /venv/bin/python -m pip install --upgrade pip

# Install scd30_i2c library within the virtual environment
RUN /venv/bin/pip install scd30_i2c

# Create a directory for your application
WORKDIR /app

# Copy your Python script into the container
COPY scd30.py .

# Check if telegraf binary is present
RUN which telegraf

# Copy Telegraf configuration into the container
COPY ./telegraf/telegraf.conf /etc/telegraf/telegraf.conf

# Set the entrypoint to use Telegraf with the provided configuration
ENTRYPOINT ["/usr/bin/telegraf", "--config", "/etc/telegraf/telegraf.conf"]
