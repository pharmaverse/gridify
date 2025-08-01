test_that("gridifyCell can be created with a proper input", {
  expect_silent(
    new("gridifyCell",
      row = 1,
      col = 1,
      text = "",
      mch = Inf,
      x = 1,
      y = 1,
      hjust = 0,
      vjust = 0,
      rot = 0,
      gpar = grid::gpar()
    )
  )
})

test_that("gridifyCell has ten cells of proper types: row, col, text, mch, x, y, vjust, hjust, rot, gpar", {
  class_spec <- getSlots("gridifyCell")

  expect_identical(class_spec, c(
    row = "numeric", col = "numeric", text = "character", mch = "numeric", x = "numeric",
    y = "numeric", hjust = "numeric", vjust = "numeric", rot = "numeric",
    gpar = "gpar"
  ))
})

test_that("gridifyCell setValidity tests", {
  expect_error(
    new("gridifyCell",
      row = -1,
      col = 1,
      text = "",
      mch = Inf,
      x = 1,
      y = 1,
      hjust = 0,
      vjust = 0,
      gpar = grid::gpar()
    ),
    "cell row has to be positive integer"
  )

  expect_error(
    new(
      "gridifyCell",
      row = 1.4,
      col = 1,
      text = "",
      mch = Inf,
      x = 1,
      y = 1,
      hjust = 0,
      vjust = 0,
      gpar = grid::gpar()
    ),
    "cell row has to be positive integer"
  )

  expect_error(
    new("gridifyCell",
      row = 1,
      col = -1,
      text = "",
      mch = Inf,
      x = 1,
      y = 1,
      hjust = 0,
      vjust = 0,
      gpar = grid::gpar()
    ),
    "cell col has to be positive integer"
  )

  expect_error(
    new(
      "gridifyCell",
      row = 1,
      col = 0,
      text = "",
      mch = Inf,
      x = 1,
      y = 1,
      hjust = 0,
      vjust = 0,
      gpar = grid::gpar()
    ),
    "cell col has to be positive integer"
  )

  expect_error(
    new("gridifyCell",
      row = 1,
      col = 1,
      text = c("a", "b"),
      mch = Inf,
      x = 1,
      y = 1,
      hjust = 0,
      vjust = 0,
      gpar = grid::gpar()
    ),
    "cell text has to be a string"
  )
})
