#import "@preview/tabut:1.0.2": tabut, records-from-csv, tabut-cells
#let data = csv("../../../data/cdl/covariate_summary.csv")
#let records = records-from-csv(data)

#set table(
  fill: (x,y) =>
    if x == 0 or y == 0 {gray.lighten(65%)}
)

#show table.cell.where(y:0): set text(weight: "bold")

#figure(
  tabut(
    records,
    (
      (
        header: [Statistic], func: r => if r.statistic == "Q1" {
          "1st Quartile"
        } else if r.statistic == "Q3" {
          "3rd Quartile"
        } else {r.statistic}
      ),
      (header: [Corn (%)], func: r => calc.round(r.perc_corn, digits: 2)),
      (header: [Soybeans (%)], func: r => calc.round(r.perc_soy, digits: 2)),
      (header: [Corn or Soybeans (%)], func: r => calc.round(r.perc_corn_soy, digits: 2)),
    )
  ),
  caption: "Summary of the crop distribution across all Iowa counties."
) <cdl_county_summary>