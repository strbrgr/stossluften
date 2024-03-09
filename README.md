# Stossluften

<!--toc:start-->
- [Stossluften](#stossluften)
  - [Documentation](#documentation)
    - [Stack](#stack)
    - [Walkthrough](#walkthrough)
  - [Setting up a multi container environment](#setting-up-a-multi-container-environment)
    - [Docker Compose](#docker-compose)
      - [Service 1: Creating a InfluxDB instance](#service-1-creating-a-influxdb-instance)
        - [Uninstalling InfluxDB](#uninstalling-influxdb)
      - [Service 2: Reading out SCD30 Sensor Data](#service-2-reading-out-scd30-sensor-data)
      - [How to create a InfluxDB config](#how-to-create-a-influxdb-config)
    - [CRON jobs to write to CSV on a daily basis](#cron-jobs-to-write-to-csv-on-a-daily-basis)
    - [Some neat things learned while working through this](#some-neat-things-learned-while-working-through-this)
        - [How to copy a local folder into a Docker container](#how-to-copy-a-local-folder-into-a-docker-container)
        - [Remote connection into your Pi](#remote-connection-into-your-pi)
        - [To securely connect to your Pi via SSH](#to-securely-connect-to-your-pi-via-ssh)
        - [How to copy a file from your Pi to your local environment](#how-to-copy-a-file-from-your-pi-to-your-local-environment)
        - [How to remove all files in a folder via your CLI](#how-to-remove-all-files-in-a-folder-via-your-cli)
        - [How to copy from within a Docker container to your Pi](#how-to-copy-from-within-a-docker-container-to-your-pi)
        - [Copy from Pi Desktop to local machine](#copy-from-pi-desktop-to-local-machine)
<!--toc:end-->

## Documentation

### Stack

- Raspberry Pi5
- Docker Compose
- InfluxDB
- Sensirion SCD30
- Python
- CRON Jobs

### Walkthrough

## Setting up a multi container environment

### Docker Compose
We use Docker Compose to create a multi-container environment that runs one service for our timeseries database and one related to reading out sensor data. The decision for Docker Compose was made due to the Sensors need for a virtual python environment. The Docker Compose setup itself is relatively easy, but we need to make sure to enable I2C in our SCD30 container. See the `.yml` config [here](https://github.com/strbrgr/stossluften/blob/main/docker-compose.yml). We run it detached via `docker-compose up -d` and want to make sure to not run `docker compose down` without a reason. This will stop and remove running containers.

#### Service 1: Creating a InfluxDB instance

##### Uninstalling InfluxDB

At some point along the configuration we could run into issues with our database. There seems to be no good way of editing / deleting the default user so we need to perform a clean install. This is not an issue as long as the database is still empty:

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

#### Service 2: Reading out SCD30 Sensor Data

We use the [scd30_i2c](https://pypi.org/project/scd30-i2c/) library originally developed for a Raspberry Pi 4. To actually read out data from the sensor we use Influx' [Python Client](https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/python/) and make some minor adjustments to it.

#### How to create a InfluxDB config

Once we figure out the container id that runs our database via `docker ps`, we are able to exec into it via `docker exec -it <id> /bin/bash`. In there we create an active config in case it hasn't been done:

```sh
influx config create --config-name CONFIG_NAME \
  --host-url http://localhost:8086 \
  --org ORG \
  --token API_TOKEN \
  --active
```

### CRON jobs to write to CSV on a daily basis

We wouldn't be Software Engineers without automating things. To write environment records to a CSV file on a daily basis we can run a CRON job on our Pi. As InfluxDB is running in its own container we need to create a [custom script](https://github.com/strbrgr/stossluften/blob/main/influx_csv/run_queries.sh) that first exec's into the Docker container where it will then run three flux files which will write the stdout output to a CSV file. Make sure that the `.sh` file is executable via `chmod +x run_queries.sh`. By default your Pi should come shipped with CRON. If that is the case we can add a new job via `crontab -e` where we add an entry specifying how often to run this script: `0 0 * * * /path/run_queries.sh` (This will run at hour and minute 0). If we run into an error about no editor being available we can adjust and try this:

```sh
crontab -l | { cat; echo "0 0 * * * path/run_queries.sh"; } | crontab -
```

### Some neat things learned while working through this

##### How to copy a local folder into a Docker container

`docker cp /path/ <container_id>:/path`

##### Remote connection into your Pi

We can either connect to our Pi via TigerVNC or via SSH. To do that we have to enable VNC and SSH via the configuration on our Pi. TigerVNC has some issues with Retina Displays and their 2x pixel density so we suggest to use the CLI when possible.

##### To securely connect to your Pi via SSH

`ssh user@ip`

##### How to copy a file from your Pi to your local environment

`scp username@ip:/path/ ~/path/`

##### How to remove all files in a folder via your CLI

`rm -r /dir/*`

##### How to copy from within a Docker container to your Pi

`docker cp <container_id>:/path/ ~/path/`

##### Copy from Pi Desktop to local machine

`scp user@ip:/path ~/path`
