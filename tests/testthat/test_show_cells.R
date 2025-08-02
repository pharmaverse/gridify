mock_gridify <- function() {
  grb <- grid::rectGrob()
  gridify(grb, simple_layout())
}

test_that("show_cells function works with layout or gridify object", {
  expect_true(is.function(show_cells))
  expect_output(show_cells(mock_gridify()), "title")
  expect_output(show_cells(simple_layout()), "title")
})
