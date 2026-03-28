test_that("feature_representation returns expected structure", {

  r <- terra::rast(nrows = 5, ncols = 5)
  f1 <- terra::setValues(r, runif(terra::ncell(r)))
  f2 <- terra::setValues(r, runif(terra::ncell(r)))

  features <- c(f1, f2)
  names(features) <- c("sp1", "sp2")

  result <- feature_representation(features)

  expect_true(is.list(result))
  expect_true("representation_layers" %in% names(result))
  expect_true("representation_in_area" %in% names(result))

  expect_s4_class(result$representation_layers, "SpatRaster")
  expect_null(result$representation_in_area)
})


test_that("fractional representation layers sum to 1", {

  r <- terra::rast(nrows = 5, ncols = 5)

  f1 <- terra::setValues(r, runif(terra::ncell(r)))
  f2 <- terra::setValues(r, runif(terra::ncell(r)))

  features <- c(f1, f2)

  result <- feature_representation(features)

  sums <- terra::global(result$representation_layers, "sum", na.rm = TRUE)

  expect_equal(sums[1,1], 1, tolerance = 1e-6)
  expect_equal(sums[2,1], 1, tolerance = 1e-6)
})


test_that("representation inside area mask is calculated correctly", {

  r <- terra::rast(nrows = 5, ncols = 5)

  f1 <- terra::setValues(r, rep(1, terra::ncell(r)))
  f2 <- terra::setValues(r, rep(2, terra::ncell(r)))

  features <- c(f1, f2)
  names(features) <- c("sp1", "sp2")

  mask <- r
  terra::values(mask) <- c(rep(1, 10), rep(0, 15))

  result <- feature_representation(features, mask)

  expect_true(all(result$representation_in_area >= 0))
  expect_true(all(result$representation_in_area <= 1))
  expect_named(result$representation_in_area, c("sp1", "sp2"))
})



test_that("SpatVector masks are rasterized correctly", {

  r <- terra::rast(nrows = 5, ncols = 5, xmin = 0, xmax = 5, ymin = 0, ymax = 5)

  f1 <- terra::setValues(r, runif(terra::ncell(r)))
  f2 <- terra::setValues(r, runif(terra::ncell(r)))

  features <- c(f1, f2)

  poly <- terra::as.polygons(r)
  poly <- poly[1:5, ]

  result <- feature_representation(features, poly)

  expect_true(is.numeric(result$representation_in_area))
  expect_length(result$representation_in_area, 2)
})



test_that("layer names are preserved", {

  r <- terra::rast(nrows = 5, ncols = 5)

  f1 <- terra::setValues(r, runif(terra::ncell(r)))
  f2 <- terra::setValues(r, runif(terra::ncell(r)))

  features <- c(f1, f2)
  names(features) <- c("species_a", "species_b")

  result <- feature_representation(features)

  expect_equal(names(result$representation_layers),
               c("species_a", "species_b"))
})

