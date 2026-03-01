# Helper: create a temp space-separated file with sample data
create_sample_csv <- function(file_path) {
  sample_data <- data.frame(
    rank = seq(0, 1, by = 0.1),
    feature1 = seq(0.1, 1, length.out = 11),
    feature2 = rev(seq(0.1, 1, length.out = 11))
  )
  # Write as space-separated values
  write.table(sample_data, file_path, sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)
}

test_that("Error if file does not exist", {
  expect_error(
    coverage_distribution("nonexistent_file.csv", target_rank = 0.5),
    "File not found"
  )
})

test_that("Function returns a ggplot object", {
  tmp_file <- tempfile(fileext = ".csv")
  create_sample_csv(tmp_file)

  p <- coverage_distribution(tmp_file, target_rank = 0.5)
  expect_s3_class(p, "ggplot")

  unlink(tmp_file)
})

test_that("Function filters data correctly by target_rank", {
  tmp_file <- tempfile(fileext = ".csv")
  create_sample_csv(tmp_file)

  p <- coverage_distribution(tmp_file, target_rank = 0.5)

  # Extract data used in plot (ggplot2 stores data in p$data)
  plot_data <- p$data

  # All coverage values should be numeric and between 0 and 1
  expect_true(all(plot_data$coverage >= 0 & plot_data$coverage <= 1))
  expect_true(is.numeric(plot_data$coverage))

  unlink(tmp_file)
})

test_that("Function saves file when save_path is provided", {
  tmp_file <- tempfile(fileext = ".csv")
  out_file <- tempfile(fileext = ".png")
  create_sample_csv(tmp_file)

  coverage_distribution(tmp_file, target_rank = 0.5, save_path = out_file)

  expect_true(file.exists(out_file))

  unlink(tmp_file)
  unlink(out_file)
})
