cell1 <- gridifyCell(row = 1, col = 1, x = 0.5, y = 0.5, hjust = 0.5, vjust = 0.5, rot = 0, gpar = grid::gpar())
cell2 <- gridifyCell(row = 2, col = 2, x = 0.5, y = 0.5, hjust = 0.5, vjust = 0.5, rot = 0, gpar = grid::gpar())

test_that("gridifyCells can be created with a proper input", {
  cells <- expect_silent(gridifyCells(title = cell1, footer = cell2))
  expect_s4_class(cells, "gridifyCells")
  expect_length(cells@cells, 2)
  expect_identical(names(cells@cells), c("title", "footer"))

  expect_silent(
    new("gridifyCells",
      cells = list(a = gridifyCell(1, 1))
    )
  )
})

test_that("gridifyCells has one cell of proper type: cells", {
  class_spec <- getSlots("gridifyCells")

  expect_identical(class_spec, c(cells = "list"))
})


test_that("gridifyCells setValidity tests", {
  expect_error(
    new("gridifyCells",
      cells = list()
    ),
    "gridifyCells can not be empty"
  )

  expect_error(
    gridifyCells(),
    "gridifyCells can not be empty"
  )

  expect_error(
    new("gridifyCells",
      cells = list(1)
    ),
    "All elements in gridifyCells have to be named"
  )

  expect_error(
    gridifyCells(cell1, cell2),
    "All elements in gridifyCells have to be named"
  )

  expect_error(
    new("gridifyCells",
      cells = list(a = gridifyCell(1, 1), a = gridifyCell(2, 2))
    ),
    "All elements in gridifyCells must have unique names."
  )

  expect_error(
    gridifyCells(a = cell1, a = cell2),
    "All elements in gridifyCells must have unique names."
  )
})
