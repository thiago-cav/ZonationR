#' Check that an output directory is writable
#'
#' This helper validates that a given directory exists and that the current
#' R process has permission to create and delete a temporary file in it.
#' It is intended for use before writing output files.
#'
#' @param out_dir `character(1)`. Path to the directory that should be writable.
#'
#' @return
#'   Returns `TRUE` invisibly when the directory exists and is writable.
#'   The function otherwise throws an error describing the problem:
#'   \itemize{
#'     \item if the directory does not exist, an error stating that it does not exist;
#'     \item if the directory is not writable, an error stating that it is not writable.
#'   }
#'
#' @examples
#' \dontrun{
#' check_dir_writable(tempdir())
#' }
#' @family preflight
#'
#' @export
check_dir_writable <- function(out_dir) {
  if (!dir.exists(out_dir)) {
    stop("Output directory '", out_dir, "' does not exist.")
  }

  name <- tempfile(tmpdir = out_dir, fileext = ".tmp")
  ret <- file.create(name, showWarnings = FALSE)

  if (ret) {
    unlink(name)
    return(TRUE)
  }

  stop("Output directory '", out_dir, "' is not writable.")
}


