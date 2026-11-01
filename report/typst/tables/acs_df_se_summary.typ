#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x < 1 or y == 0 {gray.lighten(65%)}
)
#figure(
  table(
    columns: (auto, auto, auto, auto),
    table.header([Metric], [Total Units], [Vacant Units], [Vacancy Rate]),
    [Minimum], [2011], [296], [0.0500],
    [1st Quartile], [4934], [610.5], [0.0900],
    [Median], [7199], [776], [0.0107],
    [Mean], [14220], [1352.3], [0.1210],
    [3rd Quartile], [11048], [1370], [0.1422],
    [Maximum], [204110], [12985], [0.3964],
  ),
  caption: "Summary of the estimate standard errors from the ACS. (N=99)"
) <acs_error_summary>