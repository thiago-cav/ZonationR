#' Summarize remaining cost at specified landscape proportions
#'
#' Reads a Zonation \code{summary_curves.csv} file (space-separated),
#' finds the row closest to each value in \code{landscape_prop}, and returns
#' remaining cost and percentage of maximum cost at those proportions.
#' Optionally writes the result to \code{dir/performance/cost_summary.csv}.
#'
#' @param dir Character. Path to the directory containing the Zonation output
#'   folder.
#' @param output_folder_name Character. Name of the output folder inside
#'   \code{dir}. Default is "output".
#' @param landscape_prop Numeric vector. Landscape proportions (rank values)
#'   at which to report cost (e.g. \code{c(0.03, 0.2, 0.5)}).
#' @param save_output Logical. If TRUE, the result is written as a CSV to
#'   \code{dir/performance/cost_summary.csv}. Default FALSE.
#'
#' @returns A data frame with columns:
#' \itemize{
#'   \item \code{rank} - the requested proportion
#'   \item \code{remaining_cost} - remaining cost at that rank
#'   \item \code{percentage} - remaining cost as percentage of maximum cost
#' }
#'
#' @examples
#' \donttest{
#' withr::with_tempdir({
#'
#'   dir.create("output")
#'
#'   # simulate Zonation-style summary_curves.csv structure
#'   write.table(
#'     data.frame(
#'       rank = seq(0, 1, length.out = 10),
#'       remaining_cost = runif(10, 50, 100),
#'       dummy1 = runif(10),
#'       dummy2 = runif(10)
#'     ),
#'     file = file.path("output", "summary_curves.csv"),
#'     row.names = FALSE,
#'     col.names = TRUE,
#'     sep = " "
#'   )
#'
#'   cost_summary(
#'     dir = ".",
#'     output_folder_name = "output",
#'     landscape_prop = c(0.2, 0.5, 0.8)
#'   )
#'
#' })
#' }
#'
#' @importFrom dplyr bind_rows
#' @importFrom utils write.csv
#' @family postprocessing
#' @export
cost_summary <- function(dir,
                         output_folder_name = "output",
                         landscape_prop,
                         save_output = FALSE) {

  # Path to Zonation summary file
  cost_path <- file.path(dir, output_folder_name, "summary_curves.csv")

  if (!file.exists(cost_path)) {
    stop("Summary curves file not found.")
  }

  # Read space-separated CSV (strings as characters)
  cost_tab <- read.csv(cost_path, sep = "", stringsAsFactors = FALSE)

  # Clean column names
  nms <- make.names(names(cost_tab))
  nms <- gsub("^X\\.", "", nms)
  nms <- gsub("\\.", "", nms)
  colnames(cost_tab) <- nms

  # Check required columns
  if (!all(c("rank", "remaining_cost") %in% names(cost_tab))) {
    stop("Columns 'rank' and/or 'remaining_cost' not found in summary_curves.csv")
  }

  # Initialize result data frame (base R)
  res_cost <- data.frame(
    rank = numeric(),
    remaining_cost = numeric(),
    stringsAsFactors = FALSE
  )

  # Loop over requested landscape proportions
  for (i in seq_along(landscape_prop)) {
    rank_col <- cost_tab[["rank"]]
    idx <- which.min(abs(rank_col - landscape_prop[i]))

    filter_data <- cost_tab[idx, c("rank", "remaining_cost"), drop = FALSE]
    filter_data[1, "rank"] <- landscape_prop[i]

    res_cost <- dplyr::bind_rows(res_cost, filter_data)
  }

  # Add percentage of maximum cost
  max_cost <- max(cost_tab[["remaining_cost"]], na.rm = TRUE)
  res_cost$percentage <- (res_cost$remaining_cost / max_cost) * 100

  # Save output if requested
  if (save_output) {
    output_dir <- file.path(dir, "performance")
    if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

    utils::write.csv(
      res_cost,
      file.path(output_dir, "cost_summary.csv"),
      row.names = FALSE
    )
  }

  return(res_cost)
}
