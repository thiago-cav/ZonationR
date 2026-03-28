# Plot coverage distribution at a given rank

This function reads a Zonation feature curves file and plots the
distribution of feature coverage values at a specified priority rank.
The output is a ggplot object, which can be further customized by the
user. Optionally, the plot can be saved to disk as a high-quality
figure.

## Usage

``` r
coverage_distribution(
  dir,
  output_folder_name = "output",
  target_rank,
  save_path = NULL,
  dpi = 300,
  width = 8,
  height = 6
)
```

## Arguments

- dir:

  Character. Path to the directory containing the Zonation output
  folder.

- output_folder_name:

  Character. Name of the Zonation output folder inside `dir` (default:
  "output").

- target_rank:

  Numeric. The rank value at which coverage distributions should be
  extracted and plotted.

- save_path:

  Character. Optional file path to save the plot. The file format is
  inferred from the specified extension (e.g. ".png", ".pdf", ".tiff").

- dpi:

  Numeric. Resolution (dots per inch) for saved figures. Default is 300.

- width:

  Numeric. Width of the saved figure in inches. Default is 8.

- height:

  Numeric. Height of the saved figure in inches. Default is 6.

## Value

A `ggplot` object showing the distribution of feature coverage values at
the specified priority rank.

## See also

Other postprocessing:
[`feature_curves()`](https://thiago-cav.github.io/ZonationR/reference/feature_curves.md),
[`feature_representation()`](https://thiago-cav.github.io/ZonationR/reference/feature_representation.md),
[`priority_map()`](https://thiago-cav.github.io/ZonationR/reference/priority_map.md),
[`rank_similarity()`](https://thiago-cav.github.io/ZonationR/reference/rank_similarity.md),
[`summary_curves()`](https://thiago-cav.github.io/ZonationR/reference/summary_curves.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Plot coverage histogram at rank 0.9
p <- coverage_distribution("01_baseline", target_rank = 0.9)
p + ggplot2::theme_classic()

# Save as PNG
coverage_distribution("01_baseline", target_rank = 0.9,
                      save_path = "coverage_hist.png")

# Save as PDF
coverage_distribution("01_baseline", target_rank = 0.9,
                      save_path = "coverage_hist.pdf")
} # }
```
