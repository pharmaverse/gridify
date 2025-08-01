# Create a mock gridify object for testing
example_plot <- ggplot2::ggplotGrob(
  x = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line()
)

test_that("gridifyClass can be created with a proper input", {
  expect_silent(new("gridifyClass",
    object = example_plot,
    layout = simple_layout(),
    elements = list()
  ))
})


test_that(
  paste0(
    "gridifyClass has three cells of proper types:",
    "object, layout and elements"
  ),
  {
    class_spec <- getSlots("gridifyClass")

    expect_identical(class_spec, c(object = "ANY", layout = "gridifyLayout", elements = "list"))
  }
)


# We validate it on the gridify() function level
test_that("gridifyClass can be created with any type of object for output", {
  expect_silent(new("gridifyClass",
    object = 2,
    layout = simple_layout(),
    elements = list()
  ))

  expect_silent(new("gridifyClass",
    object = "any string",
    layout = simple_layout(),
    elements = list()
  ))
})
