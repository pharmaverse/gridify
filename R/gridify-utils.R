#' Wrapper for `grid::unitType` which supports older R versions
#' @param x a grid::unit
#' @param use_grid means try to call grid::unitType if it exists.
#' The main purpose of this argument is to have full test coverage in tests.
#' Default TRUE.
#' @return a character vector with unit type for each element.
#' @keywords internal
grid_unit_type <- function(x, use_grid = TRUE) {
  if (use_grid && is.function(base::asNamespace("grid")[["unitType"]])) {
    utils::getFromNamespace("unitType", "grid")(x)
  } else {
    unit_val <- attr(x, "unit")
    if (!is.null(unit_val)) {
      rep(unit_val, length = length(x))
    } else {
      stop("grid_unit_type x argument: Not a unit object")
    }
  }
}

#' Get `grid::gpar` arguments
#' @param gpar a `grid::gpar` object.
#' @return a list.
#' @keywords internal
gpar_args <- function(gpar) {
  args <- as.list(gpar)
  fontface <- args[["fontface"]]
  font <- if (isTRUE(is.na(args[["font"]]))) NULL else args[["font"]]

  # Remove the original font and fontface from args
  args[["font"]] <- NULL
  args[["fontface"]] <- NULL

  args[["fontface"]] <- if (!is.null(fontface)) fontface else font

  args
}

#' Convert `grid::gpar` to a call
#' @param gpar a `grid::gpar` object.
#' @return a call.
#' @keywords internal
gpar_call <- function(gpar) {
  if (length(gpar) == 0) {
    return(as.call(c(quote(grid::gpar), list())))
  }

  as.call(c(quote(grid::gpar), gpar_args(gpar)))
}

#' Build the metadata payload for a `gridifyClass` object.
#'
#' Extracts the `text` field from each `set_cell()` element, in the order they
#' were added. Cells with `NULL` text are skipped.
#' @param x a `gridifyClass` object.
#' @return a named list mapping cell name to its text value.
#' @keywords internal
gridify_metadata <- function(x) {
  elems <- x@elements
  if (length(elems) == 0) {
    return(stats::setNames(list(), character(0)))
  }
  texts <- lapply(elems, function(el) el[["text"]])
  texts[!vapply(texts, is.null, logical(1))]
}

#' Encode a metadata payload as JSON via `jsonlite`.
#'
#' Thin wrapper around `jsonlite::toJSON()` with the options used by gridify
#' metadata: scalar character/numeric/logical values are unboxed, `NA` and
#' `NULL` are serialised as `null`. Centralised so the encoder options live in
#' one place.
#' @param x value to encode.
#' @return a length-one character vector with the JSON representation of `x`.
#' @keywords internal
gridify_to_json <- function(x) {
  if (requireNamespace("jsonlite", quietly = TRUE)) {
    as.character(jsonlite::toJSON(
      x,
      auto_unbox = TRUE,
      null = "null",
      na = "null"
    ))
  } else {
    stop("Please install the 'jsonlite' package to use the gridify_to_json function")
  }
}

#' Build the JSON sidecar metadata structure
#'
#' Wraps single-page and multi-page metadata in the same schema so consumers can
#' always read metadata from `pages[[i]]$cells`.
#'
#' @param payload A named list (single page) or list of named lists (multi-page)
#' of metadata values.
#' @return A named list containing `schema_version` and `pages`.
#' @keywords internal
metadata_sidecar_payload <- function(payload) {
  pages <- if (is.list(payload) && is.null(names(payload))) {
    payload
  } else {
    list(payload)
  }

  list(
    schema_version = "1.0.0",
    pages = lapply(pages, function(cells) list(cells = cells))
  )
}

#' Check whether a metadata payload contains values
#'
#' @param payload A metadata payload.
#' @return `TRUE` when the payload contains at least one metadata value.
#' @keywords internal
has_metadata_payload <- function(payload) {
  if (is.null(payload) || length(payload) == 0) {
    return(FALSE)
  }
  if (is.list(payload) && is.null(names(payload))) {
    return(any(vapply(payload, has_metadata_payload, logical(1))))
  }
  TRUE
}

#' Synchronise the JSON metadata sidecar file
#'
#' Writes `json` to the sidecar when supplied. Otherwise removes any existing
#' sidecar for `to`, preventing stale metadata from surviving later exports of
#' the same output file.
#'
#' @param to A length-one character string with the path of the main output
#' file.
#' @param json Optional pre-encoded JSON metadata.
#' @return Invisibly, the path of the sidecar file that was written or removed.
#' @keywords internal
sync_metadata_sidecar <- function(to, json = NULL) {
  side <- paste0(to, ".json")
  if (!is.null(json)) {
    writeLines(json, con = side, useBytes = TRUE)
  } else if (file.exists(side)) {
    unlink(side)
  }
  invisible(side)
}

#' Resolve the effective `metadata` argument for `export_to()`
#'
#' Resolves the `metadata` argument from (in order of precedence):
#' 1. the value passed by the caller,
#' 2. the `gridify.export.metadata` global option,
#' 3. the built-in default `"none"`.
#'
#' The result is then validated against the allowed choices via
#' [match.arg()], so abbreviations are accepted.
#'
#' @param metadata the value passed by the user; may be `NULL`.
#' @return one of `"none"`, `"sidecar"`.
#' @keywords internal
resolve_export_metadata <- function(metadata) {
  choices <- c("none", "sidecar")
  if (is.null(metadata)) {
    metadata <- getOption("gridify.export.metadata", "none")
  }
  match.arg(metadata, choices)
}