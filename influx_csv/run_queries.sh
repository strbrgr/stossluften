#!/bin/bash

influx query --file=query_office_co2.flux --raw
influx query --file=query_office_humidity.flux --raw
influx query --file=query_office_temperature.flux --raw

