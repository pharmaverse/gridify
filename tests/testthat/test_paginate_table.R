test_that("paginate_table works with basic input", {
  pages <- paginate_table(mtcars, rows_per_page = 10)

  expect_type(pages, "list")
  expect_equal(length(pages), 4)  # 32 rows / 10 per page = 4 pages
  expect_equal(nrow(pages[[1]]), 10)
  expect_equal(nrow(pages[[2]]), 10)
  expect_equal(nrow(pages[[3]]), 10)
  expect_equal(nrow(pages[[4]]), 2)  # Last page has 2 rows
})

test_that("paginate_table fills last page when requested", {
  pages <- paginate_table(mtcars, rows_per_page = 10, fill_last_page = TRUE)

  expect_equal(length(pages), 4)
  expect_equal(nrow(pages[[1]]), 10)
  expect_equal(nrow(pages[[2]]), 10)
  expect_equal(nrow(pages[[3]]), 10)
  expect_equal(nrow(pages[[4]]), 10)  # Last page filled to 10 rows

  # Check that empty rows are " " (space character)
  last_page <- pages[[4]]
  expect_equal(last_page[9, 1], " ")
  expect_equal(last_page[10, 1], " ")
})

test_that("paginate_table adds page column by default", {
  pages <- paginate_table(mtcars, rows_per_page = 10)

  expect_true("page_number" %in% colnames(pages[[1]]))
  expect_equal(unique(pages[[1]]$page_number), 1)
  expect_equal(unique(pages[[2]]$page_number), 2)
  expect_equal(unique(pages[[3]]$page_number), 3)
  expect_equal(unique(pages[[4]]$page_number), 4)
})

test_that("paginate_table works without page column", {
  pages <- paginate_table(mtcars, rows_per_page = 10, page_col = NULL)

  expect_false("page_number" %in% colnames(pages[[1]]))
  expect_equal(ncol(pages[[1]]), ncol(mtcars))
})

test_that("paginate_table works with custom page column name", {
  pages <- paginate_table(mtcars, rows_per_page = 10, page_col = "my_page")

  expect_true("my_page" %in% colnames(pages[[1]]))
  expect_false("page_number" %in% colnames(pages[[1]]))
})

test_that("paginate_table validates inputs correctly", {
  expect_error(
    paginate_table("not a data frame", 10),
    "`data` must be a data frame"
  )

  expect_error(
    paginate_table(mtcars, -5),
    "`rows_per_page` must be a positive integer"
  )

  expect_error(
    paginate_table(mtcars, c(10, 20)),
    "`rows_per_page` must be a positive integer"
  )

  expect_error(
    paginate_table(mtcars, 10, fill_last_page = "yes"),
    "`fill_last_page` must be TRUE or FALSE"
  )

  expect_error(
    paginate_table(mtcars, 10, page_col = c("page1", "page2")),
    "`page_col` must be NULL or a single character string"
  )
})

test_that("paginate_table handles edge cases", {
  # Data with exact multiple of rows_per_page
  df_30 <- mtcars[1:30, ]
  pages <- paginate_table(df_30, rows_per_page = 10)
  expect_equal(length(pages), 3)
  expect_equal(nrow(pages[[3]]), 10)

  # Single row per page
  pages_single <- paginate_table(mtcars[1:5, ], rows_per_page = 1)
  expect_equal(length(pages_single), 5)
  expect_equal(nrow(pages_single[[1]]), 1)

  # More rows per page than data
  pages_large <- paginate_table(mtcars[1:5, ], rows_per_page = 100)
  expect_equal(length(pages_large), 1)
  expect_equal(nrow(pages_large[[1]]), 5)
})

test_that("paginate_table preserves data integrity", {
  pages <- paginate_table(mtcars, rows_per_page = 10, page_col = NULL)

  # Recombine all pages (excluding filled rows)
  combined <- do.call(rbind, pages)

  # Should match original data
  expect_equal(nrow(combined), nrow(mtcars))
  expect_equal(combined, mtcars, ignore_attr = TRUE)
})
