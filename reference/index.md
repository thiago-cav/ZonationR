# Package index

## Preflight

Initial checks such as verifying input files and confirming Zonation 5
executable availability.

- [`check_dir_writable()`](https://thiago-cav.github.io/ZonationR/reference/check_dir_writable.md)
  : Check that an output directory is writable
- [`check_raster_uniformity()`](https://thiago-cav.github.io/ZonationR/reference/check_raster_uniformity.md)
  : Check raster uniformity
- [`check_zonation_executable()`](https://thiago-cav.github.io/ZonationR/reference/check_zonation_executable.md)
  : Check for Zonation 5 executable

## Preprocessing

Preparing input data and generating necessary configuration files.

- [`command_file()`](https://thiago-cav.github.io/ZonationR/reference/command_file.md)
  : Create a Zonation command file
- [`feature_list()`](https://thiago-cav.github.io/ZonationR/reference/feature_list.md)
  : Create a feature list from raster files
- [`settings_file()`](https://thiago-cav.github.io/ZonationR/reference/settings_file.md)
  : Create a settings file for a Zonation analysis

## Execution

Running the prioritization analysis directly from R.

- [`run_command_file()`](https://thiago-cav.github.io/ZonationR/reference/run_command_file.md)
  : Run a Zonation command file

## Postprocessing

Importing outputs for further analysis and interpretation.

- [`cost_summary()`](https://thiago-cav.github.io/ZonationR/reference/cost_summary.md)
  : Summarize remaining cost at specified landscape proportions
- [`coverage_distribution()`](https://thiago-cav.github.io/ZonationR/reference/coverage_distribution.md)
  : Plot coverage distribution at a given rank
- [`feature_curves()`](https://thiago-cav.github.io/ZonationR/reference/feature_curves.md)
  : Plot feature performance curves
- [`feature_representation()`](https://thiago-cav.github.io/ZonationR/reference/feature_representation.md)
  : Calculate feature representation within an area
- [`priority_map()`](https://thiago-cav.github.io/ZonationR/reference/priority_map.md)
  : Plot priority ranking maps
- [`rank_similarity()`](https://thiago-cav.github.io/ZonationR/reference/rank_similarity.md)
  : Calculate similarity between Zonation rank maps
- [`summary_curves()`](https://thiago-cav.github.io/ZonationR/reference/summary_curves.md)
  : Plot summary performance curves
