#' Plot priority ranking maps
#'
#' `priority_map()` reads a rank map raster from a specified folder and creates
#' a ggplot2 map. It can plot the raster as continuous values or classify it
#' into discrete categories with custom breaks and labels.
#'
#'
#' @param dir Character. Path to the variant folder containing the \code{output}
#'   folder.
#' @param output_folder_name Character. Name of the output folder inside
#'   \code{dir}. Default is "output".
#' @param breaks Numeric vector. Break points for reclassifying rank values.
#'   Required only if \code{classify = TRUE}. Must have length equal to
#'   \code{length(labels) + 1}.
#' @param labels Character vector. Category labels for each reclassification
#'   interval. Required only if \code{classify = TRUE}. Length must equal
#'   \code{length(breaks) - 1}.
#' @param palette Character or vector of colors. If `"viridis"`, the function
#'   uses a reversed viridis palette (option `"H"`) for classified maps.
#'   Otherwise, a vector of colors can be provided. Default is `"viridis"`.
#' @param classify Logical. If `TRUE`, raster values are converted into classes
#'   using `breaks` and `labels`. Default is `FALSE`.
#' @param show_legend Logical. Whether to display the legend. Default is `TRUE`.
#' @param save_path Character. File path to save the plot. If `NULL` (default), the plot
#'   is not saved.
#' @param dpi Numeric. Resolution (dots per inch) for saved figures. Default is
#'   300.
#' @param width Numeric. Width of the saved figure in inches. Default is 8.
#' @param height Numeric. Height of the saved figure in inches. Default is 6.
#'
#' @return A `ggplot` object representing the priority map.
#'
#'
#' @examples
#' \dontrun{
#' p1 <- priority_map(dir = "01_baseline", classify = FALSE)
#' print(p1)
#'
#' breaks <- c(0, 0.25, 0.5, 0.75, 1)
#' labels <- c("Low", "Medium", "High", "Very High")
#' p2 <- priority_map(dir = "01_baseline", classify = TRUE,
#'                    breaks = breaks, labels = labels)
#' print(p2)
#'
#' # Save a continuous map
#' priority_map(
#'   dir = "01_baseline",
#'   classify = FALSE,
#'   save_path = "plots/baseline_map.png")
#' }
#'
#'
#' @importFrom terra rast classify values setValues
#' @importFrom ggplot2 ggplot geom_tile scale_fill_manual scale_fill_viridis_c
#'   theme_bw coord_sf theme labs ggsave element_text aes
#' @importFrom ggspatial annotation_north_arrow annotation_scale
#'   north_arrow_orienteering
#' @importFrom viridis viridis
#' @export
priority_map <- function(
    dir,
    output_folder_name = "output",
    breaks = NULL,
    labels = NULL,
    palette = "viridis",
    classify = FALSE,
    show_legend = TRUE,
    save_path = NULL,
    dpi = 300,
    width = 8,
    height = 6
) {

  # read rank map
  rank_map_path <- file.path(dir, output_folder_name, "rankmap.tif")
  if (!file.exists(rank_map_path)) stop("File rankmap.tif not found.")
  rank_map <- terra::rast(rank_map_path)

  # classify if requested
  if (classify) {

    if (is.null(breaks) || is.null(labels)) {
      stop("You must provide 'breaks' and 'labels' when classify = TRUE")
    }

    if (length(breaks) != (length(labels) + 1L)) {
      stop("Number of labels must be equal to the number of breaks - 1")
    }

    # reclassify raster
    rcl <- cbind(breaks[-length(breaks)], breaks[-1L], seq_along(labels))
    r_reclass_num <- terra::classify(rank_map, rcl = rcl, include.lowest = FALSE, brackets = FALSE)
    r_values <- terra::values(r_reclass_num)
    r_labels <- factor(r_values, levels = seq_along(labels), labels = labels)
    r_reclass_cat <- terra::setValues(r_reclass_num, r_labels)

    raster_df <- as.data.frame(r_reclass_cat, xy = TRUE, na.rm = TRUE)

    # set palette
    pal <- if (palette[1] == "viridis") {
      viridis::viridis(nrow(rcl), direction = -1, option = "H")
    } else {
      palette
    }

    gg_rank_map <- ggplot2::ggplot() +
      ggplot2::geom_tile(data = raster_df, ggplot2::aes(
        x = .data$x, y = .data$y, fill = .data$rankmap
      )) +
      ggplot2::scale_fill_manual(values = pal, name = "Ranking")

  } else {
    # continuous raster
    raster_df <- as.data.frame(rank_map, xy = TRUE, na.rm = TRUE)
    gg_rank_map <- ggplot2::ggplot(raster_df, ggplot2::aes(
      x = .data$x, y = .data$y, fill = .data$rankmap
    )) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_viridis_c(name = "Ranking", option = "H")
  }

  # legend position
  legend_pos <- if (show_legend) "right" else "none"

  # add north arrow, scale, theme
  gg_rank_map <- gg_rank_map +
    ggplot2::theme_bw() +
    ggplot2::coord_sf(crs = 4326) +
    ggspatial::annotation_north_arrow(
      location = "tl",
      which_north = "grid",
      style = ggspatial::north_arrow_orienteering()
    ) +
    ggspatial::annotation_scale(location = "bl", width_hint = 0.2, text_cex = 1.2) +
    ggplot2::theme(
      legend.position = legend_pos,
      legend.title = ggplot2::element_text(size = 18, face = "bold"),
      legend.text = ggplot2::element_text(size = 14)
    ) +
    ggplot2::labs(x = "Longitude", y = "Latitude")

  # save if requested
  if (!is.null(save_path)) {
    ggplot2::ggsave(
      filename = save_path,
      plot = gg_rank_map,
      dpi = dpi,
      width = width,
      height = height,
      units = "in"
    )
  }

  return(gg_rank_map)
}
