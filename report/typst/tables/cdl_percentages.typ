#import "@preview/tabut:1.0.2": tabut, records-from-csv, tabut-cells
#let usa_data = csv("../../../data/cdl/usa_cdl_frequency.csv")
#let iowa_data = csv("../../../data/cdl/iowa_cdl_frequency.csv")

#let usa_records = records-from-csv(usa_data)
#let iowa_records = records-from-csv(iowa_data)

#let start = 0
#let end = 7
#let iowa_head = iowa_records.slice(start, end)
#let usa_head = usa_records.slice(start, end)

#set table(
  fill: (x,y) =>
    if x == 0 or y < 2 {gray.lighten(65%)}
)

#let crop_table(data, title) = table(
  columns: 2,
  table.header(
    table.cell(colspan: 2, align: center)[*#title*],
    [*Crop*], [*Percentage*],
  ),
  ..tabut-cells(
    data,
    (
      (func: r => r.crop),
      (func: r => calc.round(r.percentage, digits: 2)),
    ),
    headers: false,
  )
)

#let usa_table = crop_table(usa_head, [USA])
#let iowa_table = crop_table(iowa_head, [Iowa])

#figure(
  grid(
    columns: 2,
    [#usa_table],
    [#iowa_table]
  ),
  caption: "Top crops by percentage of land classification for both the full USA CDL and Iowa subset. Top 7 rows."
) <crop_percentages>