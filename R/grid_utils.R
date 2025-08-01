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
