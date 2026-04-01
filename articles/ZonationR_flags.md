# Analysis flags in ZonationR

*ZonationR* provides a set of single-letter flags that control analysis
options through
[`command_file()`](https://thiago-cav.github.io/ZonationR/reference/command_file.md).
Certain flags require specific columns in the feature list (e.g.,
`weight` or `group`), while others need additional raster inputs
supplied via
[`settings_file()`](https://thiago-cav.github.io/ZonationR/reference/settings_file.md).
As **additional material to the function documentation**, this vignette
provides a guide to the available analysis flags and their relationships
to feature and settings inputs, helping users better understand how to
configure *ZonationR* workflows.

### Feature list

The
[`feature_list()`](https://thiago-cav.github.io/ZonationR/reference/feature_list.md)
function produces a file specifying biodiversity features (e.g., species
or habitat distributions). Users can assign weights, groups, and
thresholds to control prioritization. Columns in the feature list, such
as `weight`, `group`, and `threshold`, are used by the prioritization
algorithm according to the flags set in
[`command_file()`](https://thiago-cav.github.io/ZonationR/reference/command_file.md).

| Argument  | ParameterFlags | DataType       | Explanation                                          |
|:----------|:---------------|:---------------|:-----------------------------------------------------|
| filename  | \-             | string         | Feature distribution file name                       |
| weight    | w              | floating-point | Feature weight                                       |
| group     | g              | integer        | Output group number                                  |
| threshold | t              | floating-point | Numeric threshold below which values are cut to zero |

Table 1. Arguments accepted by
[`feature_list()`](https://thiago-cav.github.io/ZonationR/reference/feature_list.md)
and their parameter flags

### Settings file

The
[`settings_file()`](https://thiago-cav.github.io/ZonationR/reference/settings_file.md)
function generates a configuration file that defines the inputs for a
Zonation analysis. Some spatial inputs, such as analysis area masks or
hierarchic masks, are optional but require activation via the
corresponding flags in
[`command_file()`](https://thiago-cav.github.io/ZonationR/reference/command_file.md).
File inputs include the feature list (i.e., the output from the
[`feature_list()`](https://thiago-cav.github.io/ZonationR/reference/feature_list.md)
function), optional external solutions (`external solution`), analysis
area masks (`analysis area mask layer`), hierarchic masks
(`hierarchic mask layer`), and cost layers (`cost layer`).

| FileParameter            | CommandFlag     | RequiredFileType      |
|:-------------------------|:----------------|:----------------------|
| feature list file        | always required | plain text file       |
| external solution        | –mode=LOAD      | floating-point raster |
| analysis area mask layer | a               | integer raster        |
| hierarchic mask layer    | h               | integer raster        |
| cost layer               | x, X            | floating-point raster |

Table 2. Arguments accepted by
[`settings_file()`](https://thiago-cav.github.io/ZonationR/reference/settings_file.md)

### Command file

Analysis options in *ZonationR* are controlled via single-letter flags
specified in
[`command_file()`](https://thiago-cav.github.io/ZonationR/reference/command_file.md).
Some flags require corresponding columns in the feature list (e.g.,
`weight`, `group`, `threshold`), while others require additional raster
inputs supplied through
[`settings_file()`](https://thiago-cav.github.io/ZonationR/reference/settings_file.md).
The table below summarizes the available flags, the required feature
list columns, and any additional raster inputs needed.

| Flag | Explanation                    | FeatureListColumn | AdditionalRaster                   |
|:-----|:-------------------------------|:------------------|:-----------------------------------|
| a    | Use analysis area mask         | \-                | 1 integer raster (analysis area)   |
| w    | Apply feature weights          | weight            | \-                                 |
| g    | Use output groups              | group             | \-                                 |
| h    | Hierarchic analysis            | \-                | 1 integer raster (hierarchic mask) |
| x    | Include cost in outputs only   | \-                | 1 floating-point raster            |
| X    | Include cost in prioritization | \-                | 1 floating-point raster            |
| t    | Apply thresholding             | threshold         | \-                                 |

Table 3. Analysis flags available in *ZonationR* and their requirements
