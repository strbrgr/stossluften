#!/bin/bash
current_date=$(date +'%Y-%m-%d')

influx query --file=query_office_co2.flux --raw > "export/co2_${current_date}.csv"
influx query --file=query_office_humidity.flux --raw > "export/humidity_${current_date}.csv"
influx query --file=query_office_temperature.flux --raw > "export/temperature_${current_date}.csv"
