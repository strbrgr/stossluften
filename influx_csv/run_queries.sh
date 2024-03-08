#!/bin/bash
current_date=$(date +'%Y-%m-%d')
export_folder="$(dirname "$0")/export"

influx query --file=query_office_co2.flux --raw > "${export_folder}/co2_${current_date}.csv"
influx query --file=query_office_humidity.flux --raw > "${export_folder}/humidity_${current_date}.csv"
influx query --file=query_office_temperature.flux --raw > "${export_folder}/temperature_${current_date}.csv"
