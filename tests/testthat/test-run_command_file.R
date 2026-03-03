test_that("run_command_file runs successfully", {
  tmp <- withr::local_tempdir()   # clean, unique temp folder
  ext <- if (.Platform$OS.type == "windows") ".cmd" else ".sh"
  cmd_file <- file.path(tmp, paste0("test_command", ext))
  file.create(cmd_file)

  # Mock system2 to simulate success
  fake_system2 <- mockery::mock(0)
  mockery::stub(ZonationR::run_command_file, "system2", fake_system2)

  expect_message(
    ZonationR::run_command_file(tmp),
    "The analysis has been completed"
  )
})

test_that("run_command_file errors on failure status", {
  tmp <- withr::local_tempdir()   # another clean temp folder
  ext <- if (.Platform$OS.type == "windows") ".cmd" else ".sh"
  cmd_file <- file.path(tmp, paste0("test_command", ext))
  file.create(cmd_file)

  # Mock system2 to simulate failure
  fake_system2 <- mockery::mock(1)
  mockery::stub(ZonationR::run_command_file, "system2", fake_system2)

  expect_error(
    ZonationR::run_command_file(tmp),
    "Command failed"
  )
})

