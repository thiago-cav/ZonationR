# Create a Zonation command file

This function generates a command file for running Zonation and
specifies the analysis options and related parameters. The file is saved
with a `.cmd` (Windows) or `.sh` (Linux) suffix.

## Usage

``` r
command_file(
  os = "os_detection",
  zonation_path,
  flags = "",
  marginal_loss_mode = "CAZ2",
  gui_activated = FALSE,
  settings_file = "settings_file.z5",
  output_dir = "output"
)
```

## Arguments

- os:

  Operating system. By default, the system is detected automatically.
  Alternatively, users can explicitly specify "Windows" or "Linux".

- zonation_path:

  The specification for the path where Zonation 5 is installed.

- flags:

  Flags that control which analysis options are used. Used to include
  single letter codes that switch analysis options on. Available options
  are: a, w, g, h, x, X, t.

- marginal_loss_mode:

  Character string specifying the marginal loss rule. Available options
  are "CAZ1", "CAZ2", "ABF", "CAZMAX", "LOAD", and "RAND". Default is
  "CAZ2".

- gui_activated:

  This parameter controls whether the Zonation Graphical User Interface
  (GUI) is launched when running the command file. Default is FALSE.

- settings_file:

  Character string specifying the settings file. Default is
  "settings_file.z5".

- output_dir:

  A character string specifying the name of the output directory where
  the analysis results will be saved. Default is "output".

## Value

A Zonation command file containing the specified analysis options.

## See also

Other preprocessing:
[`feature_list()`](https://thiago-cav.github.io/ZonationR/reference/feature_list.md),
[`settings_file()`](https://thiago-cav.github.io/ZonationR/reference/settings_file.md)

## Examples

``` r
if (FALSE) { # \dontrun{
command_file(
  zonation_path = "C:/Program Files (x86)/Zonation5"
)

command_file(
  zonation_path = "C:/Program Files (x86)/Zonation5",
  marginal_loss_mode = "ABF",
  gui_activated = TRUE
)
} # }
```
