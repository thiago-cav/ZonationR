# Calculate similarity between Zonation rank maps

This function calculates similarity between two spatial rank maps using
Schoener's D or the Jaccard index.

## Usage

``` r
rank_similarity(
  r1 = NULL,
  r2 = NULL,
  rstack = NULL,
  method = c("schoener", "jaccard"),
  threshold = NULL
)
```

## Arguments

- r1:

  A `SpatRaster` rank map (from the `terra` package). Required if
  `rstack` is not provided.

- r2:

  A `SpatRaster` rank map with the same dimensions as `r1`. Required if
  `rstack` is not provided.

- rstack:

  A `SpatRaster` with multiple layers. If provided, the function
  calculates pairwise coefficients between all layers.

- method:

  Character, either `"schoener"` (default) or `"jaccard"`.

- threshold:

  Numeric, required if `method = "jaccard"`. Cells with rank greater
  than or equal to this threshold are considered selected.

## Value

A numeric value between 0 and 1 if comparing two rasters, or a matrix of
pairwise coefficients if using `rstack`.

## See also

Other postprocessing:
[`cost_summary()`](https://thiago-cav.github.io/ZonationR/reference/cost_summary.md),
[`coverage_distribution()`](https://thiago-cav.github.io/ZonationR/reference/coverage_distribution.md),
[`feature_curves()`](https://thiago-cav.github.io/ZonationR/reference/feature_curves.md),
[`feature_representation()`](https://thiago-cav.github.io/ZonationR/reference/feature_representation.md),
[`priority_map()`](https://thiago-cav.github.io/ZonationR/reference/priority_map.md),
[`summary_curves()`](https://thiago-cav.github.io/ZonationR/reference/summary_curves.md)

## Examples

``` r
# Create two example priority rank maps
r1 <- terra::rast(nrows = 5, ncols = 5)
terra::values(r1) <- runif(terra::ncell(r1))

r2 <- terra::rast(r1)
terra::values(r2) <- runif(terra::ncell(r2))

# Schoener's D
rank_similarity(r1, r2, method = "schoener")
#> [1] 0.642128

# Jaccard index with threshold
rank_similarity(r1, r2, method = "jaccard", threshold = 0.7)
#> [1] 0.2
```
