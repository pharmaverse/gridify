test_that("show on gridifyClass returns information to the console", {
  test_gridify <- gridify(
    object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
      ggplot2::geom_point(),
    layout = simple_layout(
      background = "white"
    )
  )
  expect_s4_class(test_gridify, "gridifyClass")

  expect_output(show(test_gridify))

  output <- capture_output_lines(show(test_gridify))

  if (interactive()) {
    expect_equal(
      output,
      c(
        "gridifyClass object",
        "---------------------",
        "Please run `show_spec(object)` or print the layout to get more specs.",
        "",
        "Cells:",
        "  title: \033[31mempty\033[0m",
        "  footer: \033[31mempty\033[0m"
      )
    )
  } else {
    expect_equal(
      output,
      c(
        "gridifyClass object",
        "---------------------",
        "Please run `show_spec(object)` or print the layout to get more specs.",
        "",
        "Cells:",
        "  title: empty",
        "  footer: empty"
      )
    )
  }

  # test show_spec(object)
  expect_output(show_spec(test_gridify))
  output <- capture_output_lines(show_spec(test_gridify))

  expect_equal(
    output,
    c(
      "Layout dimensions:",
      "  Number of rows: 3",
      "  Number of columns: 1",
      "",
      "Heights of rows:",
      "  Row 1: 0 lines",
      "  Row 2: 1 null",
      "  Row 3: 0 lines",
      "",
      "Widths of columns:",
      "  Column 1: 1 npc",
      "",
      "Object Position:",
      "  Row: 2",
      "  Col: 1",
      "  Width: 1",
      "  Height: 1",
      "",
      "Object Row Heights:",
      "  Row 2: 1 null",
      "",
      "Margin:",
      "  Top: 0.1 npc",
      "  Right: 0.1 npc",
      "  Bottom: 0.1 npc",
      "  Left: 0.1 npc",
      "",
      "Global graphical parameters:",
      "  Are not set",
      "",
      "Background colour:",
      "  white",
      "",
      "Default Cell Info:",
      "  title:",
      "    row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  footer:",
      "    row:3, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, "
    )
  )
})

test_that("show on more complex gridifyClass returns information to the console", {
  test_gridify <- gridify(
    object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
      ggplot2::geom_point(),
    layout = simple_layout(
      margin = grid::unit(c(t = 1, r = 2, b = 3, l = 4), units = "mm"),
      global_gpar = grid::gpar(col = "red"),
      background = "blue"
    )
  )
  test_gridify <- set_cell(test_gridify, "title", "TITLE")
  test_gridify <- set_cell(test_gridify, "footer", "FOOTER")
  expect_s4_class(test_gridify, "gridifyClass")

  expect_output(show(test_gridify))

  output <- capture_output_lines(show(test_gridify))

  if (interactive()) {
    expect_equal(
      output,
      c(
        "gridifyClass object",
        "---------------------",
        "Please run `show_spec(object)` or print the layout to get more specs.",
        "",
        "Cells:",
        "  title: \033[32mfilled\033[0m",
        "  footer: \033[32mfilled\033[0m"
      )
    )
  } else {
    expect_equal(
      output,
      c(
        "gridifyClass object",
        "---------------------",
        "Please run `show_spec(object)` or print the layout to get more specs.",
        "",
        "Cells:",
        "  title: filled",
        "  footer: filled"
      )
    )
  }
  # test show_spec(object)
  expect_output(show_spec(test_gridify))
  output <- capture_output_lines(show_spec(test_gridify))
  expect_equal(
    output,
    c(
      "Layout dimensions:",
      "  Number of rows: 3",
      "  Number of columns: 1",
      "",
      "Heights of rows:",
      "  Row 1: 0 lines",
      "  Row 2: 1 null",
      "  Row 3: 0 lines",
      "",
      "Widths of columns:",
      "  Column 1: 1 npc",
      "",
      "Object Position:",
      "  Row: 2",
      "  Col: 1",
      "  Width: 1",
      "  Height: 1",
      "",
      "Object Row Heights:",
      "  Row 2: 1 null",
      "",
      "Margin:",
      "  Top: 1 mm",
      "  Right: 2 mm",
      "  Bottom: 3 mm",
      "  Left: 4 mm",
      "",
      "Global graphical parameters:",
      "  col: red ",
      "",
      "Background colour:",
      "  blue",
      "",
      "Default Cell Info:",
      "  title:",
      "    row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  footer:",
      "    row:3, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, "
    )
  )
})

test_that("show on gridifyClass creates image", {
  skip_if(!getOption("RUNSNAPSHOTTESTS", FALSE))
  test_gridify <- gridify(
    object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
      ggplot2::geom_point(),
    layout = simple_layout(
      margin = grid::unit(c(t = 1, r = 2, b = 3, l = 4), units = "mm"),
      global_gpar = grid::gpar(col = "red")
    )
  )
  test_gridify <- set_cell(test_gridify, "title", "TITLE")
  test_gridify <- set_cell(test_gridify, "footer", "FOOTER")
  expect_s4_class(test_gridify, "gridifyClass")

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  capture_output(show(test_gridify))
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "show_gridify.png"
  )
})

test_that("show on gridifyLayout returns information to the console", {
  test_layout <- simple_layout(background = "white")
  expect_s4_class(test_layout, "gridifyLayout")

  expect_output(show(test_layout))

  output <- capture_output_lines(show(test_layout))

  expect_equal(
    output,
    c(
      "gridifyLayout object",
      "---------------------",
      "Layout dimensions:",
      "  Number of rows: 3",
      "  Number of columns: 1",
      "",
      "Heights of rows:",
      "  Row 1: 0 lines",
      "  Row 2: 1 null",
      "  Row 3: 0 lines",
      "",
      "Widths of columns:",
      "  Column 1: 1 npc",
      "",
      "Object Position:",
      "  Row: 2",
      "  Col: 1",
      "  Width: 1",
      "  Height: 1",
      "",
      "Object Row Heights:",
      "  Row 2: 1 null",
      "",
      "Margin:",
      "  Top: 0.1 npc",
      "  Right: 0.1 npc",
      "  Bottom: 0.1 npc",
      "  Left: 0.1 npc",
      "",
      "Global graphical parameters:",
      "  Are not set",
      "",
      "Background colour:",
      "  white",
      "",
      "Default Cell Info:",
      "  title:",
      "    row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  footer:",
      "    row:3, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      ""
    )
  )
})

test_that("show on complex gridifyLayout returns information to the console", {
  test_layout <- complex_layout(
    global_gpar = grid::gpar(fontsize = 22),
    background = "#ABC123"
  )
  expect_s4_class(test_layout, "gridifyLayout")

  expect_output(show(test_layout))

  output <- capture_output_lines(show(test_layout))

  expect_equal(
    output,
    c(
      "gridifyLayout object",
      "---------------------",
      "Layout dimensions:",
      "  Number of rows: 6",
      "  Number of columns: 3",
      "",
      "Heights of rows:",
      "  Row 1: 0 lines",
      "  Row 2: 0 lines",
      "  Row 3: 0 lines",
      "  Row 4: 1 null",
      "  Row 5: 0 lines",
      "  Row 6: 0 lines",
      "",
      "Widths of columns:",
      "  Column 1: 0.333333333333333 npc",
      "  Column 2: 0.333333333333333 npc",
      "  Column 3: 0.333333333333333 npc",
      "",
      "Object Position:",
      "  Row: 4",
      "  Col: 1-3",
      "  Width: 1",
      "  Height: 1",
      "",
      "Object Row Heights:",
      "  Row 4: 1 null",
      "",
      "Margin:",
      "  Top: 0.1 npc",
      "  Right: 0.1 npc",
      "  Bottom: 0.1 npc",
      "  Left: 0.1 npc",
      "",
      "Global graphical parameters:",
      "  fontsize: 22 ",
      "",
      "Background colour:",
      "  #ABC123",
      "",
      "Default Cell Info:",
      "  header_left:",
      "    row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  header_middle:",
      "    row:1, col:2, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  header_right:",
      "    row:1, col:3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  title:",
      "    row:2, col:1-3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  subtitle:",
      "    row:3, col:1-3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  note:",
      "    row:5, col:1-3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  footer_left:",
      "    row:6, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  footer_middle:",
      "    row:6, col:2, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  footer_right:",
      "    row:6, col:3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      ""
    )
  )
})

test_that("test span row for output height row = c(x:y)", {
  test_layout <- gridifyLayout(
    nrow = 6L,
    ncol = 1L,
    heights = grid::unit(c(0.05, 0.05, 0.05, 0.7, 0.05, 0.1), "npc"),
    widths = grid::unit(1, "npc"),
    margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
    global_gpar = grid::gpar(),
    background = "white",
    object = gridifyObject(row = c(1:3), col = 1),
    cells = gridifyCells(
      title = gridifyCell(row = 1, col = 1),
      footer = gridifyCell(row = 3, col = 1)
    )
  )
  expect_s4_class(test_layout, "gridifyLayout")

  expect_output(show(test_layout))

  output <- capture_output_lines(show(test_layout))

  expect_equal(
    output,
    c(
      "gridifyLayout object",
      "---------------------",
      "Layout dimensions:",
      "  Number of rows: 6",
      "  Number of columns: 1",
      "",
      "Heights of rows:",
      "  Row 1: 0.05 npc",
      "  Row 2: 0.05 npc",
      "  Row 3: 0.05 npc",
      "  Row 4: 0.7 npc",
      "  Row 5: 0.05 npc",
      "  Row 6: 0.1 npc",
      "",
      "Widths of columns:",
      "  Column 1: 1 npc",
      "",
      "Object Position:",
      "  Row: 1-3",
      "  Col: 1",
      "  Width: 1",
      "  Height: 1",
      "",
      "Object Row Heights:",
      "  Row 1: 0.05 npc",
      "  Row 2: 0.05 npc",
      "  Row 3: 0.05 npc",
      "",
      "Margin:",
      "  Top: 0.1 npc",
      "  Right: 0.1 npc",
      "  Bottom: 0.1 npc",
      "  Left: 0.1 npc",
      "",
      "Global graphical parameters:",
      "  Are not set",
      "",
      "Background colour:",
      "  white",
      "",
      "Default Cell Info:",
      "  title:",
      "    row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "  footer:",
      "    row:3, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      ""
    )
  )
})

test_that("test span row for output height row = c(x, y)", {
  test_layout <- gridifyLayout(
    nrow = 6L,
    ncol = 1L,
    heights = grid::unit(c(0.05, 0.05, 0.05, 0.7, 0.05, 0.1), "npc"),
    widths = grid::unit(1, "npc"),
    margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
    global_gpar = grid::gpar(),
    background = "white",
    object = gridifyObject(row = c(1, 4), col = 1),
    cells = gridifyCells(
      title = gridifyCell(row = 1, col = 1, text = "Long Title With Text", gpar = grid::gpar(col = "black")),
      footer = gridifyCell(row = 3, col = 1)
    )
  )
  expect_s4_class(test_layout, "gridifyLayout")

  expect_output(show(test_layout))

  output <- capture_output_lines(show(test_layout))

  expect_equal(
    output,
    c(
      "gridifyLayout object",
      "---------------------",
      "Layout dimensions:",
      "  Number of rows: 6",
      "  Number of columns: 1",
      "",
      "Heights of rows:",
      "  Row 1: 0.05 npc",
      "  Row 2: 0.05 npc",
      "  Row 3: 0.05 npc",
      "  Row 4: 0.7 npc",
      "  Row 5: 0.05 npc",
      "  Row 6: 0.1 npc",
      "",
      "Widths of columns:",
      "  Column 1: 1 npc",
      "",
      "Object Position:",
      "  Row: 1-4",
      "  Col: 1",
      "  Width: 1",
      "  Height: 1",
      "",
      "Object Row Heights:",
      "  Row 1: 0.05 npc",
      "  Row 2: 0.05 npc",
      "  Row 3: 0.05 npc",
      "  Row 4: 0.7 npc",
      "",
      "Margin:",
      "  Top: 0.1 npc",
      "  Right: 0.1 npc",
      "  Bottom: 0.1 npc",
      "  Left: 0.1 npc",
      "",
      "Global graphical parameters:",
      "  Are not set",
      "",
      "Background colour:",
      "  white",
      "",
      "Default Cell Info:",
      "  title:",
      "    row:1, col:1, text:Long Title..., mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      "    gpar - col:black, ",
      "  footer:",
      "    row:3, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, ",
      ""
    )
  )
})
