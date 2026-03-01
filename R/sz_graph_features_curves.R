#' Plot feature curves (representation vs priority rank)
#'
#' Takes formatted feature curves and a set of feature names, reshapes to long
#' format, and draws a line plot of representation vs priority rank (one line
#' per feature). Optionally saves as PNG or an interactive plotly HTML.
#'
#' @param dir Character. Path to the directory where \code{sz_output} will be
#'   created when saving. Used only if \code{save_graph} is TRUE.
#' @param output_folder_name Character. Name of the Zonation output folder
#'   (currently unused; kept for API consistency).
#' @param palette Character. Either \code{"viridis"} (default) to use
#'   \code{viridis::viridis} (option "H"), or a single colour or vector of
#'   colours for the lines.
#' @param feat_curves_formated Data frame. Formatted feature curves with
#'   \code{rank} in the first column and one column per feature (e.g. from
#'   \code{\link{sz_format_feature_curves}}).
#' @param features_names Character vector. Names of the feature columns to plot
#'   (must match column names in \code{feat_curves_formated}).
#' @param save_graph Logical. If TRUE, the plot is saved (PNG when static, HTML
#'   when interactive). Default FALSE.
#' @param graph_name Character. Base name for the output file (without
#'   extension). Default \code{"graph_features_curves"}.
#' @param interactive_graph Logical. If TRUE, convert to an interactive plotly
#'   graph (and save as HTML when \code{save_graph} is TRUE). Default FALSE.
#'
#' @returns A \code{ggplot} object (or \code{plotly} if
#'   \code{interactive_graph} is TRUE). If \code{save_graph} is TRUE, also
#'   writes \code{dir/sz_output/<graph_name>.png} or \code{.html}.
#'
#' @importFrom dplyr select all_of rename_with
#' @importFrom tidyr pivot_longer
#' @importFrom magrittr %>%
#' @importFrom stringr str_to_title str_replace_all
#' @importFrom ggplot2 ggplot aes geom_line scale_color_manual scale_x_continuous
#'   scale_y_continuous theme_light geom_vline theme element_rect element_text
#'   element_line guides guide_legend labs
#' @export
sz_graph_features_curves <-
  function(dir,
           output_folder_name,
           palette = "viridis",
           feat_curves_formated,
           features_names,
           save_graph = FALSE,
           graph_name = "graph_features_curves",
           interactive_graph = FALSE
  ) {

    v_fun <-
      feat_curves_formated %>%
      select(rank, all_of(features_names)) %>%
      rename_with(str_to_title) %>%
      rename_with(~ str_replace_all(., "_", " ")) %>%
      pivot_longer(!c(Rank),
                   names_to = "Features Names",
                   values_to = "Representation")

    if (palette[1] == "viridis") {
      pal <-
        viridis::viridis(length(features_names), direction = -1, option = "H")
    } else {
      pal <- palette
    }

    color_scheme <- function(pal) {
      if (length(pal) > 1) {
        start <-
          v_fun %>%
          ggplot() +
          aes(x = Rank, y = Representation, color = `Features Names`) +
          geom_line(linewidth = 0.6) +
          scale_color_manual(values = pal)
      } else {
        start <-
          v_fun %>%
          ggplot() +
          aes(x = Rank, y = Representation, group = `Features Names`) +
          geom_line(linewidth = 0.6, color = pal)
      }
      start
    }

    plot_feat_curves <-
      color_scheme(pal) +
      scale_x_continuous(breaks = seq(0, 1, 0.1)) +
      scale_y_continuous(breaks = seq(0, 1, 0.1)) +
      theme_light(base_size = 20, base_family = "Roboto") +
      geom_vline(xintercept = c(0.2, 0.4, 0.6, 0.8), linetype = "longdash",
                 alpha = 0.3, linewidth = 0.3) +
      theme(
        panel.border = element_rect(color = "black"),
        axis.text = element_text(color = "black"),
        axis.ticks = element_line(color = "black"),
        panel.grid.major = element_line(color = NA),
        panel.grid.minor = element_line(color = NA),
        axis.title = element_text(face = "bold"), element_text(size = 50),
        legend.title = element_text(face = "bold"),
        legend.position = "none") +
      scale_color_manual(values = pal) +
      guides(color = guide_legend(override.aes = list(size = 8))) +
      labs(
        x = "Priority rank",
        y = "Representation",
        color = "Features"
      )

    if (save_graph && isFALSE(interactive_graph)) {
      fs::dir_create(dir, "sz_output")
      ggplot2::ggsave(
        plot = plot_feat_curves,
        filename = file.path(dir, "sz_output", paste0(graph_name, ".png")),
        width = 14,
        height = 11,
        dpi = 300
      )
    }

    if (interactive_graph) {
      plot_feat_curves <- plotly::ggplotly(plot_feat_curves)
    }

    if (interactive_graph && save_graph) {
      fs::dir_create(dir, "sz_output")
      htmlwidgets::saveWidget(
        plot_feat_curves,
        file.path(dir, "sz_output", paste0(graph_name, ".html"))
      )
    }

    plot_feat_curves
  }
