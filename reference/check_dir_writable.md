# Check that an output directory is writable

This helper validates that a given directory exists and that the current
R process has permission to create and delete a temporary file in it. It
is intended for use before writing output files.

## Usage

``` r
check_dir_writable(out_dir)
```

## Arguments

- out_dir:

  `character(1)`. Path to the directory that should be writable.

## Value

Returns `TRUE` invisibly when the directory exists and is writable. The
function otherwise throws an error describing the problem:

- if the directory does not exist, an error stating that it does not
  exist;

- if the directory is not writable, an error stating that it is not
  writable.

## See also

Other preflight:
[`check_raster_uniformity()`](https://thiago-cav.github.io/ZonationR/reference/check_raster_uniformity.md),
[`check_zonation_executable()`](https://thiago-cav.github.io/ZonationR/reference/check_zonation_executable.md)

## Examples

``` r
dir <- tempdir()
check_dir_writable(dir)
#> [1] TRUE
```
