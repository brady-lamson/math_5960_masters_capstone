#import "@preview/tabut:1.0.2": tabut, records-from-csv
#let model_order = (
  "acs",
  "intercept_only",
  "cdl_only",
  "icar_only",
  "cdl_and_icar"
)
#let model_labels = (
  acs: "ACS",
  intercept_only: "Intercept Only",
  cdl_only: "CDL",
  icar_only: "ICAR",
  cdl_and_icar: "ICAR & CDL"
)
#let model_summary = csv("../../../data/model_outputs/all_model_summary.csv")

#let records = records-from-csv(model_summary)
// Re-order rows for the table
#let data = model_order.map(name =>
  records.filter(r => r.model_name == name).first()
)

#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x == 0 or y == 0 {gray.lighten(65%)}
)

#figure(
  tabut(
    data,
    stroke: (x: none),
    align: (center),
    (
      (header: [Model], func: r => model_labels.at(r.model_name)),
      (header: [MSE], func: r => calc.round(float(r.mse), digits:6)),
      (header: [MAE], func: r => calc.round(r.mae, digits:5)),
      (header: [Mean SD], func: r => calc.round(r.mean_sd, digits: 5)),
      (header: [Mean Interval Width], func: r => calc.round(r.mean_interval_width, digits: 5)),
      (header: [Interval Coverage], func: r => calc.round(r.interval_coverage, digits:4)),
      (
        header: [Mean CRPS], 
        func: r => if r.mean_crps == "NA" {[---]} 
          else {
            calc.round(float(r.mean_crps), digits: 6)
          }
      ),
    )
  ),
  caption: [Summary metrics for all models. ]
)