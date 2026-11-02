#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x < 1 or y == 0 {gray.lighten(65%)}
)
// #figure(
//   table(
//     columns: (auto, auto, auto, auto),
//     table.header([Metric], [Total Unit SE], [Vacant Unit SE], [Vacancy Rate SE]),
//     [Minimum], [14.59],[43.77],[0.003],
//     [1st Quartile], [27.36],[79.64],[0.011],
//     [Median], [42.55],[103.34],[0.011],
//     [Mean], [50.85],[129.06],[0.014],
//     [3rd Quartile], [60.49],[142.55],[0.017],
//     [Maximum], [265.65],[618.24],[0.027],
//   ),
//   caption: "Summary of the estimate standard errors from the ACS. (N=99)"
// ) <acs_error_summary>

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto),
    table.header(
      [Metric], [Total SE], [Vacant SE], [Rate SE],
      [Relative Total SE], [Relative Vacant SE], [Relative Rate SE]
    ),
    [Minimum], [14.59], [43.77], [0.003], [0.000959], [0.02784], [0.02782],
    [Q1], [27.36], [79.64], [0.011], [0.003855], [0.10164], [0.10164],
    [Median], [42.55], [103.34], [0.011], [0.005198], [0.12230], [0.12230],
    [Mean], [50.85], [129.06], [0.014], [0.005782], [0.12231], [0.12231],
    [Q3], [60.49], [142.55], [0.017], [0.006975], [0.14533], [0.14532],
    [Maximum], [265.65], [618.24], [0.027], [0.024768], [0.25127], [0.25127],
  ),
  caption: "Summary of the estimate standard errors and relative standard errors from the ACS. The relative columns are calculated using (SE / Estimate) for each given estimate. Some adjustments to metric and column names made to preserve space."
) <acs_error_summary>