test_gridify <- gridify(
  object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point(),
  layout = simple_layout()
)

test_that("set_cell works on gridify object", {
  expect_s4_class(test_gridify, "gridifyClass")

  # add one text element
  output <- set_cell(test_gridify, "title", "TITLE")

  expect_s4_class(output, "gridifyClass")
  expect_equal(slotNames(output), c("object", "layout", "elements"))

  expect_equal(output@elements, list(title = list(
    text = "TITLE", mch = NULL, x = NULL, y = NULL, hjust = NULL,
    vjust = NULL, rot = NULL, gpar = NULL
  )))

  # add second text element
  output <- set_cell(output, "footer", "FOOTER")

  expect_s4_class(output, "gridifyClass")
  expect_equal(slotNames(output), c("object", "layout", "elements"))

  expect_equal(output@elements, list(
    title = list(
      text = "TITLE", mch = NULL, x = NULL, y = NULL, hjust = NULL,
      vjust = NULL, rot = NULL, gpar = NULL
    ),
    footer = list(
      text = "FOOTER", mch = NULL, x = NULL, y = NULL, hjust = NULL,
      vjust = NULL, rot = NULL, gpar = NULL
    )
  ))
  # overwrite a previous text element
  output <- set_cell(output, "title", "This is a new title")

  expect_s4_class(output, "gridifyClass")
  expect_equal(slotNames(output), c("object", "layout", "elements"))

  expect_equal(output@elements, list(
    title = list(
      text = "This is a new title", mch = NULL, x = NULL, y = NULL, hjust = NULL,
      vjust = NULL, rot = NULL, gpar = NULL
    ),
    footer = list(
      text = "FOOTER", mch = NULL, x = NULL, y = NULL, hjust = NULL,
      vjust = NULL, rot = NULL, gpar = NULL
    )
  ))
})

test_that("set_cell works with multiple arguments filled", {
  expect_s4_class(test_gridify, "gridifyClass")

  output <- set_cell(test_gridify, "title", "TITLE", mch = 120, x = 0.7, hjust = 1, rot = 45)
  output <- set_cell(
    output, "footer", "FOOTER",
    mch = NULL, y = 0.2, hjust = 0, gpar = grid::gpar(fontsize = 22, col = "red")
  )

  expect_equal(output@elements, list(
    title = list(
      text = "TITLE",
      mch = 120,
      x = 0.7,
      y = NULL,
      hjust = 1,
      vjust = NULL,
      rot = 45,
      gpar = NULL
    ),
    footer = list(
      text = "FOOTER",
      mch = NULL,
      x = NULL,
      y = 0.2,
      hjust = 0,
      vjust = NULL,
      rot = NULL,
      gpar = grid::gpar(fontsize = 22, col = "red")
    )
  ))
})


test_that("set_cell errors on non gridifyClass object", {
  expect_error(
    set_cell(ggplot2::ggplot(), "title", "TITLE"),
    "The first argument in `set_cell` should be a gridifyClass object."
  )
  expect_error(
    set_cell("title", "TITLE"),
    "The first argument in `set_cell` should be a gridifyClass object."
  )
})

test_that("set_cell errors when gridifyClass object provided after pipe", {
  expect_error(
    set_cell(test_gridify, test_gridify, "title", "title"),
    "The cell argument is not a character string"
  )
})

test_that("set_cell errors when defaults not provided", {
  expect_error(set_cell(test_gridify), "argument .*cell.* is missing, with no default")
  expect_error(set_cell(test_gridify, "title"), "argument .*text.* is missing, with no default")
})

test_that("set_cell errors when cell name is wrong", {
  expect_error(set_cell(test_gridify, "test", "TITLE"),
    "Cell value used is not valid, here is a list of valid cells: ",
    fixed = TRUE
  )
})


test_that("set_cell errors when cell text is wrong", {
  expect_error(set_cell(test_gridify, "title", 1),
    "The text argument is not a character string",
    fixed = TRUE
  )

  expect_error(set_cell(test_gridify, "title", c("a", "b")),
    "The text argument is not a character string, please use '\\n' to concatenate values",
    fixed = TRUE
  )
})

test_that("set_cell errors when cell x is wrong", {
  expect_error(set_cell(test_gridify, "title", "something", x = "a"),
    "The x argument is not a numeric value",
    fixed = TRUE
  )
})

test_that("set_cell errors when cell y is wrong", {
  expect_error(set_cell(test_gridify, "title", "something", y = "a"),
    "The y argument is not a numeric value",
    fixed = TRUE
  )
})

test_that("set_cell errors when cell hjust is wrong", {
  expect_error(set_cell(test_gridify, "title", "something", hjust = "a"),
    "The hjust argument is not a numeric value",
    fixed = TRUE
  )
})

test_that("set_cell errors when cell vjust is wrong", {
  expect_error(set_cell(test_gridify, "title", "something", vjust = "a"),
    "The vjust argument is not a numeric value",
    fixed = TRUE
  )
})

test_that("set_cell errors when cell rot is wrong", {
  expect_error(set_cell(test_gridify, "title", "something", rot = "a"),
    "The rot argument is not a numeric value",
    fixed = TRUE
  )
})

test_that("set_cell errors when cell gpar is wrong", {
  expect_error(set_cell(test_gridify, "title", "something", gpar = "a"),
    "The gpar argument is not a gpar instance",
    fixed = TRUE
  )
})

test_that("set_cell errors when cell mch is wrong", {
  expect_error(
    set_cell(
      test_gridify,
      "title",
      "something",
      mch = "a"
    ),
    "The mch argument is not a positive numeric value",
    fixed = TRUE
  )
})

test_that("Image testing for set_cell", {
  skip_if(!getOption("RUNSNAPSHOTTESTS", FALSE))

  # test with no cells added
  g <- gridify(
    object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
      ggplot2::geom_point(),
    layout = simple_layout()
  )

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  print(g)
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "figure_no_cells.png"
  )

  # test with cells added
  output <- set_cell(g, "title", "TITLE", x = 0.7, hjust = 1, rot = 45)
  output <- set_cell(output, "footer", "FOOTER", y = 0.2, hjust = 0, gpar = grid::gpar(fontsize = 22, col = "red"))

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  print(output)
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "figure_with_cells.png"
  )

  # test with `mch` argument
  long_footer_string <- paste0(
    "This is a footer. We can have a long description here.",
    "We can have another long description here.",
    "We can have another long description here."
  )

  output <- set_cell(g, "footer", long_footer_string, mch = 30)

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png, width = 800, height = 400, res = 96)
  print(output)
  grDevices::dev.off()

  testthat::expect_snapshot_file(
    temp_png,
    "figure_with_mch.png"
  )
})

test_that("set_cell errors when cell mch is wrong", {
  expect_error(
    set_cell(test_gridify, "title", "something", mch = "a"),
    "not a positive numeric"
  )

  expect_error(
    set_cell(test_gridify, "title", "something", mch = -1),
    "not a positive numeric"
  )
})
