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
  pages <- paginate_table(mtcars, rows_per_page = 10, fill_empty = "|")

  expect_equal(length(pages), 4)
  expect_equal(nrow(pages[[1]]), 10)
  expect_equal(nrow(pages[[2]]), 10)
  expect_equal(nrow(pages[[3]]), 10)
  expect_equal(nrow(pages[[4]]), 10)  # Last page filled to 10 rows

  # Check that empty rows are "|"
  last_page <- pages[[4]]
  expect_equal(last_page[9, 1], "|")
  expect_equal(last_page[10, 1], "|")
})

test_that("paginate_table fills with custom character", {
  pages <- paginate_table(mtcars, rows_per_page = 10, fill_empty = "")

  expect_equal(length(pages), 4)
  expect_equal(nrow(pages[[4]]), 10)  # Last page filled to 10 rows

  # Check that empty rows are ""
  last_page <- pages[[4]]
  expect_equal(last_page[9, 1], "")
  expect_equal(last_page[10, 1], "")
})

test_that("paginate_table works without page column", {
  pages <- paginate_table(mtcars, rows_per_page = 10)

  expect_equal(ncol(pages[[1]]), ncol(mtcars))
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
    paginate_table(mtcars, 10, fill_empty = TRUE),
    "`fill_empty` must be NULL or a single character string"
  )

  expect_error(
    paginate_table(mtcars, 10, fill_empty = c("|", "-")),
    "`fill_empty` must be NULL or a single character string"
  )

  expect_error(
    paginate_table(mtcars),
    "At least one of `rows_per_page` or `split_by` must be provided"
  )

  expect_error(
    paginate_table(mtcars, split_by = "nonexistent_column"),
    "`split_by` column 'nonexistent_column' not found in data"
  )

  expect_error(
    paginate_table(mtcars, split_by = c("cyl", "gear")),
    "`split_by` must be a single character string"
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
  pages <- paginate_table(mtcars, rows_per_page = 10)

  # Recombine all pages (excluding filled rows)
  combined <- do.call(rbind, pages)

  # Should match original data
  expect_equal(nrow(combined), nrow(mtcars))
  expect_equal(combined, mtcars, ignore_attr = TRUE)
})

test_that("paginate_table splits by column", {
  pages <- paginate_table(mtcars, split_by = "cyl")

  expect_type(pages, "list")
  expect_equal(length(pages), 3)  # 3 unique cylinder values (4, 6, 8)

  # Check that list is named with group values
  expect_true(!is.null(names(pages)))
  expect_equal(sort(names(pages)), c("4", "6", "8"))

  # Check that each page contains only one cylinder value
  expect_true(all(pages[[1]]$cyl == pages[[1]]$cyl[1]))
  expect_true(all(pages[[2]]$cyl == pages[[2]]$cyl[1]))
  expect_true(all(pages[[3]]$cyl == pages[[3]]$cyl[1]))

  # Check total rows match
  total_rows <- sum(sapply(pages, nrow))
  expect_equal(total_rows, nrow(mtcars))
})

test_that("paginate_table splits by column with filling", {
  pages <- paginate_table(mtcars, split_by = "cyl", fill_empty = "|")

  expect_equal(length(pages), 3)

  # Check that list is named
  expect_true(!is.null(names(pages)))
  expect_equal(sort(names(pages)), c("4", "6", "8"))

  # All pages should have the same number of rows (max page size)
  page_sizes <- sapply(pages, nrow)
  expect_true(all(page_sizes == max(page_sizes)))

  # Check that filling was applied where needed
  max_size <- max(page_sizes)
  expect_equal(nrow(pages[[1]]), max_size)
  expect_equal(nrow(pages[[2]]), max_size)
  expect_equal(nrow(pages[[3]]), max_size)
})

test_that("paginate_table combines split_by and rows_per_page", {
  # mtcars has 11 cars with 8 cylinders, so with rows_per_page=5 it should create 3 pages for that group
  pages <- paginate_table(mtcars, split_by = "cyl", rows_per_page = 5)

  # Should have more pages than unique cylinder values (3)
  expect_true(length(pages) > 3)

  # Check that list is named with repeated names for split groups
  expect_true(!is.null(names(pages)))
  page_names <- names(pages)
  # Should have "8" repeated multiple times (since 8 cyl has 14 cars > 5)
  expect_true(sum(page_names == "8") > 1)

  # No page should have more than 5 rows
  page_sizes <- sapply(pages, nrow)
  expect_true(all(page_sizes <= 5))
})

test_that("paginate_table combines split_by and rows_per_page with filling", {
  pages <- paginate_table(mtcars, split_by = "cyl", rows_per_page = 5, fill_empty = "|")

  # Check that list is named
  expect_true(!is.null(names(pages)))

  # All pages should have same number of rows (max page size, which is 5)
  page_sizes <- sapply(pages, nrow)
  expect_true(all(page_sizes == 5))
})

test_that("paginate_table split_by preserves column order", {
  pages <- paginate_table(mtcars, split_by = "gear")

  # Check that all pages have the same columns in the same order
  expect_equal(colnames(pages[[1]]), colnames(mtcars))
  expect_equal(colnames(pages[[2]]), colnames(mtcars))
})

test_that("paginate_table split_by handles single group", {
  # Create a data frame with only one unique value in split column
  df_single <- mtcars[mtcars$cyl == 4, ]
  pages <- paginate_table(df_single, split_by = "cyl")

  expect_equal(length(pages), 1)
  expect_equal(nrow(pages[[1]]), nrow(df_single))
})
