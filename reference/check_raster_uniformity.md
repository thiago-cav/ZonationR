# Check raster uniformity

Verifies that all raster files in a folder are compatible with Zonation.
Compatibility requires that all rasters have:

- identical resolution (cell size)

- identical extent (number of rows and columns)

- identical projection (CRS)

## Usage

``` r
check_raster_uniformity(spp_file_dir)
```

## Arguments

- spp_file_dir:

  Character. Path to the folder containing raster files.

## Value

Prints a message confirming uniformity. Stops with an error otherwise.

## Details

Supported raster formats: `.tif`, `.tiff`, `.img`, `.asc`.

## See also

Other preflight:
[`check_dir_writable()`](https://thiago-cav.github.io/ZonationR/reference/check_dir_writable.md),
[`check_zonation_executable()`](https://thiago-cav.github.io/ZonationR/reference/check_zonation_executable.md)

## Examples

``` r
if (FALSE) { # \dontrun{
check_raster_uniformity("path/to/rasters")
} # }
```
