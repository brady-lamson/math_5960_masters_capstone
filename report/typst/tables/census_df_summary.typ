#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x < 1 or y == 0 {gray.lighten(65%)}
)
#figure(
  table(
    columns: (auto, auto, auto, auto),
    table.header([Metric], [Total Units], [Vacant Units], [Vacancy Rate]),
    [Minimum], [1888], [274], [0.05950],
    [1st Quartile], [4684], [518], [0.07892],
    [Median], [7037], [701], [0.10144],
    [Mean], [14271], [1255], [0.10842],
    [3rd Quartile], [10947], [1131], [0.11803],
    [Maximum], [210184], [13293], [0.41743],
  ),
  caption: "Summary of the housing data from the 2020 decennial census. (N=99)"
)