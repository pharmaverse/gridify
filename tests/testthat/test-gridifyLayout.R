test_that("gridifyLayout can be created with a proper input", {
  expect_silent(
    instance <- new(
      "gridifyLayout",
      nrow = 1,
      ncol = 1,
      heights = grid::unit(1, "npc"),
      widths = grid::unit(1, "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "npc"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(1, 1),
      cells = gridifyCells(sth = gridifyCell(1, 1))
    )
  )
})

test_that(
  paste0(
    "gridifyClass has nine cells of proper types: ",
    "nrow, ncol, heights, widths, margin, global_gpar, adjust_height, object and cells"
  ),
  {
    class_spec <- getSlots("gridifyLayout")

    expect_identical(
      class_spec,
      c(
        nrow = "numeric",
        ncol = "numeric",
        heights = "unitOrSimpleUnit",
        widths = "unitOrSimpleUnit",
        margin = "unitOrSimpleUnit",
        global_gpar = "gpar",
        background = "character",
        adjust_height = "logical",
        object = "gridifyObject",
        cells = "gridifyCells"
      )
    )
  }
)


test_that("unitOrSimpleUnit is unit or simpleUnit", {
  expect_true(methods::is(grid::unit(1, "npc"), "unitOrSimpleUnit"))
  expect_true(methods::is(
    grid::unit(c(1, 2), c("npc", "cm")),
    "unitOrSimpleUnit"
  ))
})

test_that("gridifyLayout setValidity tests", {
  expect_error(
    new(
      "gridifyLayout",
      nrow = 1,
      ncol = 1,
      heights = grid::unit(1, "npc"),
      widths = grid::unit(1, "npc"),
      margin = grid::unit(c(1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(1, 1),
      cells = gridifyCells(sth = gridifyCell(1, 1))
    ),
    "The 'margin' argument must be a vector of length 4"
  )

  expect_error(
    new(
      "gridifyLayout",
      nrow = 2,
      ncol = 1,
      heights = grid::unit(1, "npc"),
      widths = grid::unit(1, "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(1, 1),
      cells = gridifyCells(sth = gridifyCell(1, 1))
    ),
    "heights has to have the same length as number of rows \\(nrow\\) in gridifyLayout"
  )

  expect_error(
    new(
      "gridifyLayout",
      nrow = 1,
      ncol = 2,
      heights = grid::unit(1, "npc"),
      widths = grid::unit(1, "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(1, 1),
      cells = gridifyCells(sth = gridifyCell(1, 1))
    ),
    "widths has to have the same length as number of cols \\(ncol\\) in gridifyLayout"
  )

  expect_error(
    new(
      "gridifyLayout",
      nrow = 2,
      ncol = 2,
      heights = grid::unit(c(1, 1), "npc"),
      widths = grid::unit(c(1, 1), "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(1, 1),
      cells = gridifyCells(
        a = gridifyCell(row = 1, col = 3),
        b = gridifyCell(row = 2, col = 2)
      )
    ),
    "All cells cols have to be less or equal to ncol"
  )

  expect_error(
    new(
      "gridifyLayout",
      nrow = 2,
      ncol = 2,
      heights = grid::unit(c(1, 1), "npc"),
      widths = grid::unit(c(1, 1), "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(10, 1),
      cells = gridifyCells(
        a = gridifyCell(row = 1, col = 2),
        b = gridifyCell(row = 2, col = 2)
      )
    ),
    "row value has to be less or equal to nrow: 2"
  )

  expect_error(
    new(
      "gridifyLayout",
      nrow = 2,
      ncol = 2,
      heights = grid::unit(c(1, 1), "npc"),
      widths = grid::unit(c(1, 1), "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(1, 10),
      cells = gridifyCells(
        a = gridifyCell(row = 1, col = 2),
        b = gridifyCell(row = 2, col = 2)
      )
    ),
    "col value has to be less or equal to ncol: 2"
  )

  expect_warning(
    new(
      "gridifyLayout",
      nrow = 3,
      ncol = 3,
      heights = grid::unit(c(1, 1, 1), "npc"),
      widths = grid::unit(c(1, 1, 1), "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(2, 2),
      cells = gridifyCells(
        a = gridifyCell(row = 1:2, col = 2),
        b = gridifyCell(row = 2, col = 2)
      )
    ),
    "Overlapping cells detected at positions: 2-2"
  )

  expect_warning(
    new(
      "gridifyLayout",
      nrow = 3,
      ncol = 3,
      heights = grid::unit(c(1, 1, 1), "npc"),
      widths = grid::unit(c(1, 1, 1), "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(2, 2),
      cells = gridifyCells(
        a = gridifyCell(row = 1:3, col = 3),
        b = gridifyCell(row = 3, col = 3)
      )
    ),
    "Overlapping cells detected at positions: 3-3"
  )

  expect_warning(
    new(
      "gridifyLayout",
      nrow = 3,
      ncol = 3,
      heights = grid::unit(c(1, 1, 1), "npc"),
      widths = grid::unit(c(1, 1, 1), "npc"),
      margin = grid::unit(c(1, 1, 1, 1), "cm"),
      global_gpar = grid::gpar(),
      background = grid::get.gpar()$fill,
      adjust_height = FALSE,
      object = gridifyObject(2, 2),
      cells = gridifyCells(
        a = gridifyCell(row = 1:2, col = 3),
        b = gridifyCell(row = 3, col = 3)
      )
    ),
    NA
  )
})
