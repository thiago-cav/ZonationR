test_that("priority_map works with continuous raster", {
  # create a small example raster
  r <- terra::rast(ncols = 5, nrows = 5, xmin = 0, xmax = 5, ymin = 0, ymax = 5)
  terra::values(r) <- runif(terra::ncell(r))
  names(r) <- "rankmap"  # mimic a real rankmap.tif

  # unique temporary directory
  tmp_dir <- file.path(tempdir(), paste0("test_cont_", sample(1e5, 1)))
  dir.create(file.path(tmp_dir, "output"), recursive = TRUE)

  # write raster with overwrite
  terra::writeRaster(r, file.path(tmp_dir, "output", "rankmap.tif"), overwrite = TRUE)

  # continuous map
  p <- priority_map(tmp_dir, classify = FALSE)

  # check type
  expect_s3_class(p, "gg")
  expect_true("ggplot" %in% class(p))
})

test_that("priority_map works with classified raster", {
  r <- terra::rast(ncols = 5, nrows = 5, xmin = 0, xmax = 5, ymin = 0, ymax = 5)
  terra::values(r) <- runif(terra::ncell(r))
  names(r) <- "rankmap"  # mimic a real rankmap.tif

  tmp_dir <- file.path(tempdir(), paste0("test_class_", sample(1e5, 1)))
  dir.create(file.path(tmp_dir, "output"), recursive = TRUE)
  terra::writeRaster(r, file.path(tmp_dir, "output", "rankmap.tif"), overwrite = TRUE)

  breaks <- c(0, 0.25, 0.5, 0.75, 1)
  labels <- c("Low", "Medium", "High", "Very High")

  p <- priority_map(tmp_dir, classify = TRUE, breaks = breaks, labels = labels)

  expect_s3_class(p, "gg")
  expect_true("ggplot" %in% class(p))
})

test_that("priority_map saves the plot", {
  r <- terra::rast(ncols = 5, nrows = 5, xmin = 0, xmax = 5, ymin = 0, ymax = 5)
  terra::values(r) <- runif(terra::ncell(r))
  names(r) <- "rankmap"  # mimic a real rankmap.tif

  tmp_dir <- file.path(tempdir(), paste0("test_save_", sample(1e5, 1)))
  dir.create(file.path(tmp_dir, "output"), recursive = TRUE)
  terra::writeRaster(r, file.path(tmp_dir, "output", "rankmap.tif"), overwrite = TRUE)

  save_file <- file.path(tmp_dir, "test_map.png")
  breaks <- c(0, 0.25, 0.5, 0.75, 1)
  labels <- c("Low", "Medium", "High", "Very High")

  p <- priority_map(tmp_dir, classify = TRUE, breaks = breaks, labels = labels,
                    save_path = save_file)

  expect_true(file.exists(save_file))
  expect_s3_class(p, "gg")
})
