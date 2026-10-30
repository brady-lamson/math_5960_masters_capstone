#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x < 1 or y == 0 {gray.lighten(65%)}
)
#figure(
  table(
    columns: (auto, auto, auto, auto),
    table.header([County],[Total Housing Units], [Vacant Housing Units], [Vacancy Rate]),
    [Polk], [210184], [13293], [0.06],
    [Grundy], [5465], [396], [0.07],
    [...], [...], [...], [...]
  ),
  caption: "Snippet of the Census DataFrame containing the true values for model evaluation. Non-proportion columns retained for the sake of reference and demonstration."
)