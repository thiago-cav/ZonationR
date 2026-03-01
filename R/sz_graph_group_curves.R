#' Plot Zonation group curves (min, mean, or weighted mean)
#'
#' Reads \code{group_curves.csv} from the Zonation output, selects the
#' requested summary statistic (\code{min}, \code{mean}, or \code{weighted_mean}),
#' and draws a line plot of representation vs priority rank by group. Optionally
#' renames groups, uses faceting, saves as PNG, or produces an interactive
#' plotly graph (and saves as HTML).
#'
#' @param dir Character. Path to the directory containing the Zonation output
#'   folder.
#' @param output_folder_name Character. Name of the Zonation output folder
#'   (e.g. the run name).
#' @param palette Character. Either \code{"viridis"} (default) to use
#'   \code{viridis::viridis} (option "H"), or a vector of colour values (one per
#'   group).
#' @param fun Character. Summary statistic to plot: \code{"min"}, \code{"mean"},
#'   or \code{"weighted_mean"}. Must match column name prefixes in
#'   \code{group_curves.csv}. Default \code{"mean"}.
#' @param group_names Character vector or NULL. Custom names for groups (same
#'   length and order as the unique groups). If NULL, group identifiers from
#'   the file are used. Default NULL.
#' @param save_graph Logical. If TRUE, the plot is saved (PNG when static, HTML
#'   when interactive). Default FALSE.
#' @param graph_name Character. Base name for the output file (without
#'   extension). Default \code{"graph_group_curves"}.
#' @param use_facet_wrap Logical. If TRUE, add \code{facet_wrap(~Group)} so
#'   each group is in a separate panel. Default FALSE.
#' @param interactive_graph Logical. If TRUE, convert the plot to an interactive
#'   plotly graph (and save as HTML when \code{save_graph} is TRUE). Default
#'   FALSE.
#'
#' @returns A \code{ggplot} object (or a \code{plotly} object if
#'   \code{interactive_graph} is TRUE). If \code{save_graph} is TRUE, also
#'   writes \code{dir/sz_output/<graph_name>.png} or \code{.html} as appropriate.
#'
#' @importFrom readr read_table
#' @keywords internal
sz_graph_group_curves <-
  function(dir,
           output_folder_name,
           palette = "viridis",
           fun = "mean",
           group_names = NULL,
           save_graph = FALSE,
           graph_name = "graph_group_curves",
           use_facet_wrap = FALSE,
           interactive_graph = FALSE
  ) {

    group_curves_path <- file.path(dir, output_folder_name, "group_curves.csv")

    if (!file.exists(group_curves_path)) {
      stop("Group curves file not found.")
    }

    group_curves <-
      suppressWarnings(suppressMessages(readr::read_table(group_curves_path)))

    last_column <- ncol(group_curves)
    if (sum(group_curves[, last_column], na.rm = TRUE) == 0) {
      group_curves <- group_curves[, -last_column]
    }
    
    # Find unique group categories (e.g., number)
    unique_groups <-
      group_curves %>%
      select(contains("min")) %>%
      names() %>%
      stringr::str_extract(., "\\d+")
    
    nms <- make.names(names(group_curves))
    nms <- gsub("^X\\.", "", nms)
    colnames(group_curves) <- nms
    
    v_fun <-
      group_curves %>%
      select(rank., tidyr::starts_with(fun)) %>%
      pivot_longer(!c(rank.),
                   names_to = "group_category",
                   values_to = "group_value") %>%
      rename(Representation = group_value,
             Group = group_category,
             Rank = rank.) %>%
      mutate(Group = gsub(fun, replacement = "", x = Group),
             Group = gsub("\\.", replacement = "", x = Group))
    
    if(!is.null(group_names)) {
      if (length(group_names) != length(unique(v_fun$Group))) {
        stop("Names provided are not of the same length of Groups")
      }
      
      v_fun <- v_fun %>%
        mutate(Group = as.character(Group)) %>%
        mutate(Group = recode(Group,
                              !!!setNames(group_names, unique(v_fun$Group))))
    }
    
    # Check colors pallete
    if (palette[1] == "viridis") {
      pal <-
        viridis::viridis(length(unique_groups), direction = -1, option = "H") # viridis: default
    } else {
      pal <- palette
    }
    
    plot_zonation_curves <-
      v_fun %>%
      ggplot() +
      aes(x = Rank, y = Representation,
          color = Group) %>%
      #aes(x = rank., y = group_value, color = reorder(rasters, -valores)) %>%
      geom_line(linewidth = 0.7) +
      scale_x_continuous(breaks = seq(0, 1, 0.1), expand = c(0, 0)) +
      scale_y_continuous(breaks = seq(0, 1, 0.1), expand = c(0, 0)) +
      theme_light(base_size = 20, base_family = "Roboto") +
      # geom_vline(xintercept = c(0.2, 0.4, 0.6, 0.8), linetype = "longdash",
      #            alpha = 0.2, linewidth = 0.2) +
      theme(
        panel.border = element_rect(color = "black"),
        axis.text = element_text(color = "black"),
        axis.ticks = element_line(color = "black"),
        panel.grid.major = element_line(color = NA),
        panel.grid.minor = element_line(color = "gray90"),
        axis.title = element_text(face="bold"), element_text(size = 45),
        legend.title = element_text(face="bold")) +
      scale_color_manual(values = pal) +
      guides(color = guide_legend(override.aes = list(size = 8))) +
      labs(
        x = "Priority rank",
        y = "Representation",
        color = "Groups"
      )
    
    if(use_facet_wrap){
      plot_zonation_curves <-
        plot_zonation_curves + facet_wrap(~Group)
    }
    
    if (save_graph && isFALSE(interactive_graph)) {
      fs::dir_create(dir, "sz_output")
      ggplot2::ggsave(
        plot = plot_zonation_curves,
        filename = file.path(dir, "sz_output", paste0(graph_name, ".png")),
        width = 14,
        height = 11,
        dpi = 300
      )
    }
    
    if(interactive_graph) {
      plot_zonation_curves <- ggplotly(plot_zonation_curves)
    }
    
    if (interactive_graph && save_graph) {
      fs::dir_create(dir, "sz_output")
      htmlwidgets::saveWidget(
        plot_zonation_curves,
        file.path(dir, "sz_output", paste0(graph_name, ".html"))
      )
    }

    plot_zonation_curves
  }

