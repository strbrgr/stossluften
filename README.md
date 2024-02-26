# Stossluften

<!--toc:start-->
- [Stossluften](#stossluften)
  - [Documentation](#documentation)
    - [Stack](#stack)
    - [Walkthrough](#walkthrough)
      - [Reading out SCD30 Sensor Data](#reading-out-scd30-sensor-data)
      - [Using Docker Compose to run a multi-container application](#using-docker-compose-to-run-a-multi-container-application)
<!--toc:end-->

## Documentation

### Stack

- Docker Compose
- InfluxDB
- Telegraf
- Python
- Raspberry Pi5
- Sensirion SCD30

### Walkthrough

#### Reading out SCD30 Sensor Data

I am using the [scd30_i2c](https://pypi.org/project/scd30-i2c/) library originally developed for a Raspberry Pi 4.

#### Using Docker Compose to run a multi-container application

I defined two services within my Docker compose file. One for InfluxDB, a solution to record timeseries data, and one for Telegraf, an open source server agent to send my data to InfluxDB. I run it via `docker-compose up -d`.

#### Using Dockerfile to build a custom Image

To include a virtual python environment including the scd30 library, I built a custom [Docker Image](Link) via  `docker build -t telegraf- .`. This custom image has to be specified within the docker compose file. Make sure to rebuild the image every time you make changes to the config of your Dockerfile.

#### Uninstalling InfluxDB

At some point along the configuration I ran into issues with InfluxDB. There seems to be no good way of editing / deleting the default user so I needed to perform a clean install. This was not an issue as my DB was still empty. I used the following lines to delete the InfluxDB installation from my Raspberry Pi:

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
