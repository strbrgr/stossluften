from scd30_i2c import SCD30
import time

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
