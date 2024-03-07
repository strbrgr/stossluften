import "date"

from(bucket: "office")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "environment")
  |> filter(fn: (r) => r._field == "humidity")
  |> to(csv: "/export/humidity-" + date.truncate(t: now(), unit: 1d) + ".csv")
