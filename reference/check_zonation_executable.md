# Check for Zonation 5 executable

This function checks if the Zonation 5 executable is available on the
system. It can verify a specific path provided by the user or search
common installation locations. The function works on both Windows and
Linux systems.

## Usage

``` r
check_zonation_executable(zonation_path = NULL, os = NULL)
```

## Arguments

- zonation_path:

  Optional character string specifying the path to check. If not
  provided, the function will search common installation locations.

- os:

  Operating system. If NULL (default), automatically detected from the
  system. Can be set to "Windows" or "Linux" manually.

## Value

A list with the following components:

- found:

  Logical indicating if the executable was found

- path:

  Character string with the path where the executable was found (or
  NULL)

- executable:

  Character string with the full path to the executable (or NULL)

- os:

  Character string indicating the detected operating system

- message:

  Character string with a descriptive message

## Details

For Windows, the function searches for `z5.exe` in:

- The provided path (if given)

- `C:/Program Files (x86)/Zonation5`

- `C:/Program Files/Zonation5`

For Linux, the function searches for `zonation5` in:

- The provided path (if given)

- Common locations like `~/Applications`, `~/bin`, `/usr/local/bin`,
  `/usr/bin`

- The system PATH

## See also

Other preflight:
[`check_dir_writable()`](https://thiago-cav.github.io/ZonationR/reference/check_dir_writable.md),
[`check_raster_uniformity()`](https://thiago-cav.github.io/ZonationR/reference/check_raster_uniformity.md)

## Examples

``` r
# \donttest{
check_zonation_executable()
#> $found
#> [1] FALSE
#> 
#> $path
#> NULL
#> 
#> $executable
#> NULL
#> 
#> $os
#> [1] "Linux"
#> 
#> $message
#> [1] "Zonation 5 executable not found.\nPlease install Zonation 5 from: https://zonationteam.github.io/Zonation5/\nOr provide the correct installation path using the 'zonation_path' parameter.\nFor Linux, you can download the AppImage from the website above.\nCommon locations to place it:\n  - ~/Applications\n  - ~/bin\n  - Or add it to your system PATH"
#> 
# }
```
