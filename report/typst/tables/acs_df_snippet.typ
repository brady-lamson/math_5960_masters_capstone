#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x < 1 or y == 0 {gray.lighten(65%)}
)
#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    table.header([County],[Est Vacancy Rate], [SE], [Est Vacancy Rate (Logit)], [SE (Logit)]),
    [Polk], [0.064], [0.003], [-2.69], [0.05],
    [Grundy], [0.076], [0.011], [-2.50], [0.154],
    [...], [...], [...], [...], [...]
  ),
  caption: "Snippet of ACS Dataframe used for modeling. Untransformed columns included for the sake of reference and demonstration."
)