# Helper: create a temp space-separated file with sample data
create_sample_csv <- function(dir, output_folder_name = "output") {
  dir.create(file.path(dir, output_folder_name), recursive = TRUE, showWarnings = FALSE)

  file_path <- file.path(dir, output_folder_name, "feature_curves.csv")

  sample_data <- data.frame(
    rank = seq(0, 1, by = 0.1),
    feature1 = seq(0.1, 1, length.out = 11),
    feature2 = rev(seq(0.1, 1, length.out = 11))
  )

  write.table(sample_data, file_path, sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

  return(file_path)
}

test_that("Error if feature_curves.csv does not exist", {
  expect_error(
    coverage_distribution("nonexistent_dir", target_rank = 0.5),
    "feature_curves.csv not found"
  )
})

test_that("Function returns a ggplot object", {
  tmp_dir <- tempfile()
  create_sample_csv(tmp_dir)

  p <- coverage_distribution(tmp_dir, target_rank = 0.5)
  expect_s3_class(p, "ggplot")

  unlink(tmp_dir, recursive = TRUE)
})

test_that("Function filters data correctly by target_rank", {
  tmp_dir <- tempfile()
  create_sample_csv(tmp_dir)

  p <- coverage_distribution(tmp_dir, target_rank = 0.5)

  plot_data <- p$data

  # All coverage values should be numeric and between 0 and 1
  expect_true(all(plot_data$coverage >= 0 & plot_data$coverage <= 1))
  expect_true(is.numeric(plot_data$coverage))

  unlink(tmp_dir, recursive = TRUE)
})

test_that("Function saves file when save_path is provided", {
  tmp_dir <- tempfile()
  create_sample_csv(tmp_dir)
  out_file <- tempfile(fileext = ".png")

  coverage_distribution(tmp_dir, target_rank = 0.5, save_path = out_file)

  expect_true(file.exists(out_file))

  unlink(tmp_dir, recursive = TRUE)
  unlink(out_file)
})
