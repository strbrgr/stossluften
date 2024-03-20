#!/bin/bash

docker execute "stossluften-influxdb-1" /bin/bash -c '
  current_date=$(date -d "yesterday" +'%Y-%m-%d')

  influx query --file=/db/query_office_co2.flux --raw > "/db/export/co2_${current_date}.csv"
  influx query --file=/db/query_office_humidity.flux --raw > "/db/export/humidity_${current_date}.csv"
  influx query --file=/db/query_office_temperature.flux --raw > "/db/export/temperature_${current_date}.csv"
'
