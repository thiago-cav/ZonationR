test_that("command_file creates a command file", {
  # Use tempdir() safely with withr::with_dir()
  withr::with_dir(tempdir(), {

    settings <- tempfile(fileext = ".z5")
    file.create(settings)

    command_file(
      zonation_path = "C:/Zonation",
      settings_file = settings
    )

    # Determine expected file name based on OS
    expected_file <- if (.Platform$OS.type == "windows") {
      "command_file.cmd"
    } else {
      "command_file.sh"
    }

    expect_true(file.exists(expected_file))
  })
})

test_that("command_file errors on invalid flags", {
  settings <- tempfile(fileext = ".z5")
  file.create(settings)

  expect_error(
    command_file(
      zonation_path = "C:/Zonation",
      settings_file = settings,
      flags = "z"
    ),
    "Invalid analysis option flag"
  )
})
