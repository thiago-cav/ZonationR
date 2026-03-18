test_that("check_raster_uniformity() works correctly", {

  # -----------------------------
  # Create isolated temporary folder
  # -----------------------------
  tmp_folder <- tempfile("rasters_")
  dir.create(tmp_folder)

  # -----------------------------
  # Raster 1: reference
  # -----------------------------
  r1 <- rast(nrows = 100, ncols = 100,
             xmin = 0, xmax = 10,
             ymin = 0, ymax = 10,
             crs = "EPSG:4326")
  values(r1) <- runif(ncell(r1))
  f1 <- file.path(tmp_folder, "r1.tif")
  writeRaster(r1, f1, overwrite = TRUE)

  # Raster 2: identical
  r2 <- r1
  f2 <- file.path(tmp_folder, "r2.tif")
  writeRaster(r2, f2, overwrite = TRUE)

  # -----------------------------
  # Test 1: uniform rasters → should pass with message
  # -----------------------------
  expect_message(
    check_raster_uniformity(tmp_folder),
    "All raster files in '.*' are spatially uniform"
  )

  # -----------------------------
  # Raster 3: different resolution → should fail
  # -----------------------------
  r3 <- rast(nrows = 50, ncols = 50,
             xmin = 0, xmax = 10,
             ymin = 0, ymax = 10,
             crs = "EPSG:4326")
  values(r3) <- runif(ncell(r3))  # <-- assign values!
  f3 <- file.path(tmp_folder, "r3.tif")
  writeRaster(r3, f3, overwrite = TRUE)

  expect_error(
    check_raster_uniformity(tmp_folder),
    "Raster mismatch detected"
  )

  # Remove r3 for next test
  rm(r3); gc()
  unlink(f3)

  # -----------------------------
  # Raster 4: different CRS → should fail
  # -----------------------------
  r4 <- r1
  crs(r4) <- "EPSG:3857"
  values(r4) <- runif(ncell(r4))  # <-- assign values!
  f4 <- file.path(tmp_folder, "r4.tif")
  writeRaster(r4, f4, overwrite = TRUE)

  expect_error(
    check_raster_uniformity(tmp_folder),
    "Raster mismatch detected"
  )

  # -----------------------------
  # Cleanup all temporary rasters and objects
  # -----------------------------
  rm(r1, r2, r4); gc()
  unlink(tmp_folder, recursive = TRUE)
})
