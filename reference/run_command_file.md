# Run a Zonation command file

This function runs a Zonation 5 analysis directly from R by executing a
command file located in the specified folder. On Windows, the function
looks for a single `.cmd` file; on Linux, it looks for a single `.sh`
file.

## Usage

``` r
run_command_file(folder)
```

## Arguments

- folder:

  A character string specifying the path to the folder containing the
  Zonation command file.

## Value

Nothing is returned. The function is used to run the Zonation analysis.

## Examples

``` r
if (FALSE) { # \dontrun{
run_command_file("C:/path/to/folder")
} # }
```
