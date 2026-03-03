#' Create a Zonation command File
#'
#' This function generates a command file for running Zonation and specifies
#' the analysis options and related parameters. The file is saved with a `.cmd`
#' (Windows) or `.sh` (Linux) suffix.
#'
#' @param os Operating system. Default is "Windows"; set to "Linux" if using a
#'   Linux system.
#' @param zonation_path The specification for the path where Zonation 5 is
#'   installed.
#' @param flags Flags that control which analysis options are used. Used to
#'   include single letter codes that switch analysis options on. Available
#'   options are: a, w, g, h, x, X, t.
#' @param marginal_loss_mode Character string specifying the marginal loss rule.
#'   Available options are "CAZ1", "CAZ2", "ABF", "CAZMAX", "LOAD", and "RAND".
#'   Default is "CAZ2".
#' @param gui_activated This parameter controls whether the Graphical User
#'   Interface (GUI) is launched when running the command file. The default is
#'   TRUE (GUI activated).
#' @param settings_file Character string specifying the settings file. Default
#'   is "settings_file.z5".
#' @param output_dir A character string specifying the name of the output
#'   directory where the analysis results will be saved. Default is "output".
#'
#' @returns A Zonation command file containing the specified analysis options.
#'
#' @seealso
#' [feature_list()], [settings_file()]
#'
#' @examples
#' \dontrun{
#' command_file(
#'   zonation_path = "C:/Program Files (x86)/Zonation5"
#' )
#'
#' command_file(
#'   zonation_path = "C:/Program Files (x86)/Zonation5",
#'   marginal_loss_mode = "ABF",
#'   gui_activated = FALSE
#' )
#' }
#' @export
command_file <- function(os = "Windows",
                         zonation_path,           # Required parameter
                         flags = "",
                         marginal_loss_mode = "CAZ2",
                         gui_activated = TRUE,
                         settings_file = "settings_file.z5",
                         output_dir = "output") {

  # Set the command_file parameter to a fixed value
  command_file <- "command_file.cmd"  # or "command_file.sh" based on the OS

  # Set results directory to a fixed value
  results_directory <- output_dir  # Directory for analysis results

  # Validate required parameters
  if (missing(zonation_path)) {
    stop("'zonation_path' must be provided.")
  }

  allowed_modes <- c("CAZ1", "CAZ2", "ABF", "CAZMAX", "LOAD", "RAND")

  if (!marginal_loss_mode %in% allowed_modes) {
    stop(
      "'marginal_loss_mode' must be one of: ",
      paste(allowed_modes, collapse = ", "),
      "."
    )
  }

  if (!file.exists(settings_file)) {
    stop(
      "Settings file not found: '", settings_file, "'."
    )
  }

  # Validate flags
  if (flags != "") {
    allowed_flags <- c("a", "w", "g", "h", "x", "X", "t")
    flag_chars <- strsplit(flags, "")[[1]]

    invalid_flags <- setdiff(flag_chars, allowed_flags)
    if (length(invalid_flags) > 0) {
      stop(
        "Invalid analysis option flag(s): ",
        paste(invalid_flags, collapse = ", "),
        ". Flags activate analysis options and must be one or more of: ",
        paste(allowed_flags, collapse = ", "),
        "."
      )
    }
  }

  # Ensure the output command file has the correct extension based on OS
  if (os == "Windows" && !grepl("\\.cmd$", command_file)) {
    command_file <- paste0(command_file, ".cmd")
  } else if (os == "Linux" && !grepl("\\.sh$", command_file)) {
    command_file <- paste0(command_file, ".sh")
  }

  # Build the command template
  if (os == "Windows") {
    command_template <- paste0("@setlocal\n",
                               "@PATH=", zonation_path, ";%PATH%\n",
                               "z5")
  } else if (os == "Linux") {
    command_template <- paste0("#!/bin/sh\n",
                               "export PATH=", zonation_path, ":$PATH\n",
                               "zonation5")
  } else {
    stop("Unsupported operating system. Use 'Windows' or 'Linux'.")
  }

  # Add flags
  if (flags != "") {
    command_template <- paste0(command_template, " -", flags)
  }

  # Add marginal loss mode
  command_template <- paste0(command_template, " --mode=", marginal_loss_mode)

  # Add GUI flag if needed
  if (gui_activated) {
    command_template <- paste0(command_template, " --gui")
  }

  # Add settings file and results directory (for analysis results)
  command_template <- paste0(command_template, " ", settings_file, " ", results_directory)

  # Write command to file
  writeLines(command_template, command_file)

  # Set executable permission on Linux
  if (os == "Linux") {
    Sys.chmod(command_file, mode = "0755")
  }

  message("Command file created: ", command_file)
}
