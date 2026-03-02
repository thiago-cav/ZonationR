#' Cost (remaining cost) at specific landscape proportions
#'
#' Reads Zonation \code{summary_curves.csv}, finds the row closest to each
#' value in \code{landscape_prop}, and returns remaining cost and percentage of
#' maximum cost at those proportions. Optionally writes the result to
#' \code{dir/sz_output/performance_table_cost.csv}.
#'
#' @param dir Character. Path to the directory containing the Zonation output
#'   folder.
#' @param output_folder_name Character. Name of the Zonation output folder
#'   (e.g. the run name).
#' @param landscape_prop Numeric vector. Landscape proportions (rank values) at
#'   which to report cost (e.g. \code{c(0.03, 0.2, 0.5)}).
#' @param save_output Logical. If TRUE, the result is written as a CSV to
#'   \code{dir/sz_output/performance_table_cost.csv}. Default FALSE.
#'
#' @returns A data frame with columns \code{rank} (the requested proportion),
#'   \code{remaining_cost}, and \code{percentage} (remaining cost as percentage
#'   of the maximum remaining cost in the run).
#'
#' @importFrom readr read_table
#' @importFrom dplyr bind_rows
#' @importFrom utils write.csv
#' @export
sz_cost <- function(dir,
                    output_folder_name,
                    landscape_prop,
                    save_output = FALSE) {
  cost_path <- file.path(dir, output_folder_name, "summary_curves.csv")

  if (!file.exists(cost_path)) {
    stop("Summary curves file not found.")
  }

  cost_tab <- suppressWarnings(suppressMessages(readr::read_table(cost_path)))

  nms <- make.names(names(cost_tab))
  nms <- gsub("^X\\.", "", nms)
  nms <- gsub("\\.", "", nms)
  colnames(cost_tab) <- nms

  res_cost <- tibble::tibble()

  for (i in seq_along(landscape_prop)) {
    rank_col <- cost_tab[, "rank", drop = TRUE]
    idx <- which.min(abs(rank_col - landscape_prop[i]))
    filter_data <- cost_tab[idx, c("rank", "remaining_cost"), drop = FALSE]
    filter_data[1L, "rank"] <- landscape_prop[i]
    res_cost <- dplyr::bind_rows(res_cost, filter_data)
  }

  max_cost <- max(cost_tab[, "remaining_cost"], na.rm = TRUE)
  res_cost$percentage <- (res_cost$remaining_cost / max_cost) * 100

  if (save_output) {
    fs::dir_create(dir, "sz_output")
    write.csv(
      res_cost,
      paste0(dir, "/sz_output/", "performance_table_cost", ".csv")
    )
  }
  res_cost
}

