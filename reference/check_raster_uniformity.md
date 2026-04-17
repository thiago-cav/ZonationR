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
# \donttest{
withr::with_tempdir({

  r1 <- terra::rast(nrows = 5, ncols = 5)
  terra::values(r1) <- runif(terra::ncell(r1))

  r2 <- terra::rast(r1)
  terra::values(r2) <- runif(terra::ncell(r2))

  terra::writeRaster(r1, "r1.tif", overwrite = TRUE)
  terra::writeRaster(r2, "r2.tif", overwrite = TRUE)

  check_raster_uniformity(".")
})
#> All raster files in '.' are spatially uniform and compatible with Zonation.
# }
```
