layouts <- get_layouts()

test_that("all layout functions are a function", {
  for (layout in layouts) {
    expect_true(
      is.function(asNamespace("gridify")[[layout]]),
      paste(layout, "fails")
    )
  }
})

test_that("all layout functions return a gridifyLayout", {
  for (layout in layouts) {
    expect_s4_class(asNamespace("gridify")[[layout]](), "gridifyLayout")
  }
})

test_that("all layout functions have any or some of arguments: margin, global_gpar, scales, and adjust_height", {
  for (layout in layouts) {
    args <- formalArgs(asNamespace("gridify")[[layout]])
    expect_true(is.null(args) || all(args %in% c("margin", "global_gpar", "scales", "adjust_height")))
  }
})

test_that("all layout functions contains layout in the name", {
  for (layout in layouts) {
    expect_true(grepl("layout", layout))
  }
})

layouts_with_scales_argument <- c("complex_layout", "simple_layout")

test_that("scales argument works correctly", {
  for (layout in layouts_with_scales_argument) {
    layout_func <- asNamespace("gridify")[[layout]]
    expect_silent(layout_func(scales = "free"))
    expect_silent(layout_func(scales = "fixed"))
  }
})
