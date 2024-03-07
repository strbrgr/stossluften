#!/bin/bash

flux query run --file=query_office_co2.flux
flux query run --file=query_office_humidity.flux
flux query run --file=query_office_temperature.flux

