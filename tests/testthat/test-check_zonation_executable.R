test_that("check_zonation_executable returns correct structure", {
  skip_on_os("mac")

  result <- check_zonation_executable()

  expect_type(result, "list")
  expect_named(result, c("found", "path", "executable", "os", "message"))
  expect_type(result$found, "logical")
  expect_true(result$os %in% c("Windows", "Linux"))
})

test_that("check_zonation_executable validates OS parameter", {
  # Invalid OS should error
  expect_error(
    check_zonation_executable(os = "macOS"),
    "must be either 'Windows' or 'Linux'"
  )

  expect_error(
    check_zonation_executable(os = "InvalidOS"),
    "must be either 'Windows' or 'Linux'"
  )
})

test_that("check_zonation_executable finds executable in provided path (Windows)", {
  # Skip if not on Windows
  skip_on_os(c("linux", "mac"))

  # Create temporary directory structure
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  # Create fake executable
  exe_path <- file.path(tmp_dir, "z5.exe")
  file.create(exe_path)

  # Test with provided path
  result <- check_zonation_executable(zonation_path = tmp_dir, os = "Windows")

  expect_true(result$found)
  expect_equal(result$path, normalizePath(tmp_dir))
  expect_equal(result$executable, normalizePath(exe_path))
  expect_equal(result$os, "Windows")
  expect_true(grepl("found", result$message, ignore.case = TRUE))
})

test_that("check_zonation_executable finds executable in provided path (Linux)", {
  # Skip if not on Linux
  skip_on_os(c("windows", "mac"))

  # Create temporary directory structure
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  # Create fake executable
  exe_path <- file.path(tmp_dir, "zonation5")
  file.create(exe_path)
  Sys.chmod(exe_path, mode = "0755")

  # Test with provided path
  result <- check_zonation_executable(zonation_path = tmp_dir, os = "Linux")

  expect_true(result$found)
  expect_equal(result$path, normalizePath(tmp_dir))
  expect_equal(result$executable, normalizePath(exe_path))
  expect_equal(result$os, "Linux")
  expect_true(grepl("found", result$message, ignore.case = TRUE))
})

test_that("check_zonation_executable returns not found when executable missing", {
  # Create temporary directory without executable
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  # Test with provided path that doesn't contain executable
  result <- check_zonation_executable(zonation_path = tmp_dir, os = "Windows")

  expect_false(result$found)
  expect_null(result$path)
  expect_null(result$executable)
  expect_true(grepl("not found", result$message, ignore.case = TRUE))
  expect_true(grepl("https://zonationteam.github.io/Zonation5/", result$message))
})

test_that("check_zonation_executable handles non-existent directory", {
  # Test with non-existent path
  result <- check_zonation_executable(
    zonation_path = "/nonexistent/path/that/does/not/exist",
    os = "Windows"
  )

  expect_false(result$found)
  expect_null(result$path)
  expect_null(result$executable)
})

test_that("check_zonation_executable works with NULL path", {
  skip_on_os("mac")

  # Should search common locations without error
  result <- check_zonation_executable(zonation_path = NULL)

  expect_type(result, "list")
  expect_named(result, c("found", "path", "executable", "os", "message"))
  expect_type(result$found, "logical")
})

test_that("check_zonation_executable message includes helpful information", {
  # Create temporary directory without executable
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  # Test Windows message
  result_win <- check_zonation_executable(zonation_path = tmp_dir, os = "Windows")
  expect_true(grepl("Windows installation locations", result_win$message) ||
              grepl("not found", result_win$message, ignore.case = TRUE))

  # Test Linux message
  result_linux <- check_zonation_executable(zonation_path = tmp_dir, os = "Linux")
  expect_true(grepl("Linux", result_linux$message) ||
              grepl("AppImage", result_linux$message) ||
              grepl("not found", result_linux$message, ignore.case = TRUE))
})

test_that("check_zonation_executable handles Windows executable without .exe extension", {
  # Skip if not on Windows
  skip_on_os(c("linux", "mac"))

  # Create temporary directory structure
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  # Create fake executable without .exe extension
  exe_path <- file.path(tmp_dir, "z5")
  file.create(exe_path)

  # Test with provided path
  result <- check_zonation_executable(zonation_path = tmp_dir, os = "Windows")

  expect_true(result$found)
  expect_equal(result$executable, normalizePath(exe_path))
})

test_that("check_zonation_executable detects OS automatically", {
  skip_on_os("mac")

  # Should detect OS without explicitly providing it
  result <- check_zonation_executable()

  # OS should match platform
  if (.Platform$OS.type == "windows") {
    expect_equal(result$os, "Windows")
  } else if (.Platform$OS.type == "unix" && Sys.info()["sysname"] != "Darwin") {
    expect_equal(result$os, "Linux")
  }
})

test_that("check_zonation_executable errors on macOS", {
  # Skip if not on macOS (we can't test the error on non-macOS systems)
  skip_on_os(c("windows", "linux"))

  # Should error when macOS is detected
  expect_error(
    check_zonation_executable(),
    "macOS is not currently supported"
  )

  # Should also error if macOS is explicitly provided
  expect_error(
    check_zonation_executable(os = "macOS"),
    "must be either 'Windows' or 'Linux'"
  )
})
