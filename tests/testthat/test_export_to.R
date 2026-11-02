mock_gridify <- function() {
  grb <- grid::rectGrob()
  gridify(grb, simple_layout())
}

test_that("Single PDF export works", {
  x <- mock_gridify()
  out_file <- file.path(tempdir(), "test_single.pdf")

  expect_no_error(export_to(x, out_file))
  expect_true(file.exists(out_file))
  expect_gt(file.size(out_file), 0)
})

test_that("Single PNG export works", {
  x <- mock_gridify()
  out_file <- file.path(tempdir(), "test_single.png")

  expect_no_error(export_to(x, out_file))
  expect_true(file.exists(out_file))
  expect_gt(file.size(out_file), 0)
})

test_that("Single JPEG export works", {
  x <- mock_gridify()
  out_file <- file.path(tempdir(), "test_single.jpg")

  expect_no_error(export_to(x, out_file))
  expect_true(file.exists(out_file))
  expect_gt(file.size(out_file), 0)
})

test_that("Multiple plots to multiple PNG files works", {
  x_list <- list(mock_gridify(), mock_gridify())
  out_files <- c(
    file.path(tempdir(), "multi1.png"),
    file.path(tempdir(), "multi2.png")
  )

  expect_no_error(export_to(x_list, out_files))
  for (f in out_files) {
    expect_true(file.exists(f))
    expect_gt(file.size(f), 0)
  }
})


test_that("Multiple plots to multiple TIFF files works", {
  x_list <- list(mock_gridify(), mock_gridify())
  out_files <- c(
    file.path(tempdir(), "multi1.tiff"),
    file.path(tempdir(), "multi2.tiff")
  )

  expect_no_error(export_to(x_list, out_files))
  for (f in out_files) {
    expect_true(file.exists(f))
    expect_gt(file.size(f), 0)
  }
})

test_that("Multiple plots to mixed file types works", {
  x_list <- list(mock_gridify(), mock_gridify())

  out_files <- c(
    file.path(tempdir(), "multi1.png"),
    file.path(tempdir(), "multi2.jpeg")
  )

  expect_no_error(export_to(x_list, out_files))
  for (f in out_files) {
    expect_true(file.exists(f))
    expect_gt(file.size(f), 0)
  }
})

test_that("Multiple plots in a single multi-page PDF works", {
  x_list <- list(mock_gridify(), mock_gridify(), mock_gridify())
  out_file <- file.path(tempdir(), "multiple_plots.pdf")

  expect_no_error(export_to(x_list, out_file))
  expect_true(file.exists(out_file))
  expect_gt(file.size(out_file), 0)
})


test_that("Not supported document type", {
  x <- mock_gridify()
  out_file <- file.path(tempdir(), "test_single.html")

  expect_error(
    export_to(x, out_file),
    paste0(
      "Accepted extensions are png, jpg, jpeg, pdf, tiff, tif\\. ",
      "For other extensions, please consider using Rmd or Qmd documents\\."
    )
  )
})


test_that("Wrong length of objects vs files", {
  x <- mock_gridify()

  expect_error(
    export_to(x, c("test.png", "test.png")),
    "`to` must be a single string \\(file path\\) for single gridify object."
  )

  expect_error(
    export_to(list(x, x), "test.png"),
    "For a list of gridify objects and a single file path, the `to` extension has to be pdf\\."
  )
})

test_that("Filepath does not exist", {
  x <- mock_gridify()
  x_list <- list(x, x)
  temp_dir <- tempdir()

  expect_no_error(export_to(x, file.path(temp_dir, "image.png")))
  expect_no_error(export_to(x_list, file.path(temp_dir, c("image1.png", "image2.png"))))

  expect_error(
    export_to(x, file.path("WRONGDIR", "image.png")),
    "The directory `WRONGDIR` specified by `to` does not exist\\."
  )

  expect_error(
    export_to(x_list, c(file.path(temp_dir, "image1.png"), file.path("WRONGPATH", "image2.png"))),
    "The directory `WRONGPATH` specified by `to` does not exist\\."
  )

  expect_error(
    export_to(x_list, c("WRONGPATH/WRONGPATH", "WRONGPATH/WRONGPATH")),
    "The directory `WRONGPATH` specified by `to` does not exist\\."
  )

  expect_error(
    export_to(x_list, c("WRONGPATH", "WRONGPATH")),
    "Accepted extensions are png, jpg, jpeg, pdf, tiff, tif\\. Please consider using Rmd or Qmd documents\\."
  )

  expect_error(
    export_to(x_list, file.path("WRONGPATH", c("image1.png", "image2.png"))),
    "The directory `WRONGPATH` specified by `to` does not exist\\."
  )

  expect_error(
    export_to(x_list, c(file.path("WRONGPATH", "image1.png"), file.path(temp_dir, "image2.png"))),
    "The directory `WRONGPATH` specified by `to` does not exist\\."
  )

  expect_error(
    export_to(x_list, c(file.path("WRONGPATH", "image1.png"), file.path("WRONGPATH", "image2.png"))),
    "The directory `WRONGPATH` specified by `to` does not exist\\."
  )

  expect_error(
    export_to(x_list, c(file.path("WRONGPATH1", "image1.png"), file.path("WRONGPATH2", "image2.png"))),
    "The directory `WRONGPATH1, WRONGPATH2` specified by `to` does not exist\\."
  )
})

test_that("'gridifyClass' check with different input classes", {
  expect_error(
    export_to(mtcars, to = "test_output.pdf"),
    "All elements of the list must be 'gridifyClass' objects."
  )

  expect_error(
    export_to("invalid_input", to = "output.pdf"),
    "export_to is supported for gridifyClass or list of gridifyClass objects."
  )

  expect_error(
    export_to(42, to = "output.pdf"),
    "export_to is supported for gridifyClass or list of gridifyClass objects."
  )

  expect_error(
    export_to(TRUE, to = "output.pdf"),
    "export_to is supported for gridifyClass or list of gridifyClass objects."
  )
})

test_that("length(to) == length(x) check", {
  x <- mock_gridify()

  expect_error(
    export_to(c(x, x), to = c("output1.png", "single_output2.png", "single_output3.png")),
    "`to` must be either a single pdf file path or a character vector matching the length of `x`."
  )
})

mock_gridify_with_cells <- function() {
  grb <- grid::rectGrob()
  obj <- gridify(grb, pharma_layout_base())
  obj <- set_cell(obj, "header_left_1", "My Company")
  obj <- set_cell(obj, "title_1", "<Title 1>")
  obj <- set_cell(obj, "watermark", "DRAFT \"x\" \\ y\nz")
  obj
}

test_that("default metadata writes no sidecar (option unset)", {
  old <- options(gridify.export.metadata = NULL)
  on.exit(options(old), add = TRUE)
  x <- mock_gridify_with_cells()
  out_file <- file.path(tempdir(), "meta_default.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x, out_file))
  expect_true(file.exists(out_file))
  expect_false(file.exists(side))
})

test_that("metadata = 'sidecar' writes JSON sidecar for PDF and PNG", {
  skip_if_not_installed("jsonlite")
  x <- mock_gridify_with_cells()

  for (ext in c("pdf", "png")) {
    out_file <- file.path(tempdir(), paste0("meta_single.", ext))
    side <- paste0(out_file, ".json")
    if (file.exists(side)) file.remove(side)

    expect_no_error(export_to(x, out_file, metadata = "sidecar"))
    expect_true(file.exists(out_file))
    expect_true(file.exists(side))

    parsed <- jsonlite::fromJSON(side, simplifyVector = FALSE)
    expect_identical(parsed$schema, "gridify.sidecar.metadata")
    expect_identical(parsed$schema_version, "1.0.0")
    expect_length(parsed$pages, 1)
    expect_identical(parsed$pages[[1]]$cells$header_left_1, "My Company")
    expect_identical(parsed$pages[[1]]$cells$title_1, "<Title 1>")
    expect_identical(parsed$pages[[1]]$cells$watermark, "DRAFT \"x\" \\ y\nz")
  }
})

test_that("gridify.export.metadata option provides the default", {
  old <- options(gridify.export.metadata = "sidecar")
  on.exit(options(old), add = TRUE)
  x <- mock_gridify_with_cells()
  out_file <- file.path(tempdir(), "meta_option.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x, out_file))
  expect_true(file.exists(side))

  # Explicit argument still beats the option
  if (file.exists(side)) file.remove(side)
  expect_no_error(export_to(x, out_file, metadata = "none"))
  expect_false(file.exists(side))
})

test_that("gridify.export.metadata option accepts abbreviations", {
  old <- options(gridify.export.metadata = "s")
  on.exit(options(old), add = TRUE)
  x <- mock_gridify_with_cells()
  out_file <- file.path(tempdir(), "meta_option_abbr.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x, out_file))
  expect_true(file.exists(side))
})

test_that("gridify.export.metadata invalid option value is rejected", {
  old <- options(gridify.export.metadata = "yes")
  on.exit(options(old), add = TRUE)
  x <- mock_gridify_with_cells()
  expect_error(
    export_to(x, file.path(tempdir(), "bad.pdf")),
    "should be one of"
  )
})

test_that("metadata = 'none' writes no sidecar", {
  x <- mock_gridify_with_cells()
  out_file <- file.path(tempdir(), "meta_off.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x, out_file, metadata = "none"))
  expect_true(file.exists(out_file))
  expect_false(file.exists(side))
})

test_that("metadata sidecar includes layout default text", {
  skip_if_not_installed("jsonlite")
  x <- gridify(grid::rectGrob(), pharma_layout_base())
  out_file <- file.path(tempdir(), "meta_defaults.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x, out_file, metadata = "sidecar"))
  expect_true(file.exists(out_file))
  expect_true(file.exists(side))

  parsed <- jsonlite::fromJSON(side, simplifyVector = FALSE)
  expect_identical(parsed$pages[[1]]$cells, list(header_right_1 = "CONFIDENTIAL"))
})

test_that("metadata = 'none' removes stale sidecar", {
  x <- mock_gridify_with_cells()
  out_file <- file.path(tempdir(), "meta_stale_removed.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x, out_file, metadata = "sidecar"))
  expect_true(file.exists(side))

  expect_no_error(export_to(x, out_file, metadata = "none"))
  expect_true(file.exists(out_file))
  expect_false(file.exists(side))
})

test_that("metadata writes no sidecar when no cells are set", {
  x <- mock_gridify()
  out_file <- file.path(tempdir(), "meta_empty.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x, out_file, metadata = "sidecar"))
  expect_true(file.exists(out_file))
  expect_false(file.exists(side))
})

test_that("empty metadata removes stale sidecar", {
  out_file <- file.path(tempdir(), "meta_empty_removes_stale.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(mock_gridify_with_cells(), out_file, metadata = "sidecar"))
  expect_true(file.exists(side))

  expect_no_error(export_to(mock_gridify(), out_file, metadata = "sidecar"))
  expect_true(file.exists(out_file))
  expect_false(file.exists(side))
})

test_that("metadata sidecar for multi-page PDF uses pages schema", {
  skip_if_not_installed("jsonlite")
  x_list <- list(mock_gridify_with_cells(), mock_gridify_with_cells())
  out_file <- file.path(tempdir(), "meta_multi.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x_list, out_file, metadata = "sidecar"))
  expect_true(file.exists(side))

  parsed <- jsonlite::fromJSON(side, simplifyVector = FALSE)
  expect_identical(parsed$schema, "gridify.sidecar.metadata")
  expect_identical(parsed$schema_version, "1.0.0")
  expect_length(parsed$pages, 2)
  expect_identical(parsed$pages[[1]]$cells$header_left_1, "My Company")
  expect_identical(parsed$pages[[2]]$cells$header_left_1, "My Company")
})

test_that("metadata can be abbreviated via match.arg", {
  x <- mock_gridify_with_cells()
  out_file <- file.path(tempdir(), "meta_abbr.pdf")
  side <- paste0(out_file, ".json")
  if (file.exists(side)) file.remove(side)

  expect_no_error(export_to(x, out_file, metadata = "s"))
  expect_true(file.exists(side))
})

test_that("metadata invalid values are rejected", {
  x <- mock_gridify()
  expect_error(
    export_to(x, file.path(tempdir(), "bad.pdf"), metadata = "yes"),
    "should be one of"
  )
  expect_error(
    export_to(
      list(x, x),
      file.path(tempdir(), "bad.pdf"),
      metadata = 1
    )
  )
})
