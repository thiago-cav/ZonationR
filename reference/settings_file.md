# Create a settings file for a Zonation analysis

This function generates a settings file with various parameters related
to the input data and analysis configuration. The resulting settings
file is saved with a `.z5` extension and can be used directly in the
Zonation software.

## Usage

``` r
settings_file(
  feature_list_file,
  external_solution_file = NULL,
  analysis_area_mask_layer = NULL,
  hierarchic_mask_layer = NULL,
  cost_layer = NULL
)
```

## Arguments

- feature_list_file:

  A character string specifying the feature list file. This is a
  compulsory parameter.

- external_solution_file:

  A character string specifying the full path and/or name of the
  external solution file.

- analysis_area_mask_layer:

  A character string specifying the full path and/or name of the
  analysis area mask layer file.

- hierarchic_mask_layer:

  A character string specifying the full path and/or name of the
  hierarchic mask layer file.

- cost_layer:

  A character string specifying the full path and/or name of the cost
  layer file.

## Value

A `.z5` file containing the specified settings.

## See also

Other preprocessing:
[`command_file()`](https://thiago-cav.github.io/ZonationR/reference/command_file.md),
[`feature_list()`](https://thiago-cav.github.io/ZonationR/reference/feature_list.md)

## Examples

``` r
# \donttest{
withr::with_tempdir({

  tmp <- tempfile(fileext = ".txt")
  writeLines("feature list file = feature_list.txt", tmp)

  settings_file(feature_list_file = "feature_list.txt")
})
#> Settings file settings_file.z5 has been created.
# }
```
