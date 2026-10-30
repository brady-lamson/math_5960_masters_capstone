#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x < 1 or y == 0 {gray.lighten(65%)}
)
#figure(
  table(
    columns: (auto, auto, auto, auto),
    table.header([County],[Soybeans (%)], [Corn (%)], [Corn or Soy (%)]),
    [Polk], [17.8], [22.4], [40.2],
    [Grundy], [36.0], [52.5], [88.5],
    [...], [...], [...], [...]
  ),
  caption: "Snippet of the CDL DataFrame containing the spatial covariate of the model. The individual soy and corn columns are kept for reference."
)