import "date"

from(bucket: "office")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "environment")
  |> filter(fn: (r) => r._field == "temperature")
  |> to(csv: "/export/temperature-" + date.truncate(t: now(), unit: 1d) + ".csv")
