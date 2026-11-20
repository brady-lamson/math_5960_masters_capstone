#show table.cell.where(y:0): set text(weight: "bold")
#show table.cell.where(y: 0): set text(weight: "bold")
#set table(
  fill: (x, y) =>
    if y == 0 {
      gray.lighten(65%)
    } else if y <= 3 {
      rgb("#E8F1FA")
    } else if y <= 6 {
      rgb("#F2EDE3")
    } else {
      rgb("#E9F2E8")
    }
)

#figure(
  table(
    columns: 8,
    align: (left, left, right, right, right, right, right, center),
    [*County*], [*Model*], [*Estimate*], [*True Rate*], [*Residual*], [*Lower*], [*Upper*], [*Captured*],

    [Cedar], [ACS], [0.0936], [0.0728], [0.0209], [0.0724], [0.1204], [Yes],
    [Cedar], [Intercept], [0.0961], [0.0728], [0.0234], [0.0751], [0.1209], [No],
    [Cedar], [ICAR], [0.0935], [0.0728], [0.0207], [0.0729], [0.1175], [No],

    [Dickinson], [ACS], [0.3964], [0.4174], [-0.0210], [0.3750], [0.4182], [Yes],
    [Dickinson], [Intercept], [0.3921], [0.4174], [-0.0254], [0.3710], [0.4138], [No],
    [Dickinson], [ICAR], [0.3917], [0.4174], [-0.0257], [0.3706], [0.4134], [No],

    [Henry], [ACS], [0.0979], [0.0776], [0.0203], [0.0740], [0.1285], [Yes],
    [Henry], [Intercept], [0.1004], [0.0776], [0.0228], [0.0768], [0.1288], [Yes],
    [Henry], [ICAR], [0.1017], [0.0776], [0.0241], [0.0781], [0.1300], [No],
  ),
  caption: "Results from counties that fall inside ACS prediction intervals but outside of SAE prediction intervals. Rows colored by county to aid readability."
) <missed_counties>
