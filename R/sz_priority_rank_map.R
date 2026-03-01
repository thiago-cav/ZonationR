#' Create a priority rank map from Zonation output
#'
#' Reads the Zonation \code{rankmap.tif}, reclassifies it into user-defined
#' break intervals and category labels, and draws a map with ggplot2. Optionally
#' saves the plot as a PNG in \code{dir/sz_output/}.
#'
#' @param dir Character. Path to the directory containing the Zonation output
#'   folder.
#' @param output_folder_name Character. Name of the Zonation output folder
#'   (e.g. the run name).
#' @param breaks Numeric vector. Break points for reclassifying rank values (must
#'   have length equal to \code{length(labels) + 1}).
#' @param labels Character vector. Category labels for each reclassification
#'   interval (length must equal \code{length(breaks) - 1}).
#' @param palette Character. Either \code{"viridis"} (default) to use
#'   \code{viridis::viridis} (option "H"), or a vector of colour values (one per
#'   category).
#' @param save_map Logical. If TRUE, the plot is saved as a PNG in
#'   \code{dir/sz_output/}. Default TRUE.
#' @param rank_map_name Character. Base name for the output file (without
#'   extension). Default \code{"rank_map_name"}.
#'
#' @returns A \code{ggplot} object of the priority rank map (with optional north
#'   arrow and scale). If \code{save_map} is TRUE, the PNG is also written to
#'   \code{dir/sz_output/<rank_map_name>.png}.
#'
#' @importFrom terra rast classify values setValues
#' @importFrom ggplot2 ggplot geom_tile aes scale_fill_manual theme_bw theme
#'   element_text labs coord_sf ggsave
#' @importFrom ggspatial annotation_north_arrow annotation_scale north_arrow_orienteering
#' @importFrom grid unit
#' @export
sz_priority_rank_map <-
  function(dir,
           output_folder_name,
           breaks,
           labels,
           palette = "viridis",
           save_map = TRUE,
           rank_map_name = "rank_map_name") {
    rank_map_path <- file.path(dir, output_folder_name, "rankmap.tif")

    if (!file.exists(rank_map_path)) {
      stop("File rankmap.tif not found.")
    }

    if (length(breaks) != (length(labels) + 1L)) {
      stop("Number of labels must be equal to the number of breaks - 1")
    }

    rank_map <- terra::rast(rank_map_path)

    rcl <- cbind(
      breaks[-length(breaks)],
      breaks[-1L],
      seq_along(labels)
    )

    r_reclass_num <- terra::classify(
      rank_map,
      rcl = rcl,
      include.lowest = FALSE,
      brackets = FALSE
    )

    r_values <- terra::values(r_reclass_num)
    r_labels <- factor(
      r_values,
      levels = seq_along(labels),
      labels = labels
    )

    r_reclass_cat <- terra::setValues(r_reclass_num, r_labels)
    
    # Convert raster to data.frame
    raster_df <-
      as.data.frame(r_reclass_cat, xy = TRUE, na.rm = TRUE)
    
    # Check colors pallete
    if (palette[1] == "viridis") {
      pal <-
        viridis::viridis(nrow(rcl), direction = -1, option = "H") # viridis: default
    } else {
      pal <- palette
    }
    
    # ggplot2
    gg_rank_map <-
      # ggplot(raster_df, aes(x = x, y = y, fill = rankmap)) +
      # geom_tile() +
      ggplot() +
      geom_tile(data = raster_df, aes(x = x, y = y, fill = rankmap)) +
      scale_fill_manual(values = pal, name = "") + # TODO ADICIONAR TITULO LEG
      theme_bw() +
      coord_sf(crs = 4326) +
      annotation_north_arrow(
        location = "tl",
        which_north = "grid",
        height = unit(0.8, "cm"),
        width = unit(0.6, "cm"),
        style = north_arrow_orienteering()
      ) +
      annotation_scale(location = "bl",
                       width_hint = 0.2,
                       text_cex = 1.2) +
      theme_bw(base_size = 15) +
      theme(legend.title = element_text(size = 18, face = "bold"),
            legend.text = element_text(size = 14)) +
      #legend.position = c(.2, .2),
      #legend.background = element_rect(colour = "black")) +
      labs(x = "Longitude", y = "Latitude")
    
    if (save_map) {
      fs::dir_create(dir, "sz_output")
      ggplot2::ggsave(
        plot = gg_rank_map,
        filename = file.path(dir, "sz_output", paste0(rank_map_name, ".png")),
        width = 14,
        height = 11,
        dpi = 300
      )
    }
    gg_rank_map
  }
