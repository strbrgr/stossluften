from scd30_i2c import SCD30
import time
import influxdb_client
from influxdb_client.client.write_api import SYNCHRONOUS


scd30 = SCD30()
scd30.set_measurement_interval(2)
scd30.start_periodic_measurement()


# INfluxDB vars
URL = "http://192.168.0.21:8086"
TOKEN = "mytoken"
ORG = "jorg"
BUCKET = "office"


def read_sensor_data():
    if scd30.get_data_ready():
        m = scd30.read_measurement()
        if m is not None:
            co2 = m[0]
            temp = m[1]
            rh = m[2]

            return (co2, temp, rh)
    else:
        time.sleep(0.2)


def write_to_influxdb(data):
    # Define client
    client = influxdb_client.InfluxDBClient(url=URL, token=TOKEN, org=ORG)
    write_api = client.write_api(write_options=SYNCHRONOUS)

    co2, temp, rh = data

    records = [
        {
            "measurement": "co2",
            "tags": {"location": "office"},
            "fields": {"value": co2},
        },
        {
            "measurement": "temperature",
            "tags": {"location": "office"},
            "fields": {"value": temp},
        },
        {
            "measurement": "humidity",
            "tags": {"location": "office"},
            "fields": {"value": rh},
        },
    ]

    write_api.write(bucket=BUCKET, org=ORG, record=records)


def main():
    time.sleep(2)
    while True:
        sensor_data = read_sensor_data()
        write_to_influxdb(sensor_data)
        time.sleep(2)


if __name__ == "__main__":
    main()
