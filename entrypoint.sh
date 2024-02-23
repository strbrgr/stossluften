#!/bin/bash

# Protects script from continuing with an error
set -eu -o pipefail

# Ensures environment variables are set
export INFLUX_MODE=$INFLUX_MODE
export INFLUX_USERNAME=$INFLUX_USERNAME
export INFLUX_PASSWORD=$INFLUX_PASSWORD
export INFLUX_ORG=$INFLUX_ORG
export INFLUX_BUCKET=$INFLUX_BUCKET
export INFLUX_RETENTION=$INFLUX_RETENTION
export INFLUX_ADMIN_TOKEN=$INFLUX_ADMIN_TOKEN
export INFLUX_PORT=$INFLUX_PORT
export INFLUX_HOST=$INFLUX_HOST

# Conducts initial InfluxDB using the CLI
influx setup --skip-verify --bucket${INFLUX_BUCKET} --retention ${INFLUX_RETENTION} --token ${INFLUX_TOKEN} --org ${INFLUX_ORG} --username ${INFLUX_USERNAME} --password ${INFLUX_PASSWORD} --host http://${INFLUX_HOST} --force

