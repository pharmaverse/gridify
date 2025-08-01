test_that("coloured_print is a function which returns a string", {
  expect_true(is.function(coloured_print))
  expect_silent(val <- coloured_print("Hello", "red"))
  expect_true(is.character(val) && (length(val) == 1))
})

test_that("coloured_print function accepts a string for the text argument", {
  expect_error(coloured_print(1, "green"), "text argument of coloured_print has to be a single string.")
  expect_error(coloured_print(c("a", "b"), "green"), "text argument of coloured_print has to be a single string.")
})

test_that("coloured_print function accepts specific colours for the colour argument", {
  expect_error(
    coloured_print("TEXT", "wrong"),
    "Accepted colours for the colour argument of coloured_print are black, red, green, yellow, blue, magenta, cyan, white" # nolint
  )
})
