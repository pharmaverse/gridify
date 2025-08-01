test_that("gridify is a function with four arguments: object, layout, elements and ...", {
  expect_true(is.function(gridify))
  expect_identical(formalArgs(gridify), c("object", "layout", "elements", "..."))
})

test_that("gridify returns a gridifyClass object", {
  plot_obj <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point()
  # Call the gridify function
  expect_error(result <- gridify(object = plot_obj, layout = simple_layout()), NA)
  # Check if the result is a gridifyClass object
  expect_s4_class(result, "gridifyClass")
})

test_that("gridify accepts ggplot2 or grob for the object argument", {
  plot_obj <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point()
  expect_error(result <- gridify(object = plot_obj, layout = simple_layout()), NA)
  expect_error(result <- gridify(object = ggplot2::ggplotGrob(plot_obj), layout = simple_layout()), NA)
  expect_error(result <- gridify(object = grid::nullGrob(), layout = simple_layout()), NA)
  expect_error(result <- gridify(object = flextable::flextable(mtcars), layout = simple_layout()), NA)
  expect_error(result <- gridify(object = gt::gt(mtcars), layout = simple_layout()), NA)
  expect_error(result <- gridify(object = gt::as_gtable(gt::gt(mtcars)), layout = simple_layout()), NA)
  expect_error(result <- gridify(
    object = ~ plot(1),
    layout = simple_layout()
  ), NA)
  expect_error(result <- gridify(object = grid::nullGrob(), layout = simple_layout()), NA)
})

test_that("gridify accepts gridifyLayout or name of a function which returns such", {
  plot_obj <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point()
  expect_error(result <- gridify(object = plot_obj, layout = simple_layout()), NA)
  expect_error(result <- gridify(object = plot_obj, layout = simple_layout), NA)
})

test_that("gridify returns informative errors", {
  plot_obj <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point()
  expect_error(
    result <- gridify(
      object = 2,
      layout = simple_layout()
    ),
    "object argument of gridify has to be one of grob, ggplot, flextable, gt_tbl, formula class"
  )
  expect_error(
    result <- gridify(
      object = plot_obj,
      layout = 2
    ),
    "layout argument of gridify has to be of gridifyLayout class"
  )
  expect_error(
    result <- gridify(object = plot_obj, layout = simple_layout(), elements = 2),
    "elements argument of gridify has to be a list."
  )
  layout_fun <- function() {}
  expect_error(gridify(plot_obj, layout_fun), "layout argument function must result in a gridifyLayout class.")
})
