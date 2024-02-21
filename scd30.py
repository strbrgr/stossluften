from scd30_i2c import SCD30
import time
# import influxdb_client, os, time
# from influxdb_client import InfluxDBClient, Point, WritePrecision
# from influxdb_client.client.write_api import SYNCHRONOUS
#
# token = os.environ.get("INFLUXDB_TOKEN")
# org = "jo_enterprise"
# url = "http://localhost:8086"
#
# write_client = influxdb_client.InfluxDBClient(url=url, token=token, org=org)
#
# bucket = "co2_bucket"
#
# write_api = client.write_api(write_options=SYNCHRONOUS)
#
# for value in range(5):
#     point = Point("measurement1").tag("tagname1", "tagvalue1").field("field1", value)
#     write_api.write(bucket=bucket, org="jo_enterprise)", record=point)
#     time.sleep(1)  # separate points by 1 second

scd30 = SCD30()

scd30.set_measurement_interval(2)
scd30.start_periodic_measurement()

time.sleep(2)

while True:
    if scd30.get_data_ready():
        m = scd30.read_measurement()
        if m is not None:
            co2 = m[0]
            temp = m[1]
            rh = m[2]
            timestamp = int(time.time() * 1000000000)  # Convert to nanoseconds
            line_protocol = (
                f"co2,location=office value={co2}\n"
                f"temperature,location=office value={temp}\n"
                f"humidity,location=office value={rh}\n"
            )
            print(line_protocol, end="")
        # time.sleep(2)
    else:
        time.sleep(0.2)
