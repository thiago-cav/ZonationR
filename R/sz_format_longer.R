#' Convert Zonation summary results to long format (INTERNAL FUNCTION)
#'
#' Reshapes each data frame in the input list from wide to long format: numeric
#' columns (from column 3 onward) are cast to numeric, then pivoted so that
#' feature names become the \code{feature} column and values the
#' \code{representation} column. \code{rank} and \code{weight_type} are kept as
#' identifier columns.
#'
#' @param data_list A list of data frames, each with columns \code{rank},
#'   \code{weight_type}, and one or more feature/value columns to be pivoted.
#'
#' @returns A list of the same length as \code{data_list}, each element a data
#'   frame in long format with columns \code{rank}, \code{weight_type},
#'   \code{feature}, and \code{representation}.
#'
#' @importFrom dplyr mutate across
#' @importFrom tidyr pivot_longer
#' @keywords internal
sz_format_longer <- function(data_list) {
  res_list <- list()
  for (i in seq_along(data_list)) {
    df <- data_list[[i]]
    n <- ncol(df)
    df <- dplyr::mutate(df, dplyr::across(3:n, ~ as.numeric(.)))
    df_longer_format <- tidyr::pivot_longer(
      df,
      cols = 3:n,
      names_to = "feature",
      values_to = "representation"
    )
    res_list[[i]] <- df_longer_format
  }
  res_list
}
