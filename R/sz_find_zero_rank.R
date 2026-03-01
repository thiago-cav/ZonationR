#' Find the rank where each feature first reaches at or below a threshold
#'
#' For each feature column in the feature curves, finds the first row (by rank
#' order) where the representation value is less than or equal to \code{value}.
#' Typical use is to find where each feature reaches zero (or another target).
#'
#' @param feat_curves Data frame. Formatted feature curves with \code{rank} in
#'   the first column and one column per feature (e.g. from
#'   \code{\link{sz_format_feature_curves}}).
#' @param value Numeric. Threshold; the function returns the rank at which each
#'   feature's value is first \code{<= value} (e.g. \code{0} for zero).
#'
#' @returns A data frame with two columns:
#'   \itemize{
#'     \item \code{feature}: feature name (column name from \code{feat_curves}).
#'     \item \code{rank_value}: rank at which that feature first reaches \code{<= value}, or \code{NA} if it never does.
#'   }
#'
#' @export
sz_find_zero_rank <- function(feat_curves, value) {
  rank_col <- feat_curves[, 1L]
  features <- feat_curves[, -1L, drop = FALSE]

  zero_ranks <- apply(features, 2L, function(col) {
    zero_index <- which(col <= value)
    if (length(zero_index) > 0L) {
      rank_col[zero_index[1L]]
    } else {
      NA_real_
    }
  })

  result <- data.frame(
    feature = names(zero_ranks),
    rank_value = zero_ranks,
    stringsAsFactors = FALSE
  )
  rownames(result) <- NULL
  result
}
