FROM arm64v8/telegraf:1.27

# Install any dependencies required by your Python script
RUN apt-get update && apt-get install -y \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

# Create a directory for your application
WORKDIR /app

# Copy your Python script into the container
COPY scd30.py .

COPY requirements.txt .

# Install Python packages needed by your script
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy Telegraf configuration into the container
COPY ./telegraf/telegraf.conf /etc/telegraf/telegraf.conf

# Set the entrypoint to use Telegraf with the provided configuration
ENTRYPOINT ["/usr/bin/telegraf", "--config", "/etc/telegraf/telegraf.conf"]

