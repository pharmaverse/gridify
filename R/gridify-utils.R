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

#' Build the metadata payload for a `gridifyClass` object
#'
#' Extracts the effective text for each layout cell. Values set with
#' [set_cell()] take precedence over layout default text. Cells with no
#' effective text are skipped.
#' @param x a `gridifyClass` object.
#' @return a named list mapping cell name to its text value.
#' @keywords internal
gridify_metadata <- function(x) {
  cells <- x@layout@cells@cells
  if (length(cells) == 0) {
    return(stats::setNames(list(), character(0)))
  }
  texts <- lapply(names(cells), function(cell) {
    elem <- x@elements[[cell]]
    cell_info <- cells[[cell]]
    candidates <- c(elem[["text"]], cell_info@text)
    if (length(candidates) == 0) NULL else candidates[1]
  })
  names(texts) <- names(cells)
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
#' @return A named list containing `schema`, `schema_version` and `pages`.
#' @keywords internal
metadata_sidecar_payload <- function(payload) {
  pages <- if (is.list(payload) && is.null(names(payload))) {
    payload
  } else {
    list(payload)
  }

  list(
    schema = "gridify.sidecar.metadata",
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

#' Detect a "flexible" grob whose natural height is not meaningful
#'
#' A flexible grob is one designed to fill whatever container it is placed
#' in, so `grid::grobHeight()` cannot be used to size its viewport.
#' Detection layers, in order of precedence:
#' 1. an explicit `gridify.flexible` attribute on the grob (set by the
#'    `gridify()` constructor for grobs produced via `grid::grid.grabExpr()`
#'    on the `formula` input path);
#' 2. a `gtable` with at least one `null` unit in its `heights`
#'    (e.g. `ggplot2::ggplotGrob()`).
#'
#' All other grobs (`gt::as_gtable()`, `flextable::gen_grob()`, plain
#' `grid::rectGrob()` / `grid::nullGrob()`, user gTrees, ...) are treated as
#' fixed-size. The previous heuristic of "any gTree carrying a `childrenvp`"
#' was dropped because `childrenvp` is set for many reasons unrelated to
#' container-filling (clip viewports, custom transforms, ...).
#'
#' @param grob a grob.
#' @return `TRUE` if `grob` is flexible, `FALSE` otherwise.
#' @keywords internal
is_flexible_grob <- function(grob) {
  if (isTRUE(attr(grob, "gridify.flexible"))) {
    return(TRUE)
  }
  if (inherits(grob, "gtable")) {
    return(any(grid_unit_type(grob$heights) == "null"))
  }
  FALSE
}


#' Build the viewport-height expression for the object's grob
#'
#' Chooses between the grob's natural height (`grid::grobHeight()`) and a
#' layout-driven height in npc, then floors the result via `grid::unit.pmax()`
#' so the viewport never collapses to zero.
#' 
#' `use_grob_height_for_object` evaluates to `TRUE` when the caller has opted 
#' into vertical anchoring (`vjust != 0.5`) and the grob has a meaningful 
#' natural height (i.e. is not flexible, see [is_flexible_grob()]). 
#' The `vjust == 0.5` short-circuit preserves the historical "fill the row" 
#' behaviour for users who did not opt in.
#'
#' The returned expression references an unbound symbol `OBJECT`; the
#' caller is responsible for evaluating it in an environment that binds
#' `OBJECT` to the grob.
#'
#' @param grob a grob; used to evaluate `use_grob_height_for_object`.
#' @param vjust numeric, the layout's object vjust.
#' @param height numeric, the layout's object height (in npc). Ignored on the
#' `grid::grobHeight()` branch (i.e. when `use_grob_height_for_object`
#' returns `TRUE`); used otherwise.
#' @param min_height a `grid::unit` floor applied via `grid::unit.pmax()`.
#' Default `grid::unit(1, "inch")`.
#' @return an unevaluated call producing a `grid::unit`.
#' @keywords internal
object_viewport_height_expr <- function(grob,
                                        vjust,
                                        height,
                                        min_height = grid::unit(1, "inches")) {
  min_height_call <- as.call(c(
    quote(grid::unit),
    list(as.numeric(min_height), grid_unit_type(min_height))
  ))

  use_grob_height_for_object <- vjust != 0.5 && !is_flexible_grob(grob)
  natural_height <- if (use_grob_height_for_object) {
    quote(grid::grobHeight(OBJECT))
  } else {
    substitute(grid::unit(h, "npc"), list(h = height))
  }
  substitute(
    grid::unit.pmax(NH, MIN),
    list(NH = natural_height, MIN = min_height_call)
  )
}
