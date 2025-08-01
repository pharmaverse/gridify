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
