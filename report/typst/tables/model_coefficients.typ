#import "@preview/tabut:1.0.2": tabut, records-from-csv, tabut-cells
#let data = csv("../../../data/model_outputs/model_coefficients.csv")
#let records = records-from-csv(data)

#let model_labels = (
  acs: "ACS",
  intercept_only_frequentist: "Int (Freq)",
  intercept_only: "Int (Bayes)",
  cdl_only: "CDL Only",
  icar_only: "ICAR",
  cdl_and_icar: "Full Model"
)

#let variable_labels = (
  Intercept: "Intercept",
  b_prop_corn_soy: "Crop Proportion",
  sdcar: "ICAR Random Effects",
  sd_name__Intercept: "County Random Effects",
  estimated_sd_component: "County Random Effects"
)

#let sorted_records = records.sorted(
  key: r =>
    if r.variable == "Intercept" { 0 }
    else if r.variable in ("sd_name__Intercept", "estimated_sd_component") { 1 }
    else if r.variable == "sdcar" { 2 }
    else if r.variable == "b_prop_corn_soy" { 3 }
    else { 4 }
)

#show table.cell.where(y:0): set text(weight: "bold")
#show table.cell.where(x:1): set text(size: 10pt)
// #set table(
//   fill: (x,y) =>
//     if x == 0 or y == 0 {gray.lighten(65%)}
// )

#set table(
  fill: (x, y) => {
    if y == 0 {
      gray.lighten(65%)
    } else if y in (1, 3, 5, 7, 10) {
      rgb("#cf47477b") // Intercept
    } else if y in (2, 4, 9) {
      rgb("#DCEAF7") // Random effects
    } else if y in (6, 12) {
      rgb("#E5F0E0") // ICAR random effects
    } else if y in (8, 11) {
      rgb("#F8E8D8") // Crop proportion
    } else {
      white
    }
  }
)

#figure(
  tabut(
    records,
    // sorted_records,
    align: (left, left, auto, auto, auto, auto),
    (
      (header: [Model], func: r => model_labels.at(r.model_name)),
      (header: [Variable], func: r => variable_labels.at(r.variable)),
      (header: [Estimate], func: r => calc.round(r.estimate, digits: 3)),
      (
        header: [SD],
        func: r => if r.sd == "NA" {[---]}
          else {calc.round(float(r.sd), digits: 3)}
      ),
      (
        header: [Lower Bound],
        func: r => if r.lower == "NA" {[---]}
          else {calc.round(float(r.lower), digits: 3)}
      ),
      (
        header: [Upper Bound],
        func: r => if r.upper == "NA" {[---]}
          else {calc.round(float(r.upper), digits: 3)}
      ),
    )
    )
  ,
  caption: "Coefficient distributions. Estimate for the Bayesian models represents the mean of the posterior distribution for that variable. Lower and Upper correspond to the 2.5% and 97.5% percentiles of the coefficients credible/confidence intervals respectively."
) <model_coefficients>