test_that("Schoener D returns 1 for identical rasters", {
  r <- terra::rast(nrows = 5, ncols = 5)
  terra::values(r) <- runif(terra::ncell(r))

  expect_equal(
    rank_similarity(r, r, method = "schoener"),
    1
  )
})


test_that("Jaccard returns 1 for identical rasters", {
  r <- terra::rast(nrows = 5, ncols = 5)
  terra::values(r) <- runif(terra::ncell(r))

  expect_equal(
    rank_similarity(r, r, method = "jaccard", threshold = 0.5),
    1
  )
})
