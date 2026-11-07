#import "@preview/tabut:1.0.2": tabut, records-from-csv, tabut-cells
#let data = csv("../../../data/model_outputs/model_coefficients.csv")
#let records = records-from-csv(data)

#let model_labels = (
  acs: "ACS",
  emdi_intercept_only: "Int (Freq)",
  intercept_only: "Int (Bayes)",
  cdl_only: "CDL",
  icar_only: "ICAR",
  cdl_and_icar: "Full Model"
)

#let variable_labels = (
  Intercept: "Intercept",
  b_prop_corn_soy: "Crop Proportion",
  sdcar: "ICAR Random Effects",
  sd_name__Intercept: "County Random Effects"
)

#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x == 0 or y == 0 {gray.lighten(65%)}
)

#figure(
  tabut(
    records
    .filter(r => r.model_name in ("cdl_only", "cdl_and_icar")),
    align: (left, left, auto, auto, auto, auto),
    (
      (header: [Model], func: r => model_labels.at(r.model_name)),
      (header: [Variable], func: r => variable_labels.at(r.variable)),
      (header: [$mu$], func: r => calc.round(r.mean, digits: 3)),
      (header: [$sigma$], func: r => calc.round(r.sd, digits: 3)),
      (header: [$2.5%$], func: r => calc.round(r.at("2.5%"), digits: 3)),
      (header: [$97.5%$], func: r => calc.round(r.at("97.5%"), digits: 3)),
    )
  ),
  caption: "Model Coefficients for models containing the Crop Data Layer Covariate."
) <cdl_coefficients>