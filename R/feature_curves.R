#' Plot feature curves
#'
#' Reads the Zonation \code{feature_curves.csv} and \code{features_info.csv}
#' files, standardizes the feature names, and plots representation vs priority
#' rank for each feature. Supports a single color with transparency or the
#' viridis palette. Legend display can be toggled.
#'
#' @param dir Character. Path to the directory containing the Zonation output
#'   folder.
#' @param output_folder_name Character. Name of the Zonation output folder
#'   (default: "output").
#' @param palette Character. Either "gray" (default) for a single-color plot, a
#'   single color name, or "viridis" to use the viridis palette for multiple
#'   features.
#' @param alpha Numeric. Transparency of lines (0 fully transparent, 1 fully
#'   opaque). Default is 0.3.
#' @param show_legend Logical. If TRUE, shows legend (only applicable when
#'   palette = "viridis"). Default is FALSE.
#' @param save_path Character. Optional path to save the plot as PNG. Default is
#'   NULL (does not save).
#' @param dpi Numeric. Resolution (dots per inch) for saved figures. Default is
#'   300.
#' @param width Numeric. Width of the saved figure in inches. Default is 12.
#' @param height Numeric. Height of the saved figure in inches. Default is 8.
#'
#' @returns A \code{ggplot} object representing feature curves. If
#'   \code{save_path} is provided, also saves the plot as PNG.
#'
#' @examples
#' \dontrun{
#' # Plot gray lines with default transparency and no legend
#' feature_curves("01_baseline")
#'
#' # Plot using viridis palette with legend
#' feature_curves("01_baseline", palette = "viridis", show_legend = TRUE)
#'
#' # Plot using custom blue color with more transparency
#' feature_curves("01_baseline", palette = "blue", alpha = 0.2)
#' }
#'
#' @importFrom viridis viridis
#' @importFrom utils read.csv
#' @importFrom tidyr pivot_longer
#' @importFrom tools file_path_sans_ext
#' @importFrom rlang .data
#' @export
feature_curves <- function(
    dir,
    output_folder_name = "output",
    palette = "gray",
    alpha = 0.3,
    show_legend = FALSE,
    save_path = NULL,
    dpi = 300,
    width = 8,
    height = 6
) {

  # ---- read feature curves ----
  fc_path <- file.path(dir, output_folder_name, "feature_curves.csv")
  if (!file.exists(fc_path)) stop("feature_curves.csv not found.")
  fc <- read.csv(fc_path, sep = "", stringsAsFactors = FALSE)

  last_col <- ncol(fc)
  if (all(fc[, last_col] == 0 | is.na(fc[, last_col]))) fc <- fc[, -last_col]

  colnames(fc)[1] <- "rank"

  # ---- read and standardize feature names ----
  fi_path <- file.path(dir, output_folder_name, "features_info.csv")
  if (!file.exists(fi_path)) stop("features_info.csv not found.")
  fi <- read.csv(fi_path, sep = "", stringsAsFactors = FALSE)
  if (!"fname" %in% names(fi)) stop("Column 'fname' not found in features_info.csv")

  feature_names <- basename(fi$fname)
  feature_names <- gsub("\"", "", feature_names)
  feature_names <- tools::file_path_sans_ext(feature_names)

  n_fc <- ncol(fc) - 1
  n_fn <- length(feature_names)

  if (n_fc != n_fn) {
    stop(paste0("Mismatch between feature curves (", n_fc,
                ") and feature names (", n_fn, "). Check your files!"))
  }

  colnames(fc)[2:ncol(fc)] <- feature_names

  # ---- reshape ----
  plot_data <- tidyr::pivot_longer(fc, cols = -rank, names_to = "feature", values_to = "representation")

  # ---- plot ----
  if (palette[1] == "viridis") {
    pal <- viridis::viridis(length(unique(plot_data$feature)), option = "H", direction = -1)
    p <- ggplot2::ggplot(plot_data, ggplot2::aes(
      x = .data$rank,
      y = .data$representation,
      colour = .data$feature,
      group = .data$feature
    )) +
      ggplot2::geom_line(alpha = alpha, linewidth = 0.7) +
      ggplot2::scale_color_manual(values = pal)
  } else {
    p <- ggplot2::ggplot(plot_data, ggplot2::aes(
      x = .data$rank,
      y = .data$representation,
      group = .data$feature
    )) +
      ggplot2::geom_line(colour = palette[1], alpha = alpha, linewidth = 0.7)
  }

  # ---- axes and theme ----
  p <- p +
    ggplot2::scale_x_continuous(name = "Priority rank") +
    ggplot2::scale_y_continuous(name = "Coverage") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = ifelse(show_legend & palette[1] == "viridis", "right", "none"))

  # ---- save optional ----
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
