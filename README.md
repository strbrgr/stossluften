# Stossluften

<!--toc:start-->
- [Stossluften](#stossluften)
  - [Documentation](#documentation)
    - [Stack](#stack)
    - [Walkthrough](#walkthrough)
      - [Reading out SCD30 Sensor Data](#reading-out-scd30-sensor-data)
      - [Using Docker Compose to run a multi-container application](#using-docker-compose-to-run-a-multi-container-application)
      - [Using Dockerfile to build a custom Image](#using-dockerfile-to-build-a-custom-image)
      - [Uninstalling InfluxDB](#uninstalling-influxdb)
      - [How to create a InfluxDB config](#how-to-create-a-influxdb-config)
      - [Run query to get data into CSV via CLI](#run-query-to-get-data-into-csv-via-cli)
      - [How to copy a local folder into a Docker container](#how-to-copy-a-local-folder-into-a-docker-container)
      - [Remote connection into your Pi](#remote-connection-into-your-pi)
        - [To securely connect to your Pi via SSH:](#to-securely-connect-to-your-pi-via-ssh)
        - [How to copy a file from your Pi to your local environment](#how-to-copy-a-file-from-your-pi-to-your-local-environment)
<!--toc:end-->

## Documentation

### Stack

- Docker Compose
- InfluxDB
<!-- - Telegraf -->
- Python
- Raspberry Pi5
- Sensirion SCD30

### Walkthrough

#### Reading out SCD30 Sensor Data

We use the [scd30_i2c](https://pypi.org/project/scd30-i2c/) library originally developed for a Raspberry Pi 4.

#### Using Docker Compose to run a multi-container application

We define two services within my Docker compose file. One for InfluxDB, a solution to record timeseries data, and one for everything related to the CO2 sensor. I run it via `docker-compose up -d`.

#### Using Dockerfile to build a custom Image

To include a virtual python environment including the scd30 library, we can build a custom [Docker Image](Link) via `docker build -t telegraf- .`. This custom image has to be specified within the Docker compose file. Make sure to rebuild the image every time you make changes to the config of your Dockerfile.

#### Uninstalling InfluxDB

At some point along the configuration we could run into issues with InfluxDB. There seems to be no good way of editing / deleting the default user so we need to perform a clean install. This is not an issue as long as the database is still empty:

```sh
sudo service influxdb stop
sudo apt remove influxdb
sudo apt remove influxdb-client
sudo apt remove influxdb2
sudo apt autoclean && sudo apt autoremove

sudo rm -rf /var/lib/influxdb/
sudo rm -rf /var/log/influxdb/
sudo rm -rf /etc/influxdb/
sudo rm -rf ~/.influxdbv2/configs
```

#### How to create a InfluxDB config
Once you figure out the docker container id that runs your database via `docker ps`, you should be able to exec into it via `docker exec -it <id> /bin/bash`. In there you create an active config in case you haven't done this:

```sh
influx config create --config-name CONFIG_NAME \
  --host-url http://localhost:8086 \
  --org ORG \
  --token API_TOKEN \
  --active
```

#### Run query to get data into CSV via CLI
To query your bucket we can use `influx query` via a three .flux files. These three files are executed through a shell script triggered by a cron job every day at 10pm:

```sh
chmod +x run_queries.sh
```

If this command does not work due to no editor like vi being available then try the other one below
```sh
crontab -e
```

This will work even if it echoes an error (you can confirm by `crontab -l`).
```sh
crontab -l | { cat; echo "0 22 * * * /run_queries.sh"; } | crontab -
```

#### How to copy a local folder into a Docker container
```sh
docker cp /home/jo/Desktop/stossluften/influx_csv my_container_id:/app/influx_csv
```

#### Remote connection into your Pi

We can either connect to our Pi via TigerVNC or via SSH. To do that we have to enable VNC and SSH via the configuration on our Pi. TigerVNC has some issues with Retina Displays and their 2x pixel density.

##### To securely connect to your Pi via SSH:
```sh
ssh <username>@<IP>
```

##### How to copy a file from your Pi to your local environment
```sh
scp username@ip:/path/on/pi/query.csv ~/path/on/local/machine
```
