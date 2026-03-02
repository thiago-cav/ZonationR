# Global variables / column names used in NSE (dplyr, ggplot2, tidyr)
# to avoid "undefined global" notes in R CMD check.
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c(
    ".", "Features Names", "Rank", "Representation",
    "Group", "group_category", "group_value",
    "feat_list", "filename", "minimun_value", "rank.", "rankmap",
    "weight", "weight_type", "x", "y"
  ))
}
