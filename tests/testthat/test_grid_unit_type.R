test_that("grid_unit_type function works correctly", {
  unit_object <- grid::unit(1:5, "cm")
  expect_equal(grid_unit_type(unit_object), rep("cm", 5))

  unit_object <- grid::unit(
    c(1, 0, 1, 0, 1, 0),
    c("cm", "cm", "lines", "lines", "null", "null")
  )
  expect_equal(
    grid_unit_type(unit_object),
    c("cm", "cm", "lines", "lines", "null", "null")
  )

  expect_error(grid_unit_type(1), "Not a unit object")
})

test_that("grid_unit_type when use_grid = FALSE", {
  expect_equal(
    grid_unit_type(structure(1:3, unit = "cm"), use_grid = FALSE),
    c("cm", "cm", "cm")
  )

  expect_error(
    grid_unit_type(structure(1:3), use_grid = FALSE),
    "Not a unit object"
  )
})
