test_that("settings_file creates correct .z5 file", {
  # Run all test code inside a temporary directory safely
  withr::with_dir(tempdir(), {

    feature_file <- "feature_list.txt"
    external_solution <- "external_solution.tif"
    mask_layer <- "mask_layer.tif"
    hier_mask <- "hier_mask.tif"
    cost <- "cost_layer.tif"

    # Create dummy files
    file.create(feature_file)
    file.create(external_solution)
    file.create(mask_layer)
    file.create(hier_mask)
    file.create(cost)

    # Run the function under test
    settings_file(
      feature_list_file = feature_file,
      external_solution_file = external_solution,
      analysis_area_mask_layer = mask_layer,
      hierarchic_mask_layer = hier_mask,
      cost_layer = cost
    )

    # Check file creation
    expect_true(file.exists("settings_file.z5"))

    # Check file contents
    lines <- readLines("settings_file.z5")

    expect_true(any(grepl(paste0("feature list file = ", feature_file), lines)))
    expect_true(any(grepl(paste0("external solution = ", external_solution), lines)))
    expect_true(any(grepl(paste0("analysis area mask layer = ", mask_layer), lines)))
    expect_true(any(grepl(paste0("hierarchic mask layer = ", hier_mask), lines)))
    expect_true(any(grepl(paste0("cost layer = ", cost), lines)))
  })
})
