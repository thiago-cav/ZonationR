# Temporary folder for tests
tmp_dir <- tempdir()
output_folder <- file.path(tmp_dir, "output")
if (!dir.exists(output_folder)) dir.create(output_folder, recursive = TRUE)

# Example space-separated summary_curves.csv
example_csv <- ' "rank" "remaining_area" "remaining_cost" "mean" "max" "min"
0 99186 38882 1 1 1
0.00009 99177 38877 1 1 1
0.00018 99168 38872 1 1 1
0.00027 99159 38868 1 1 1
0.00036 99150 38865 1 1 1
0.00045 99141 38862 1 1 1
0.2 90000 35000 1 1 1
0.5 80000 20000 1 1 1
1.0 70000 0 1 1 1'

writeLines(example_csv, con = file.path(output_folder, "summary_curves.csv"))

# Landscape proportions to test
landscape_props <- c(0.03, 0.2, 0.5)

# -----------------------------
# Test structure and types
# -----------------------------
test_that("cost_summary returns correct structure", {
  res <- cost_summary(tmp_dir, output_folder_name = "output", landscape_prop = landscape_props)

  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), length(landscape_props))
  expect_true(all(c("rank", "remaining_cost", "percentage") %in% names(res)))
})

# -----------------------------
# Test percentage calculation
# -----------------------------
test_that("percentage is correctly calculated", {
  res <- cost_summary(tmp_dir, output_folder_name = "output", landscape_prop = landscape_props)
  max_cost <- max(c(38882, 38877, 38872, 38868, 38865, 38862, 35000, 20000, 0))
  expected_percentage <- (res$remaining_cost / max_cost) * 100
  expect_equal(res$percentage, expected_percentage)
})

# -----------------------------
# Test CSV output
# -----------------------------
test_that("save_output writes CSV correctly", {
  out_dir <- file.path(tmp_dir, "performance")
  if (dir.exists(out_dir)) unlink(out_dir, recursive = TRUE)  # clean previous

  res <- cost_summary(tmp_dir, output_folder_name = "output",
                      landscape_prop = landscape_props,
                      save_output = TRUE)

  csv_path <- file.path(out_dir, "cost_summary.csv")
  expect_true(file.exists(csv_path))

  saved_res <- read.csv(csv_path, stringsAsFactors = FALSE)
  expect_equal(saved_res$rank, res$rank)
  expect_equal(saved_res$remaining_cost, res$remaining_cost)
  expect_equal(saved_res$percentage, res$percentage)
})

# -----------------------------
# Test edge cases
# -----------------------------
test_that("landscape_prop outside range picks closest", {
  res <- cost_summary(tmp_dir, output_folder_name = "output",
                      landscape_prop = c(-0.1, 1.2))

  # Should pick the min (0) and max (1.0) ranks
  expect_equal(res$rank, c(-0.1, 1.2))
  expect_equal(res$remaining_cost, c(38882, 0))  # closest rows in file
})
