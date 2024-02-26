from scd30_i2c import SCD30
import time


scd30 = SCD30()
scd30.set_measurement_interval(2)
scd30.start_periodic_measurement()

URL = "http://192.168.0.21:8086"
TOKEN = "admintoken"
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


def write_to_telegraf(data):
    co2, temp, rh = data

    line_protocol = (
        f"co2,location=office value={co2}\n"
        f"temperature,location=office value={temp}\n"
        f"humidity,location=office value={rh}\n"
    )
    print(line_protocol)


def main():
    # Give sensor enough time to power up
    time.sleep(2)
    while True:
        sensor_data = read_sensor_data()
        write_to_telegraf(sensor_data)
        time.sleep(2)


if __name__ == "__main__":
    main()
