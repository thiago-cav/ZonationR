test_that("summary_curves errors if file does not exist", {
  expect_error(
    summary_curves(
      data_path = "this/file/does/not/exist.csv",
      metrics = "mean"
    ),
    "File not found"
  )
})

test_that("summary_curves errors if rank column is missing", {
  tmp <- tempfile(fileext = ".csv")

  write.table(
    data.frame(mean = seq(0, 1, length.out = 10)),
    tmp,
    sep = " ",
    row.names = FALSE
  )

  expect_error(
    summary_curves(
      data_path = tmp,
      metrics = "mean"
    ),
    "Column 'rank' not found"
  )
})

test_that("summary_curves errors if requested metrics are missing", {
  tmp <- tempfile(fileext = ".csv")

  write.table(
    data.frame(
      rank = seq(0, 1, length.out = 10),
      mean = runif(10)
    ),
    tmp,
    sep = " ",
    row.names = FALSE
  )

  expect_error(
    summary_curves(
      data_path = tmp,
      metrics = c("mean", "max")
    ),
    "were not found in the file"
  )
})

test_that("summary_curves errors when overlaying incompatible metric families", {
  tmp <- tempfile(fileext = ".csv")

  write.table(
    data.frame(
      rank = seq(0, 1, length.out = 10),
      mean = runif(10),
      remaining_area = runif(10)
    ),
    tmp,
    sep = " ",
    row.names = FALSE
  )

  expect_error(
    summary_curves(
      data_path = tmp,
      metrics = c("mean", "remaining_area"),
      facet = FALSE
    ),
    "Cannot overlay metrics with different units"
  )
})

test_that("summary_curves returns a ggplot object for valid overlay input", {
  tmp <- tempfile(fileext = ".csv")

  write.table(
    data.frame(
      rank = seq(0, 1, length.out = 10),
      mean = runif(10),
      max = runif(10)
    ),
    tmp,
    sep = " ",
    row.names = FALSE
  )

  p <- summary_curves(
    data_path = tmp,
    metrics = c("mean", "max")
  )

  expect_s3_class(p, "ggplot")
})

test_that("summary_curves works with facet = TRUE for different metric families", {
  tmp <- tempfile(fileext = ".csv")

  write.table(
    data.frame(
      rank = seq(0, 1, length.out = 10),
      remaining_area = runif(10),
      remaining_cost = runif(10)
    ),
    tmp,
    sep = " ",
    row.names = FALSE
  )

  p <- summary_curves(
    data_path = tmp,
    metrics = c("remaining_area", "remaining_cost"),
    facet = TRUE
  )

  expect_s3_class(p, "ggplot")
})
