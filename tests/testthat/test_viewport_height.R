test_that("is_flexible_grob detects ggplotGrob (gtable with null heights)", {
  skip_if_not_installed("ggplot2")
  gg <- ggplot2::ggplotGrob(
    ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) + ggplot2::geom_point()
  )
  expect_true(is_flexible_grob(gg))
})

test_that("is_flexible_grob honours the gridify.flexible attribute", {
  g <- grid::rectGrob()
  expect_false(is_flexible_grob(g))
  attr(g, "gridify.flexible") <- TRUE
  expect_true(is_flexible_grob(g))
  attr(g, "gridify.flexible") <- FALSE
  expect_false(is_flexible_grob(g))
})

test_that("is_flexible_grob ignores plain childrenvp (regression for false positive)", {
  # Custom gTree carrying a childrenvp for clip/transform purposes — not flexible.
  g <- grid::gTree(
    children = grid::gList(grid::rectGrob()),
    childrenvp = grid::viewport()
  )
  expect_false(is_flexible_grob(g))
})

test_that("is_flexible_grob returns FALSE for plain fixed-size grobs", {
  expect_false(is_flexible_grob(grid::rectGrob()))
  expect_false(is_flexible_grob(grid::textGrob("x")))
  expect_false(is_flexible_grob(grid::nullGrob()))
})

test_that("is_flexible_grob returns FALSE for a fixed-height gtable", {
  skip_if_not_installed("gtable")
  gt <- gtable::gtable(
    widths = grid::unit(1, "npc"),
    heights = grid::unit(1, "cm")
  )
  expect_false(is_flexible_grob(gt))
})

test_that("use_grob_height_for_object encodes the policy", {
  fixed <- grid::rectGrob()
  flex <- structure(grid::rectGrob(), gridify.flexible = TRUE)

  # vjust == 0.5 always uses npc height (legacy behaviour).
  expect_false(use_grob_height_for_object(fixed, 0.5))
  expect_false(use_grob_height_for_object(flex, 0.5))

  # vjust != 0.5 uses grobHeight only for fixed-size grobs.
  expect_true(use_grob_height_for_object(fixed, 0))
  expect_true(use_grob_height_for_object(fixed, 1))
  expect_false(use_grob_height_for_object(flex, 0))
  expect_false(use_grob_height_for_object(flex, 1))
})

test_that("object_viewport_height_expr uses npc height when vjust == 0.5", {
  e <- object_viewport_height_expr(grid::rectGrob(), vjust = 0.5, height = 0.8)
  expect_true(is.call(e))
  expect_identical(e[[1]], quote(grid::unit.pmax))
  inner <- e[[2]]
  expect_identical(inner[[1]], quote(grid::unit))
  expect_equal(inner[[2]], 0.8)
  expect_identical(inner[[3]], "npc")
})

test_that("object_viewport_height_expr uses npc height for flexible grobs", {
  flex <- structure(grid::rectGrob(), gridify.flexible = TRUE)
  e <- object_viewport_height_expr(flex, vjust = 0, height = 0.5)
  inner <- e[[2]]
  expect_identical(inner[[1]], quote(grid::unit))
  expect_equal(inner[[2]], 0.5)
})

test_that("object_viewport_height_expr uses grobHeight for fixed grobs when vjust != 0.5", {
  e <- object_viewport_height_expr(grid::rectGrob(), vjust = 0, height = 0.8)
  expect_identical(e[[1]], quote(grid::unit.pmax))
  expect_identical(e[[2]], quote(grid::grobHeight(OBJECT)))
})

test_that("object_viewport_height_expr default floor is 1 inch", {
  flex <- structure(grid::rectGrob(), gridify.flexible = TRUE)
  for (case in list(
    list(g = grid::rectGrob(), v = 0.5, h = 0.1),
    list(g = grid::rectGrob(), v = 0.0, h = 0.1),
    list(g = flex,             v = 0.0, h = 0.1)
  )) {
    e <- object_viewport_height_expr(case$g, case$v, case$h)
    floor_arg <- e[[3]]
    expect_s3_class(floor_arg, "unit")
    expect_equal(as.numeric(floor_arg), 1)
    expect_identical(grid::unitType(floor_arg), "inches")
  }
})

test_that("object_viewport_height_expr min_height is configurable", {
  e <- object_viewport_height_expr(
    grid::rectGrob(),
    vjust = 0,
    height = 0.8,
    min_height = grid::unit(2, "cm")
  )
  ee <- new.env()
  ee[["OBJECT"]] <- grid::rectGrob()
  res <- eval(e, ee)
  expect_s3_class(res, "unit")
})

test_that("object_viewport_height_expr returns an evaluable expression", {
  ee <- new.env()
  ee[["OBJECT"]] <- grid::rectGrob()
  e <- object_viewport_height_expr(grid::rectGrob(), vjust = 0, height = 0.8)
  res <- eval(e, ee)
  expect_s3_class(res, "unit")
})
