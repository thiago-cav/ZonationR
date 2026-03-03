#' Run a Zonation command file
#'
#' This function runs a Zonation 5 analysis directly from R by executing a
#' command file located in the specified folder. On Windows, the function looks
#' for a single `.cmd` file; on Linux, it looks for a single `.sh` file.
#'
#' @param folder A character string specifying the path to the folder containing
#'   the Zonation command file.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' run_command_file("C:/path/to/folder")
#' }
run_command_file <- function(folder) {

  # Check if the specified folder exists
  if (!dir.exists(folder)) {
    stop("Specified folder does not exist.")
  }

  # Select file extension based on operating system
  ext <- if (.Platform$OS.type == "windows") "\\.cmd$" else "\\.sh$"

  # Find command file
  cmd_files <- list.files(
    path = folder,
    pattern = ext,
    full.names = TRUE
  )

  if (length(cmd_files) == 0) {
    stop("No command file found in the specified folder.")
  }

  if (length(cmd_files) > 1) {
    stop("More than one command file found. Keep only one.")
  }

  cmd_file <- cmd_files[1]

  message("Running command file: ", basename(cmd_file))

  # Run command file and capture exit status
  status <- system2(cmd_file, wait = TRUE)

  if (status != 0) {
    stop("Command failed with exit status ", status)
  }

  message("The analysis has been completed.")
}
