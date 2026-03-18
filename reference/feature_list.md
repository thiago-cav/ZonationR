# Create a feature list from raster files

This function generates a feature list from raster files in a specified
directory, adding optional attributes to the list based on user-defined
parameters. The resulting feature list is written to a text file.
Supported raster formats include GeoTIFF (.tif, .tiff), ERDAS Imagine
(.img), and ASCII Grid (.asc).

## Usage

``` r
feature_list(spp_file_dir, weight = NULL, group = NULL, threshold = NULL)
```

## Arguments

- spp_file_dir:

  A character string specifying the directory containing the raster
  files.

- weight:

  An optional numeric vector (`float`) to assign weights to the features
  in the list.

- group:

  An optional integer vector (`int`) representing the output group
  number for each raster.

- threshold:

  An optional numeric vector (`float`) representing threshold values for
  each raster. If thresholding is applied, values in the input raster
  below the threshold are set to zero. Layers that contain only zeros
  after thresholding are removed from the analysis.

## Value

A text file containing a feature list of rasters along with any
additional attributes specified by the user.

## See also

[`settings_file()`](https://thiago-cav.github.io/ZonationR/reference/settings_file.md),
[`command_file()`](https://thiago-cav.github.io/ZonationR/reference/command_file.md)

Other preprocessing:
[`command_file()`](https://thiago-cav.github.io/ZonationR/reference/command_file.md),
[`settings_file()`](https://thiago-cav.github.io/ZonationR/reference/settings_file.md)

## Examples

``` r
if (FALSE) { # \dontrun{
feature_list(spp_file_dir = "path/to/raster/files")
} # }
```
