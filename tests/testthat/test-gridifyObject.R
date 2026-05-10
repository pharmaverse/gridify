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

test_that("gridifyObject has the expected slots and types", {
  class_spec <- getSlots("gridifyObject")

  expect_identical(
    class_spec,
    c(
      row = "numeric",
      col = "numeric",
      height = "numeric",
      width = "numeric",
      vjust = "numeric"
    )
  )
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

test_that("gridifyObject vjust validity and default", {
  expect_identical(gridifyObject(row = 1, col = 1)@vjust, 0.5)

  expect_silent(gridifyObject(row = 1, col = 1, vjust = 0))
  expect_silent(gridifyObject(row = 1, col = 1, vjust = 1))

  expect_error(
    gridifyObject(row = 1, col = 1, vjust = -0.1),
    "vjust has to be a single numeric value in \\[0, 1\\]"
  )
  expect_error(
    gridifyObject(row = 1, col = 1, vjust = 1.5),
    "vjust has to be a single numeric value in \\[0, 1\\]"
  )
  expect_error(
    gridifyObject(row = 1, col = 1, vjust = c(0, 1)),
    "vjust has to be a single numeric value in \\[0, 1\\]"
  )
})
