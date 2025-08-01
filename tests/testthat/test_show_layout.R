test_that("show_layout function returns a viewport", {
  expect_true(is.function(show_layout))
  expect_s3_class(show_layout(simple_layout()), "viewport")
})

test_that("show_layout function works with layout or gridify object", {
  expect_s3_class(show_layout(simple_layout()), "viewport")
  expect_s3_class(show_layout(gridify(grid::nullGrob(), layout = simple_layout())), "viewport")
})

test_that("show-layout() works with custom layouts", {
  cell1 <- gridifyCell(row = 1, col = 1, x = 0.5, y = 0.5, hjust = 0.5, vjust = 0.5, rot = 0, gpar = grid::gpar())
  cell2 <- gridifyCell(row = 2, col = 2, x = 0.5, y = 0.5, hjust = 0.5, vjust = 0.5, rot = 0, gpar = grid::gpar())

  cells <- gridifyCells(header = cell1, footer = cell2)

  custom_layout <- gridifyLayout(
    nrow = 3L,
    ncol = 2L,
    heights = grid::unit(c(0.15, 0.7, 0.15), "npc"),
    widths = grid::unit(c(0.5, 0.5), "npc"),
    margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
    global_gpar = grid::gpar(),
    adjust_height = FALSE,
    object = gridifyObject(row = 2, col = 1),
    cells = cells
  )

  expect_s3_class(show_layout(custom_layout), "viewport")
  expect_s3_class(show_layout(gridify(grid::nullGrob(), layout = custom_layout)), "viewport")
})
