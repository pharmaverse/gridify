skip_if_not_installed("shiny")
skip_if_not_installed("ggplot2")

make_gridify_obj <- function() {
  gridify(
    object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
      ggplot2::geom_point(),
    layout = simple_layout()
  ) |>
    set_cell("title", "Test title") |>
    set_cell("footer", "Test footer")
}

test_that("gridify_with_settings_ui returns a shiny.tag", {
  ui <- gridify_with_settings_ui("mod")
  expect_s3_class(ui, "shiny.tag")
})

test_that("gridify_with_settings_ui validates id", {
  expect_error(gridify_with_settings_ui(1), "single character string")
  expect_error(gridify_with_settings_ui(c("a", "b")), "single character string")
})

test_that("gridify_with_settings_ui includes key controls", {
  ui <- gridify_with_settings_ui("check")
  html <- as.character(ui)
  expect_true(grepl("check-plot_ui", html, fixed = TRUE))
  expect_true(grepl("check-height", html, fixed = TRUE))
  expect_true(grepl("check-width", html, fixed = TRUE))
  expect_true(grepl("dl_png", html, fixed = TRUE))
  expect_true(grepl("dl_pdf", html, fixed = TRUE))
})

test_that("gridify_with_settings_srv validates arguments", {
  expect_error(
    gridify_with_settings_srv(123, shiny::reactive(make_gridify_obj())),
    "single character string"
  )

  expect_error(
    gridify_with_settings_srv("id", "x"),
    "must be a shiny::reactive() or a plain function",
    fixed = TRUE
  )

  expect_error(
    gridify_with_settings_srv("id", shiny::reactive(make_gridify_obj()), height = c(1, 2)),
    "numeric vector of length 3"
  )

  expect_error(
    gridify_with_settings_srv("id", shiny::reactive(make_gridify_obj()), width = c(1, 2)),
    "numeric vector of length 3"
  )

  expect_error(
    gridify_with_settings_srv("id", shiny::reactive(make_gridify_obj()), height = c(100, 200, 2000)),
    "must be between min"
  )

  expect_error(
    gridify_with_settings_srv("id", shiny::reactive(make_gridify_obj()), width = c(100, 200, 2000)),
    "must be between min"
  )
})

test_that("gridify_with_settings_srv returns NULL", {
  gridify_r <- shiny::reactive(make_gridify_obj())

  shiny::testServer(
    app = gridify_with_settings_srv,
    args = list(gridify_r = gridify_r),
    expr = {
      expect_null(session$getReturned())
    }
  )
})

test_that("gridify_with_settings_srv checks object class", {
  bad_r <- shiny::reactive("not a gridify object")

  shiny::testServer(
    app = gridify_with_settings_srv,
    args = list(gridify_r = bad_r),
    expr = {
      session$setInputs(height = 600L, width = 800L)
      expect_error(get_obj(), "must return a 'gridifyClass' object")
    }
  )
})

test_that("gridify_with_settings_srv tracks slider inputs", {
  gridify_r <- shiny::reactive(make_gridify_obj())

  shiny::testServer(
    app = gridify_with_settings_srv,
    args = list(gridify_r = gridify_r),
    expr = {
      session$setInputs(height = 610L, width = 920L)
      expect_equal(as.integer(input$height), 610L)
      expect_equal(as.integer(input$width), 920L)
    }
  )
})
