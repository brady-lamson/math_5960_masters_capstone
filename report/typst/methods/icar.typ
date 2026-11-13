== Spatial Random Effects

The traditional Fay-Herriot model assumes the spatial random effects are identically distributed independent random variables from a normal distribution with an unknown variance. This assumption is often inappropriate for the task of small area estimation, where autocorrelation between neighboring areas is expected. There has been a large amount of work historically in spatial variants of the Fay-Herriot model. This project will be using an Intrinsic Conditional Auto-Regressive model (ICAR) for the spatial random effects as used by Porter et al. @PORTER201427. The ICAR component used by the `brms` package is built off the work done by Mitzi Morris @icarMitzi. 

To facilitate the use of this component, an adjacency matrix was created using the county TIGER shapefiles provided by the Census Bureau alongside the `spdep` package. 

Let $W$ represent the binary adjacency matrix where:

$
  w_(i,j) = cases(
  1 &quad "if counties i and j are adjacent and" i != j,
  0 &quad "otherwise"
)
$

and

$
  d_i = sum_j w_(i,j)
$

represent the number of neighbors for each county. For this matrix, queen contiguity is used, so counties sharing a boundary or vertex are considered adjacent. From this, define the distribution of $mu_i$ from @fh_theta as 

$
  mu_i | {mu_(i != j)} tilde N(sum_(i tilde j) mu_j / d_i, sigma^2_(mu) / d_i),
$

where $i tilde j$ denotes that the regions $i$ and $j$ are neighbors @PORTER201427. This structure allows neighboring counties to have similar random effects adjusted by the number of neighboring counties. 

The prior distribution for the standard deviation of the spatial random effects match those found in @int_priors. 

#math.equation(
  $
    p(beta_0) &= t_3(beta_0 | -2.1, 2.5) \
    p(sigma_(mu)) &= t_3^+(sigma_(mu) | 0, 2.5) \
  $
)<icar_priors>