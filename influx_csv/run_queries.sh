#!/bin/bash

docker execute "stossluften-influxdb-1" /bin/bash -c '
  current_date=$(date +'%Y-%m-%d')

  influx query --file=/influx_csv/query_office_co2.flux --raw > "/influx_csv/export/co2_${current_date}.csv"
  influx query --file=/influx_csv/query_office_humidity.flux --raw > "/influx_csv/export/humidity_${current_date}.csv"
  influx query --file=/influx_csv/query_office_temperature.flux --raw > "/influx_csv/export/temperature_${current_date}.csv"
'
