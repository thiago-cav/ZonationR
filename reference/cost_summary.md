# Summarize remaining cost at specified landscape proportions

Reads a Zonation `summary_curves.csv` file (space-separated), finds the
row closest to each value in `landscape_prop`, and returns remaining
cost and percentage of maximum cost at those proportions. Optionally
writes the result to `dir/performance/cost_summary.csv`.

## Usage

``` r
cost_summary(
  dir,
  output_folder_name = "output",
  landscape_prop,
  save_output = FALSE
)
```

## Arguments

- dir:

  Character. Path to the directory containing the Zonation output
  folder.

- output_folder_name:

  Character. Name of the output folder inside `dir`. Default is
  "output".

- landscape_prop:

  Numeric vector. Landscape proportions (rank values) at which to report
  cost (e.g. `c(0.03, 0.2, 0.5)`).

- save_output:

  Logical. If TRUE, the result is written as a CSV to
  `dir/performance/cost_summary.csv`. Default FALSE.

## Value

A data frame with columns:

- `rank` - the requested proportion

- `remaining_cost` - remaining cost at that rank

- `percentage` - remaining cost as percentage of maximum cost

## See also

Other postprocessing:
[`coverage_distribution()`](https://thiago-cav.github.io/ZonationR/reference/coverage_distribution.md),
[`feature_curves()`](https://thiago-cav.github.io/ZonationR/reference/feature_curves.md),
[`feature_representation()`](https://thiago-cav.github.io/ZonationR/reference/feature_representation.md),
[`priority_map()`](https://thiago-cav.github.io/ZonationR/reference/priority_map.md),
[`rank_similarity()`](https://thiago-cav.github.io/ZonationR/reference/rank_similarity.md),
[`summary_curves()`](https://thiago-cav.github.io/ZonationR/reference/summary_curves.md)

## Examples

``` r
# \donttest{
withr::with_tempdir({

  dir.create("output")

  # simulate Zonation-style summary_curves.csv structure
  write.table(
    data.frame(
      rank = seq(0, 1, length.out = 10),
      remaining_cost = runif(10, 50, 100),
      dummy1 = runif(10),
      dummy2 = runif(10)
    ),
    file = file.path("output", "summary_curves.csv"),
    row.names = FALSE,
    col.names = TRUE,
    sep = " "
  )

  cost_summary(
    dir = ".",
    output_folder_name = "output",
    landscape_prop = c(0.2, 0.5, 0.8)
  )

})
#>   rank remaining_cost percentage
#> 1  0.2       58.73379   66.01867
#> 2  0.5       74.68185   83.94480
#> 3  0.8       85.66986   96.29568
# }
```
