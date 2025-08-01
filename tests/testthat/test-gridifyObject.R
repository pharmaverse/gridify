test_that("gridifyObject can be created with a proper input", {
  expect_silent(
    new("gridifyObject",
      row = 1,
      col = 1,
      height = 1,
      width = 1
    )
  )
})

test_that("gridifyObject has four cells of proper types: row, col, height and width", {
  class_spec <- getSlots("gridifyObject")

  expect_identical(class_spec, c(row = "numeric", col = "numeric", height = "numeric", width = "numeric"))
})


test_that("gridifyObject setValidity tests", {
  expect_error(
    new("gridifyObject",
      row = -1,
      col = 1,
      height = 1,
      width = 1
    ),
    "cell row has to be positive integer"
  )


  expect_error(
    new("gridifyObject",
      row = 5.6,
      col = 1,
      height = 1,
      width = 1
    ),
    "cell row has to be positive integer"
  )


  expect_error(
    new("gridifyObject",
      row = 1,
      col = -1,
      height = 1,
      width = 1
    ),
    "cell col has to be positive integer"
  )

  expect_error(
    new("gridifyObject",
      row = 1,
      col = 0,
      height = 1,
      width = 1
    ),
    "cell col has to be positive integer"
  )
})
