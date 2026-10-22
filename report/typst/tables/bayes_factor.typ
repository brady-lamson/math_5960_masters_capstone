#import "@preview/tabut:1.0.2": tabut, records-from-csv
#let raw_data = csv("../../../data/model_outputs/bayes_factor.csv")
#let records = records-from-csv(raw_data)

#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x < 2 or y == 0 {gray.lighten(65%)}
)

#tabut(
  records,
  stroke: (x: none),
  align: (center, center, right, right),
  (
    (header: [*Model A*], func: row => row.fitA),
    (header: [*Model B*], func: row => row.fitB),
    (header: [*Bayes Factor (A/B)*], func: row => calc.round(float(row.bf_mean), digits: 8)),
    (header: [*Bayes Factor (B/A)*], func: row => calc.round(1 / float(row.bf_mean), digits: 3))
  )
)