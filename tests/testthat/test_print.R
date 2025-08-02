test_that("print on gridifyClass returns invisibly grob object", {
  expect_silent(
    test_gridify <- gridify(
      object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
        ggplot2::geom_point(),
      layout = simple_layout()
    )
  )
  expect_s4_class(test_gridify, "gridifyClass")
  expect_invisible(print(test_gridify))
  expect_type(print(test_gridify), "language")
})

test_that("print on gridifyClass returns invisibly grob object", {
  expect_silent(
    test_gridify <- gridify(
      object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
        ggplot2::geom_point(),
      layout = gridifyLayout(
        nrow = 3L,
        ncol = 1L,
        heights = grid::unit(c(0, 10, 0), c("lines", "lines", "lines")),
        widths = grid::unit(1, "npc"),
        margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
        global_gpar = grid::gpar(),
        object = gridifyObject(row = 2, col = 1),
        cells = gridifyCells(
          title = gridifyCell(
            row = 1, col = 1, text = "Longer Default Title", mch = 10,
            gpar = grid::gpar(col = "black", fontsize = 12)
          ),
          footer = gridifyCell(row = 3, col = 1)
        ),
        adjust_height = TRUE
      )
    )
  )
  expect_silent(
    test_gridify <- set_cell(test_gridify, "footer", "Footer", gpar = grid::gpar(col = "black"))
  )
  expect_s4_class(test_gridify, "gridifyClass")
  expect_invisible(print(test_gridify))
  expect_type(print(test_gridify), "language")
})

test_that("print on gridifyClass creates image", {
  skip_if(!getOption("RUNSNAPSHOTTESTS", FALSE))
  expect_silent(
    test_gridify <- gridify(
      object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
        ggplot2::geom_point(),
      layout = simple_layout()
    )
  )
  expect_silent(
    test_gridify <- set_cell(test_gridify, "footer", "My Footer")
  )
  expect_s4_class(test_gridify, "gridifyClass")

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  print(test_gridify)
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "print_gridify.png"
  )
})

test_that("print on gridifyClass with adjustment prevent overlap of text", {
  skip_if(!getOption("RUNSNAPSHOTTESTS", FALSE))
  # with adjustment
  expect_silent(
    test_gridify_adjustment <- gridify(
      object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
        ggplot2::geom_point(),
      layout = complex_layout(),
      elements = list(
        title = list(text = "My Title", gpar = grid::gpar(fontsize = 50)),
        subtitle = list(text = "My Subtitle", gpar = grid::gpar(fontsize = 40))
      )
    )
  )
  # lack of adjustment
  expect_silent(
    test_gridify <- gridify(
      object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
        ggplot2::geom_point(),
      layout = complex_layout(),
      elements = list(
        title = list(text = "My Title", gpar = grid::gpar(fontsize = 50)),
        subtitle = list(text = "My Subtitle", gpar = grid::gpar(fontsize = 40))
      )
    )
  )

  expect_s4_class(test_gridify_adjustment, "gridifyClass")
  expect_s4_class(test_gridify, "gridifyClass")

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  print(test_gridify)
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "print_gridify_withoutadjusted.png"
  )

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  print(test_gridify_adjustment)
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "print_gridify_withadjusted.png"
  )
})

test_that("gridify function correctly sets output height and width", {
  skip_if(!getOption("RUNSNAPSHOTTESTS", FALSE))

  complex_layout <- function(margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
                             global_gpar = grid::gpar()) {
    gridifyLayout(
      nrow = 6L,
      ncol = 3L,
      heights = grid::unit(c(0.05, 0.05, 0.05, 0.7, 0.05, 0.1), "npc"),
      widths = grid::unit(rep(1, 3) / 3, units = "npc"),
      global_gpar = global_gpar,
      margin = margin,
      adjust_height = FALSE,
      object = gridifyObject(row = 4, col = c(1, 3)),
      cells = gridifyCells(
        title = gridifyCell(row = 1, col = 1),
        footer = gridifyCell(row = 3, col = 1)
      )
    )
  }

  expect_silent(
    test_gridify_default <- gridify(
      object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
        ggplot2::geom_line(),
      layout = complex_layout()
    )
  )

  complex_layout <- function(margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
                             global_gpar = grid::gpar()) {
    gridifyLayout(
      nrow = 6L,
      ncol = 3L,
      heights = grid::unit(c(0.05, 0.05, 0.05, 0.7, 0.05, 0.1), "npc"),
      widths = grid::unit(rep(1, 3) / 3, units = "npc"),
      global_gpar = global_gpar,
      margin = margin,
      adjust_height = FALSE,
      object = gridifyObject(row = 4, col = c(1, 3), width = 0.5, height = 0.7),
      cells = gridifyCells(
        title = gridifyCell(row = 1, col = 1),
        footer = gridifyCell(row = 3, col = 1)
      )
    )
  }

  expect_silent(
    test_gridify_adjust <- gridify(
      object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
        ggplot2::geom_line(),
      layout = complex_layout()
    )
  )

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  print(test_gridify_default)
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "print_gridify_defaulthw.png"
  )

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  print(test_gridify_adjust)
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "print_gridify_adjustedhhw.png"
  )
})
