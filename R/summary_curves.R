#' Plot summary performance curves from Zonation output
#'
#' This function reads a Zonation summary curves file and plots one or more
#' summary metrics against the priority rank. The output is a ggplot object,
#' which can be further customized by the user. Optionally, the plot can be
#' saved to disk as a high-quality figure.
#'
#' @param data_path Character. Path to the Zonation output file
#'   (\code{summary_curves.csv}).
#' @param metrics Character vector. Names of the summary metrics to plot.
#'   Metrics can be overlaid only if they share the same units and value range.
#'   Fraction-based metrics can be overlaid together, while
#'   \code{remaining_area} and \code{remaining_cost} cannot be overlaid with
#'   other metrics.
#' @param facet Logical. If TRUE, metrics are plotted in separate panels. This
#'   should be used when plotting metrics with different units or value ranges.
#'   Default is FALSE.
#' @param save_path Character. Optional file path to save the plot. The file
#'   format is inferred from the file extension (e.g. ".tiff").
#' @param dpi Numeric. Resolution (dots per inch) for saved figures. Default is
#'   300.
#' @param width Numeric. Width of the saved figure in inches. Default is 8.
#' @param height Numeric. Height of the saved figure in inches. Default is 6.
#'
#' @returns A \code{ggplot} object visualizing one or more Zonation summary
#'   metrics plotted against priority rank.
#'
#' @examples
#' \dontrun{
#' ## Overlaid plot
#' p <- summary_curves(
#'   data_path = "path/to/summary_curves.csv",
#'   metrics = c("mean", "max")
#' )
#'
#' p + ggplot2::theme_classic()
#'
#' ## Plot area and cost in separate panels
#' summary_curves(
#'   data_path = "path/to/summary_curves.csv",
#'   metrics = c("remaining_area", "remaining_cost"),
#'   facet = TRUE
#' )
#' }
#'
#' @importFrom utils read.csv
#' @importFrom rlang .data
#' @export
summary_curves <- function(data_path,
                           metrics,
                           facet = FALSE,
                           save_path = NULL,
                           dpi = 300,
                           width = 8,
                           height = 6) {

  if (!file.exists(data_path)) {
    stop("File not found: ", data_path, call. = FALSE)
  }

  data <- read.csv(data_path, sep = "", stringsAsFactors = FALSE)

  if (!"rank" %in% names(data)) {
    stop("Column 'rank' not found in summary curves file.", call. = FALSE)
  }

  missing_metrics <- setdiff(metrics, names(data))
  if (length(missing_metrics) > 0) {
    stop(
      "The following metrics were not found in the file:\n",
      paste(missing_metrics, collapse = ", "),
      call. = FALSE
    )
  }

  # ---- metric families ----
  metric_families <- list(
    remaining_area = "area",
    remaining_cost = "cost"
  )

  families <- vapply(
    metrics,
    function(m) {
      if (m %in% names(metric_families)) {
        metric_families[[m]]
      } else {
        "fraction"
      }
    },
    character(1)
  )

  families_unique <- unique(families)

  if (isFALSE(facet) && length(families_unique) > 1) {
    stop(
      "Cannot overlay metrics with different units or value ranges.\n",
      "You selected metrics from multiple families:\n",
      paste(families_unique, collapse = ", "),
      "\n\nUse facet = TRUE or plot metrics from a single family.",
      call. = FALSE
    )
  }

  # ---- reshape to long format ----
  plot_data <- tidyr::pivot_longer(
    data,
    cols = dplyr::all_of(metrics),
    names_to = "metric",
    values_to = "value"
  )

  # ---- base plot ----
  p <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = .data$rank, y = .data$value, colour = .data$metric)
  ) +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::scale_x_continuous(name = "Priority rank") +
    ggplot2::labs(y = "Metric value", colour = "Metric") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      axis.title = ggplot2::element_text(size = 12)
    )

  if (facet) {
    p <- p + ggplot2::facet_wrap(~ metric, scales = "free_y")
  }

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

