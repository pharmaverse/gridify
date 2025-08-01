test_that("gpar_call handles both fontface and font correctly", {
  gpar <- grid::gpar(fontface = "bold")
  result <- gpar_call(gpar)
  expect_identical(length(result), 2L)

  expect_warning(gpar <- grid::gpar(font = "bold"))
  result <- gpar_call(gpar)
  expect_identical(length(result), 1L)
})

test_that("gpar_call working with complex calls", {
  gpar <- grid::gpar(
    fontface = "bold",
    fontsize = 10,
    col = "red",
    fill = "blue",
    alpha = 0.5,
    cex = 2
  )
  result <- gpar_call(gpar)
  expect_identical(length(result), 7L)

  # font is omitted as in original grid::gpar
  expect_warning(
    gpar <- grid::gpar(
      font = "bold",
      fontsize = 10,
      col = "red",
      fill = "blue",
      alpha = 0.5,
      cex = 2
    )
  )
  result <- gpar_call(gpar)
  expect_identical(length(result), 6L)
})

test_that("gpar_call handles empty input correctly", {
  gpar <- grid::gpar()
  result <- gpar_call(gpar)
  expect_identical(length(result), 1L)
})

test_that("gpar_args returns a list", {
  g <- grid::gpar(col = "red", font = 2)
  result <- gpar_args(g)
  expect_type(result, "list")
  expect_named(result, c("col", "fontface"))
  expect_identical(result$col, "red")
  expect_identical(result$fontface, 2L)
})

test_that("font is used as fallback if fontface is NULL", {
  g <- grid::gpar(font = 3)
  result <- gpar_args(g)
  expect_equal(result$fontface, 3)
})

test_that("original font and fontface are removed from args", {
  g <- grid::gpar(fontface = "italic", col = "blue")
  result <- gpar_args(g)
  expect_false("font" %in% names(result))
  expect_false(any(duplicated(names(result))))
})
