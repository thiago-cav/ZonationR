#' Plot coverage distribution at a given rank
#'
#' This function reads a Zonation feature curves file and plots the distribution
#' of feature coverage values at a specified priority rank. The output is a
#' ggplot object, which can be further customized by the user. Optionally, the
#' plot can be saved to disk as a high-quality figure.
#'
#' @param data_path Character. Path to the Zonation output CSV file
#'   (\code{feature_curves.csv}) containing feature curves.
#' @param target_rank Numeric. The rank value at which coverage distributions
#'   should be extracted and plotted.
#' @param save_path Character. Optional file path to save the plot. The file
#'   format is inferred from the specified extension (e.g. ".tiff").
#' @param dpi Numeric. Resolution (dots per inch) for saved figures. Default is
#'   300.
#' @param width Numeric. Width of the saved figure in inches. Default is 8.
#' @param height Numeric. Height of the saved figure in inches. Default is 6.
#'
#' @returns A \code{ggplot} object showing the distribution of feature coverage
#'   values at the specified priority rank.
#'
#' @examples
#' \dontrun{
#' p <- coverage_distribution(
#'   data_path = "C:/path/to/feature_curves.csv",
#'   target_rank = 0.9
#' )
#'
#' p + ggplot2::theme_classic()
#'
#' coverage_distribution(
#'   data_path = "C:/path/to/feature_curves.csv",
#'   target_rank = 0.9,
#'   save_path = "coverage_histogram.png"
#' )
#' }
#'
#' @importFrom rlang .data sym !!
#' @importFrom utils read.csv
#' @export
coverage_distribution <- function(data_path, target_rank, save_path = NULL,
                                  dpi = 300,width = 8,
                                  height = 6) {

  if (!file.exists(data_path)) {
    stop("File not found: ", data_path)
  }

  data <- read.csv(data_path, sep = "", stringsAsFactors = FALSE)
  data$rank <- as.numeric(data$rank)

  long_data <- tidyr::pivot_longer(
    data,
    cols = -rank,
    names_to = "feature",
    values_to = "coverage"
  )

  filtered_data <- dplyr::filter(long_data, abs(.data$rank - target_rank) < 1e-4)

  p <- ggplot2::ggplot(filtered_data, ggplot2::aes(x = !!rlang::sym("coverage"))) +
      ggplot2::geom_histogram(
      breaks = seq(0, 1, by = 0.1),
      fill = "darkgrey",
      color = "black",
      boundary = 0,
      closed = "left"
    ) +
    ggplot2::scale_x_continuous(
      name = "Coverage Level",
      limits = c(0, 1),
      breaks = seq(0, 1, by = 0.1)
    ) +
    ggplot2::labs(y = "Feature Count") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      axis.title = ggplot2::element_text(size = 12),
    )

  if (!is.null(save_path)) {
    ggplot2::ggsave(
      filename = save_path,
      plot = p,
      dpi = dpi,
      width = width,
      height = height,
      units = "in"
    )
  }

  return(p)
}
