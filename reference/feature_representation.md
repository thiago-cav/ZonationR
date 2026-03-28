# Calculate feature representation within an area

This function calculates the representation of each feature across
raster cells, and can optionally summarize results within a specified
area.

## Usage

``` r
feature_representation(feature_layers, area_mask = NULL)
```

## Arguments

- feature_layers:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  with one or more layers representing feature distributions (e.g.,
  species distributions, habitat suitability).

- area_mask:

  Optional. A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or
  [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  defining the analysis area. If a raster is provided, it should follow
  the Zonation analysis area mask convention, where cells with value 1
  represent the area of interest and cells with value 0 or `NA` are
  excluded. If a `SpatVector` is provided, it will be rasterized to
  match the resolution and extent of `feature_layers`.

## Value

A list with two elements:

- representation_layers:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  where each layer contains the fractional representation of the
  corresponding feature across the landscape. Each cell value represents
  the proportion of the global total representation of that feature
  occurring in that cell.

- representation_in_area:

  A named numeric vector containing the representation of each feature
  within the specified `area_mask`. If no area is provided, this element
  returns `NULL`.

## See also

Other postprocessing:
[`coverage_distribution()`](https://thiago-cav.github.io/ZonationR/reference/coverage_distribution.md),
[`feature_curves()`](https://thiago-cav.github.io/ZonationR/reference/feature_curves.md),
[`priority_map()`](https://thiago-cav.github.io/ZonationR/reference/priority_map.md),
[`rank_similarity()`](https://thiago-cav.github.io/ZonationR/reference/rank_similarity.md),
[`summary_curves()`](https://thiago-cav.github.io/ZonationR/reference/summary_curves.md)

## Examples

``` r
r <- terra::rast(nrows = 10, ncols = 10)
f1 <- terra::setValues(r, runif(terra::ncell(r)))
f2 <- terra::setValues(r, runif(terra::ncell(r)))
features <- c(f1, f2)
names(features) <- c("feature_1", "feature_2")

mask <- r
terra::values(mask) <- sample(c(0,1), terra::ncell(mask), replace = TRUE)

result <- feature_representation(features, mask)
result$representation_in_area
#> feature_1 feature_2 
#> 0.4622109 0.4387114 
```
