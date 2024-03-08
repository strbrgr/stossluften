#!/bin/bash
current_date=$(date +'%Y-%m-%d')

influx query --file=query_office_co2.flux --raw > "co2_$current_date}.csv"
influx query --file=query_office_humidity.flux --raw > "humidity_$current_date}.csv"
influx query --file=query_office_temperature.flux --raw > "temperature_$current_date}.csv"
