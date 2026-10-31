#show table.cell.where(y:0): set text(weight: "bold")
#set table(
  fill: (x,y) =>
    if x < 1 or y == 0 {gray.lighten(65%)}
)
#let expected_i = -0.010
#let variance_i = 0.0034

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto),
    table.header([Data], [Matrix Encoding], [Moran's I], [Expected I], [Variance], [Z-Score], [p-value]),
    [ACS], [Binary], [0.147], [#expected_i], [#variance_i], [2.79], [0.0026],
    [ACS], [Row Standardized], [0.160], [#expected_i], [#variance_i], [2.94], [0.0016],
    [Census], [Binary], [0.130], [#expected_i], [#variance_i], [2.48], [0.0066],
    [Census], [Row Standardized], [0.142], [#expected_i], [#variance_i], [2.62], [0.0043]
  ),
  caption: "Moran's I results from both the ACS and Census datasets. These tests performed under the normality assumption and constant risk hypothesis."
)