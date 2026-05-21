test_that("gridify_to_json round-trips basic payloads", {
  skip_if_not_installed("jsonlite")
  expect_identical(
    jsonlite::fromJSON(gridify_to_json(list(a = "x", b = "y"))),
    list(a = "x", b = "y")
  )
  expect_identical(
    jsonlite::fromJSON(gridify_to_json(list())),
    list()
  )
})

test_that("gridify_to_json unboxes scalars", {
  json <- gridify_to_json(list(a = "x", n = 1))
  expect_match(json, "\"a\":\"x\"", fixed = TRUE)
  expect_match(json, "\"n\":1", fixed = TRUE)
})

test_that("gridify_to_json escapes special characters", {
  skip_if_not_installed("jsonlite")
  s <- "DRAFT \"x\" \\ y\nz"
  json <- gridify_to_json(list(w = s))
  expect_identical(jsonlite::fromJSON(json)$w, s)
})

test_that("gridify_metadata extracts only set_cell text values", {
  obj <- gridify(grid::rectGrob(), pharma_layout_base())
  obj <- set_cell(obj, "header_left_1", "Co")
  obj <- set_cell(obj, "title_1", "T1")
  meta <- gridify_metadata(obj)
  expect_identical(meta, list(header_left_1 = "Co", title_1 = "T1"))
})

test_that("gridify_metadata returns empty list for no cells", {
  obj <- gridify(grid::rectGrob(), simple_layout())
  expect_identical(gridify_metadata(obj), stats::setNames(list(), character(0)))
})

test_that("write_metadata_sidecar writes JSON file and returns its path", {
  skip_if_not_installed("jsonlite")
  base <- tempfile(fileext = ".pdf")
  side <- paste0(base, ".json")
  if (file.exists(side)) file.remove(side)

  payload <- list(a = "x", b = "y")
  res <- write_metadata_sidecar(payload, base)

  expect_identical(res, side)
  expect_true(file.exists(side))
  expect_identical(jsonlite::fromJSON(side), payload)
})

test_that("write_metadata_sidecar skips empty payloads", {
  base <- tempfile(fileext = ".pdf")
  side <- paste0(base, ".json")
  if (file.exists(side)) file.remove(side)

  expect_null(write_metadata_sidecar(list(), base))
  expect_null(write_metadata_sidecar(NULL, base))
  expect_false(file.exists(side))
})

test_that("write_metadata_sidecar serialises multi-page list payload", {
  skip_if_not_installed("jsonlite")
  base <- tempfile(fileext = ".pdf")
  side <- paste0(base, ".json")
  if (file.exists(side)) file.remove(side)

  payload <- list(list(a = "1"), list(a = "2"))
  write_metadata_sidecar(payload, base)

  parsed <- jsonlite::fromJSON(side, simplifyVector = FALSE)
  expect_length(parsed, 2)
  expect_identical(parsed[[1]]$a, "1")
  expect_identical(parsed[[2]]$a, "2")
})
