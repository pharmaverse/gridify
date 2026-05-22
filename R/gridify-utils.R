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
    return(any(grid::unitType(grob$heights) == "null"))
  }
  FALSE
}


#' Build the viewport-height expression for the object's grob
#'
#' Chooses between the grob's natural height (`grid::grobHeight()`) and a
#' layout-driven height in npc, then floors the result via `grid::unit.pmax()`
#' so the viewport never collapses to zero.
#' 
#' `use_grob_height_for_object evaluates` to `TRUE` when the caller has opted 
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
