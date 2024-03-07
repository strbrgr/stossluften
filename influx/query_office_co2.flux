import "date"

from(bucket: "office")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "environment")
  |> filter(fn: (r) => r._field == "co2")
  |> to(csv: "/influx_csv/co2-" + date.truncate(t: now(), unit: 1d) + ".csv")
