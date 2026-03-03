#' Calculate similarity between Zonation rank maps
#'
#' This function calculates similarity between two spatial rank maps using
#' Schoener's D or the Jaccard index.
#'
#' @param r1 A \code{SpatRaster} rank map (from the \code{terra} package).
#'   Required if \code{rstack} is not provided.
#' @param r2 A \code{SpatRaster} rank map with the same dimensions as
#'   \code{r1}. Required if \code{rstack} is not provided.
#' @param rstack A \code{SpatRaster} with multiple layers. If provided, the
#'   function calculates pairwise coefficients between all layers.
#' @param method Character, either \code{"schoener"} (default) or
#'   \code{"jaccard"}.
#' @param threshold Numeric, required if \code{method = "jaccard"}. Cells with
#'   rank greater than or equal to this threshold are considered selected.
#'
#' @returns A numeric value between 0 and 1 if comparing two rasters, or a
#'   matrix of pairwise coefficients if using \code{rstack}.
#' @examples
#' # Create two example priority rank maps
#' r1 <- terra::rast(nrows = 5, ncols = 5)
#' terra::values(r1) <- runif(terra::ncell(r1))
#'
#' r2 <- terra::rast(r1)
#' terra::values(r2) <- runif(terra::ncell(r2))
#'
#' # Schoener's D
#' rank_similarity(r1, r2, method = "schoener")
#'
#' # Jaccard index with threshold
#' rank_similarity(r1, r2, method = "jaccard", threshold = 0.7)
#'
#' @import terra
#' @export
rank_similarity <- function(r1 = NULL, r2 = NULL, rstack = NULL, method = c("schoener", "jaccard"), threshold = NULL) {

  method <- match.arg(method)

  # Internal function to compute similarity between two layers
  compute_similarity <- function(vals1, vals2, method, threshold) {
    na_idx <- is.na(vals1) | is.na(vals2)
    vals1 <- vals1[!na_idx]
    vals2 <- vals2[!na_idx]

    if (method == "schoener") {
      p1 <- vals1 / sum(vals1)
      p2 <- vals2 / sum(vals2)
      return(1 - 0.5 * sum(abs(p1 - p2)))
    } else if (method == "jaccard") {
      if (is.null(threshold)) stop("Threshold must be provided for Jaccard index")
      bin1 <- vals1 >= threshold
      bin2 <- vals2 >= threshold
      return(sum(bin1 & bin2) / sum(bin1 | bin2))
    }
  }

  # Case 1: pairwise between r1 and r2
  if (!is.null(r1) && !is.null(r2)) {
    if (!all(dim(r1) == dim(r2))) stop("Rank maps must have the same dimensions")
    vals1 <- terra::values(r1)
    vals2 <- terra::values(r2)
    return(compute_similarity(vals1, vals2, method, threshold))
  }

  # Case 2: pairwise for all layers in rstack
  if (!is.null(rstack)) {
    nl <- terra::nlyr(rstack)
    coef_matrix <- matrix(NA, nrow = nl, ncol = nl)
    layer_vals <- lapply(1:nl, function(i) terra::values(rstack[[i]]))

    for (i in 1:nl) {
      for (j in i:nl) {
        coef_matrix[i, j] <- compute_similarity(layer_vals[[i]], layer_vals[[j]], method, threshold)
        coef_matrix[j, i] <- coef_matrix[i, j]  # symmetric
      }
    }
    rownames(coef_matrix) <- colnames(coef_matrix) <- names(rstack)
    return(coef_matrix)
  }

  stop("Provide either r1 and r2, or rstack")
}
