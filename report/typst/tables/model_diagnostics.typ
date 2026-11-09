#import "@preview/tabut:1.0.2": tabut, records-from-csv
#let model_order = (
  "intercept_only",
  "cdl_only",
  "icar_only",
  "cdl_and_icar"
)
#let model_labels = (
  intercept_only: "Intercept Only",
  cdl_only: "CDL",
  icar_only: "ICAR",
  cdl_and_icar: "Full Model"
)
#let data = csv("../../../data/model_outputs/model_diagnostics.csv")
#let records = records-from-csv(data)
#let records = model_order.map(name =>
  records.filter(r => r.model_name == name).first()
)

#show table.cell.where(y:0): set text(weight: "bold", size: 10pt)
#set table(
  fill: (x,y) =>
    if x == 0 or y == 0 {gray.lighten(65%)}
)

#let draws = 20000

#figure(
  tabut(
    records,
    align: (left, auto, auto, auto, auto, auto),
    (
      (header: [Model], func: r => model_labels.at(r.model_name)),
      (header: [Max $hat(r)$], func: r => calc.round(r.max_rhat, digits: 4)),
      (header: [Min Bulk ESS], func: r => calc.round(r.min_ess_bulk, digits: 0)),
      (header: [Med Bulk ESS], func: r => calc.round(r.med_ess_bulk, digits: 0)),
      (header: [Min Tail ESS], func: r => calc.round(r.min_ess_tail, digits: 0)),
      (header: [Med Tail ESS], func: r => calc.round(r.med_ess_tail, digits: 0)),
    )
  ),
  caption: "Model diagnostic summary. All models have 20,000 post warmup draws."
) <model_diagnostics>