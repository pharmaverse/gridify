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

test_that("has_metadata_payload detects populated payloads", {
  expect_false(has_metadata_payload(NULL))
  expect_false(has_metadata_payload(list()))
  expect_false(has_metadata_payload(list(list(), list())))
  expect_true(has_metadata_payload(list(a = "x")))
  expect_true(has_metadata_payload(list(list(), list(a = "x"))))
})

test_that("metadata_sidecar_payload uses a uniform pages schema", {
  single <- metadata_sidecar_payload(list(a = "x"))
  expect_identical(single$schema, "gridify.sidecar.metadata")
  expect_identical(single$schema_version, "1.0.0")
  expect_length(single$pages, 1)
  expect_identical(single$pages[[1]]$cells, list(a = "x"))

  multi <- metadata_sidecar_payload(list(list(a = "1"), list(a = "2")))
  expect_identical(multi$schema, "gridify.sidecar.metadata")
  expect_identical(multi$schema_version, "1.0.0")
  expect_length(multi$pages, 2)
  expect_identical(multi$pages[[1]]$cells, list(a = "1"))
  expect_identical(multi$pages[[2]]$cells, list(a = "2"))
})

test_that("sync_metadata_sidecar writes populated sidecars", {
  skip_if_not_installed("jsonlite")
  base <- tempfile(fileext = ".pdf")
  side <- paste0(base, ".json")
  if (file.exists(side)) file.remove(side)
  json <- gridify_to_json(metadata_sidecar_payload(list(a = "x")))

  expect_identical(sync_metadata_sidecar(base, json), side)
  expect_true(file.exists(side))
  parsed <- jsonlite::fromJSON(side, simplifyVector = FALSE)
  expect_identical(parsed$schema, "gridify.sidecar.metadata")
  expect_identical(parsed$schema_version, "1.0.0")
  expect_identical(parsed$pages[[1]]$cells$a, "x")
})

test_that("sync_metadata_sidecar serialises multi-page list payload", {
  skip_if_not_installed("jsonlite")
  base <- tempfile(fileext = ".pdf")
  side <- paste0(base, ".json")
  if (file.exists(side)) file.remove(side)

  payload <- list(list(a = "1"), list(a = "2"))
  sync_metadata_sidecar(base, gridify_to_json(metadata_sidecar_payload(payload)))

  parsed <- jsonlite::fromJSON(side, simplifyVector = FALSE)
  expect_identical(parsed$schema, "gridify.sidecar.metadata")
  expect_identical(parsed$schema_version, "1.0.0")
  expect_length(parsed$pages, 2)
  expect_identical(parsed$pages[[1]]$cells$a, "1")
  expect_identical(parsed$pages[[2]]$cells$a, "2")
})

test_that("sync_metadata_sidecar uses pre-encoded JSON", {
  base <- tempfile(fileext = ".pdf")
  side <- paste0(base, ".json")
  if (file.exists(side)) file.remove(side)

  expect_identical(sync_metadata_sidecar(base, "{\"a\":\"y\"}"), side)
  expect_identical(readLines(side, warn = FALSE), "{\"a\":\"y\"}")
})

test_that("sync_metadata_sidecar removes stale files", {
  base <- tempfile(fileext = ".pdf")
  side <- paste0(base, ".json")

  writeLines("stale", side)
  expect_identical(sync_metadata_sidecar(base), side)
  expect_false(file.exists(side))

  writeLines("stale", side)
  expect_identical(sync_metadata_sidecar(base, NULL), side)
  expect_false(file.exists(side))
})

