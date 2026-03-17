test_that("check_dir_writable returns TRUE for writable directory", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  expect_true(check_dir_writable(tmp_dir))
})

test_that("check_dir_writable errors for non-existent directory", {
  nonexistent_dir <- file.path(tempdir(), "nonexistent-dir-for-check_dir_writable")

  expect_error(
    check_dir_writable(nonexistent_dir),
    "does not exist"
  )
})

test_that("check_dir_writable errors for non-writable directory on supported OS", {
  skip_on_os("windows")

  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit({
    Sys.chmod(tmp_dir, mode = "0777")
    unlink(tmp_dir, recursive = TRUE)
  }, add = TRUE)

  Sys.chmod(tmp_dir, mode = "0555")

  expect_error(
    check_dir_writable(tmp_dir),
    "is not writable"
  )
})
