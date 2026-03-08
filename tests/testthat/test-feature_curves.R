test_that("feature_curves errors if feature_curves.csv does not exist", {
  tmp_dir <- tempfile()
  dir.create(file.path(tmp_dir, "output"), recursive = TRUE)

  expect_error(
    feature_curves(dir = tmp_dir),
    "feature_curves.csv not found"
  )
})

test_that("feature_curves errors if features_info.csv is missing or mismatch occurs", {
  tmp_dir <- tempfile()
  tmp_output <- file.path(tmp_dir, "output")
  dir.create(tmp_output, recursive = TRUE)

  # Only feature_curves.csv exists
  write.table(
    data.frame(
      rank = seq(0, 1, length.out = 5),
      species1 = runif(5),
      species2 = runif(5)
    ),
    file.path(tmp_output, "feature_curves.csv"),
    sep = " ",
    row.names = FALSE
  )

  expect_error(
    feature_curves(dir = tmp_dir),
    "features_info.csv not found"
  )

  # Create features_info.csv with fewer features to trigger mismatch
  write.table(
    data.frame(fname = c("species1")),
    file.path(tmp_output, "features_info.csv"),
    sep = " ",
    row.names = FALSE
  )

  expect_error(
    feature_curves(dir = tmp_dir),
    "Mismatch between feature curves"
  )
})

test_that("feature_curves returns a ggplot object for valid input", {
  tmp_dir <- tempfile()
  tmp_output <- file.path(tmp_dir, "output")
  dir.create(tmp_output, recursive = TRUE)

  # Create feature_curves.csv
  write.table(
    data.frame(
      rank = seq(0, 1, length.out = 5),
      species1 = runif(5),
      species2 = runif(5)
    ),
    file.path(tmp_output, "feature_curves.csv"),
    sep = " ",
    row.names = FALSE
  )

  # Create features_info.csv
  write.table(
    data.frame(fname = c("species1", "species2")),
    file.path(tmp_output, "features_info.csv"),
    sep = " ",
    row.names = FALSE
  )

  p <- feature_curves(dir = tmp_dir)
  expect_s3_class(p, "ggplot")
})
