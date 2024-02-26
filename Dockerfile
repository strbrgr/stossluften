FROM arm64v8/telegraf:latest

# Install any dependencies required by scd30_i2c and install pip
RUN apt-get update && apt-get install -y \
  python3-venv \
  && rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python3 -m venv /venv

# Activate the virtual environment and install pip within it
RUN /venv/bin/python -m pip install --upgrade pip

# Install scd30_i2c library within the virtual environment
RUN /venv/bin/pip install scd30_i2c

# Install influxdb-client
RUN /venv/bin/pip install influxdb-client

# Copy your Python script into the container
COPY scd30.py scd30.py

# Set the entrypoint to use the virtual environment
ENTRYPOINT ["/venv/bin/python", "/scd30.py"]

