setOldClass(
  c(
    "unit",
    "simpleUnit",
    "unit.list",
    "gpar",
    "grob",
    "gtable",
    "gridifyObject",
    "gridifyCells",
    "gridifyCell"
  )
)
setClassUnion("unitOrSimpleUnit", c("unit", "simpleUnit", "unit.list"))

#' gridifyLayout class
#'
#' Class for creating a layout for a gridify object.
#'
#' @slot nrow An integer specifying the number of rows in the layout.
#' @slot ncol An integer specifying the number of columns in the layout.
#' @slot heights A `grid::unit()` call specifying the heights of the rows.
#' @slot widths A `grid::unit()` call specifying the widths of the columns.
#' @slot margin A `grid::unit()` specifying the margins around the object.
#' @slot global_gpar A `grid::gpar()` object specifying the global graphical parameters.
#' @slot background A string with background colour.
#' @slot adjust_height A logical value indicating whether to adjust the height of the object.
#' Only applies for cells with height defined in cm, mm, inch or lines units.
#' @slot object A grob object.
#' @slot cells A list of cell objects.
#' @exportClass gridifyLayout
setClass(
  "gridifyLayout",
  representation(
    nrow = "numeric",
    ncol = "numeric",
    heights = "unitOrSimpleUnit",
    widths = "unitOrSimpleUnit",
    margin = "unitOrSimpleUnit",
    global_gpar = "gpar",
    background = "character",
    adjust_height = "logical",
    object = "gridifyObject",
    cells = "gridifyCells"
  )
)

setValidity("gridifyLayout", function(object) {
  if (!is(object@margin, "unit")) {
    stop("The 'margin' argument must be of type 'unit'.")
  }
  if (length(object@margin) != 4) {
    stop("The 'margin' argument must be a vector of length 4.")
  }
  if (!((length(object@background) == 1) && is.character(object@background))) {
    stop("The 'background' argument must be a string.")
  }
  if (length(object@heights) != object@nrow) {
    stop(
      "heights has to have the same length as number of rows (nrow) in gridifyLayout."
    )
  }
  if (length(object@widths) != object@ncol) {
    stop(
      "widths has to have the same length as number of cols (ncol) in gridifyLayout."
    )
  }

  if (!all(object@object@row <= object@nrow)) {
    stop(sprintf(
      "gridifyObject row value has to be less or equal to nrow: %s.",
      object@nrow
    ))
  }

  if (!all(object@object@col <= object@ncol)) {
    stop(sprintf(
      "gridifyObject col value has to be less or equal to ncol: %s.",
      object@ncol
    ))
  }

  cells_rows <- unlist(sapply(object@cells@cells, function(e) e@row))
  cells_cols <- unlist(sapply(object@cells@cells, function(e) e@col))

  if (!all(cells_rows <= object@nrow)) {
    stop(c(
      "All cells rows have to be less or equal to nrow.",
      "\nNumber of rows: ",
      object@nrow,
      "\nMaximum row number called in a cell: ",
      max(cells_rows)
    ))
  }
  if (!all(cells_cols <= object@ncol)) {
    stop(c(
      "All cells cols have to be less or equal to ncol",
      "\nNumber of rows: ",
      object@ncol,
      "\nMaximum row number called in a cell: ",
      max(cells_cols)
    ))
  }

  occupied <- NULL
  overlap <- NULL

  for (cell in object@cells@cells) {
    r_range <- if (length(cell@row) == 2) {
      seq(min(cell@row), max(cell@row))
    } else {
      cell@row
    }
    c_range <- if (length(cell@col) == 2) {
      seq(min(cell@col), max(cell@col))
    } else {
      cell@col
    }

    for (r in r_range) {
      for (c in c_range) {
        pos <- paste(r, c, sep = "-")
        if (pos %in% occupied) {
          overlap <- c(overlap, pos)
        } else {
          occupied <- c(occupied, pos)
        }
      }
    }
  }

  if (length(overlap) > 0) {
    warning(
      "Overlapping cells detected at positions: ",
      paste(unique(overlap), collapse = ", ")
    )
  }

  TRUE
})

#' Create a gridifyLayout
#'
#' Function for creating a new instance of the gridifyLayout class.
#'
#' @param nrow An integer specifying the number of rows in the layout.
#' @param ncol An integer specifying the number of columns in the layout.
#' @param heights A call to `grid::unit()` specifying the heights of the rows.
#' @param widths A call to `grid::unit()` specifying the widths of the columns.
#' @param margin A `grid::unit()` specifying the margins around the object.
#' Must be a vector of length 4, one element for each margin, with values in order for top, right, bottom, left.
#' @param global_gpar A call to `grid::gpar()` specifying the global graphical parameters.
#' Default is `grid::gpar()`.
#' @param background A string with background colour. Default `grid::get.gpar()$fill`.
#' @param adjust_height A logical value indicating whether to automatically adjust the height of the object to
#' make sure all of the text elements around the output do not overlap.
#' This only applies for rows with height defined in cm, mm, inch or lines units. Default is TRUE.
#' @param object A call to `gridifyObject` specifying the row and column location of the object.
#' @param cells A call to `gridifyCells` listing out the text element cells required for the layout.
#'
#' @seealso [gridifyCells()], [gridifyCell()], [gridifyObject()]
#' @return A new instance of the gridifyLayout class.
#'
#' @export
#' @examples
#' layout <- gridifyLayout(
#'   nrow = 3L,
#'   ncol = 1L,
#'   heights = grid::unit(c(0.15, 0.7, 0.15), "npc"),
#'   widths = grid::unit(1, "npc"),
#'   margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
#'   global_gpar = grid::gpar(),
#'   background = grid::get.gpar()$fill,
#'   adjust_height = FALSE,
#'   object = gridifyObject(row = 2, col = 1),
#'   cells = gridifyCells(
#'     title = gridifyCell(row = 1, col = 1),
#'     footer = gridifyCell(row = 3, col = 1)
#'   )
#' )
#'
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#'
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = layout
#' ) %>%
#'   set_cell("title", "TITLE") %>%
#'   set_cell("footer", "FOOTER")
#'
#' new_layout <- function(
#'     margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
#'     global_gpar = grid::gpar()) {
#'   gridifyLayout(
#'     nrow = 4L,
#'     ncol = 1L,
#'     heights = grid::unit(c(3, 0.5, 1, 3), c("cm", "cm", "null", "cm")),
#'     widths = grid::unit(1, "npc"),
#'     global_gpar = global_gpar,
#'     background = grid::get.gpar()$fill,
#'     margin = margin,
#'     adjust_height = FALSE,
#'     object = gridifyObject(row = 3, col = 1),
#'     cells = gridifyCells(
#'       title = gridifyCell(row = 1, col = 1, text = "Default Title"),
#'       subtitle = gridifyCell(row = 2, col = 1),
#'       footer = gridifyCell(row = 4, col = 1)
#'     )
#'   )
#' }
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = new_layout()
#' ) %>%
#'   set_cell("subtitle", "SUBTITLE") %>%
#'   set_cell("footer", "FOOTER")
gridifyLayout <- function(
  nrow,
  ncol,
  heights,
  widths,
  margin,
  global_gpar = grid::gpar(),
  background = grid::get.gpar()$fill,
  adjust_height = TRUE,
  object,
  cells
) {
  new(
    "gridifyLayout",
    nrow = nrow,
    ncol = ncol,
    heights = heights,
    widths = widths,
    margin = margin,
    global_gpar = global_gpar,
    background = background,
    adjust_height = adjust_height,
    object = object,
    cells = cells
  )
}

#' gridifyCell class
#'
#' Class for creating a cell used in a gridify layout.
#'
#' @slot row A numeric value, span or a sequence specifying the range of occupied rows of the cell.
#' @slot col A numeric value, span or a sequence specifying the range of occupied columns of the cell.
#' @slot text A character value specifying the default text for the cell.
#' @slot mch A numeric value specifying the maximum number of characters per line.
#' The functionality is based on the `strwrap` function.
#' By default, it avoids breaking up words and only splits lines when specified.
#' @slot x A numeric value specifying the x position of text in the cell.
#' @slot y A numeric value specifying the y position of text in the cell.
#' @slot hjust A numeric value specifying the horizontal position of the text in the cell, relative to the x value.
#' @slot vjust A numeric value specifying the vertical position of the text in the cell, relative to the y value.
#' @slot rot A numeric value specifying the rotation of the cell.
#' @slot gpar A `grid::gpar()` object specifying the graphical parameters of the cell.
#' @exportClass gridifyCell
setClass(
  "gridifyCell",
  representation(
    row = "numeric",
    col = "numeric",
    text = "character",
    mch = "numeric",
    x = "numeric",
    y = "numeric",
    hjust = "numeric",
    vjust = "numeric",
    rot = "numeric",
    gpar = "gpar"
  )
)

setValidity("gridifyCell", function(object) {
  if (min(object@row) < 1 || !all(object@row %% 1 == 0)) {
    stop("cell row has to be positive integer.")
  }
  if (min(object@col) < 1 || !all(object@col %% 1 == 0)) {
    stop("cell col has to be positive integer.")
  }
  if (length(object@text) > 1) {
    stop("cell text has to be a string.")
  }

  TRUE
})

#' Create a gridifyCell
#'
#' Function for creating a new instance of the gridifyCell class.
#' Multiple gridifyCell objects are inputs for gridifyCells.
#'
#' @param row A numeric value, span or a sequence specifying the range of occupied rows of the cell.
#' @param col A numeric value, span or a sequence specifying the range of occupied columns of the cell.
#' @param text A character value specifying the default text for the cell.
#' Default `character(0)`.
#' @param mch A numeric value specifying the maximum number of characters per line.
#' The functionality is based on the `strwrap` function.
#' By default, it avoids breaking up words and only splits lines when specified.
#' Default `Inf`.
#' @param x A numeric value specifying the x position of text in the cell.
#' Default `0.5`.
#' @param y A numeric value specifying the y position of text in the cell.
#' Default `0.5`.
#' @param hjust A numeric value specifying the horizontal position of the text in the cell, relative to the x value.
#' Default `0.5`.
#' @param vjust A numeric value specifying the vertical position of the text in the cell, relative to the y value.
#' Default `0.5`.
#' @param rot A numeric value specifying the rotation of the cell.
#' Default `0`.
#' @param gpar A `grid::gpar()` object specifying the graphical parameters of the cell.
#' Default `grid::gpar()`.
#'
#' @seealso [gridifyCells()], [gridifyLayout()]
#' @return An instance of the gridifyCell class.
#'
#' @export
#' @examples
#' cell <- gridifyCell(
#'   row = 1,
#'   col = 1:2,
#'   text = "Default cell text",
#'   mch = Inf,
#'   x = 0.5,
#'   y = 0.5,
#'   hjust = 0.5,
#'   vjust = 0.5,
#'   rot = 0,
#'   gpar = grid::gpar()
#' )
gridifyCell <- function(
  row,
  col,
  text = character(0),
  mch = Inf,
  x = 0.5,
  y = 0.5,
  hjust = 0.5,
  vjust = 0.5,
  rot = 0,
  gpar = grid::gpar()
) {
  new(
    "gridifyCell",
    row = row,
    col = col,
    text = text,
    mch = mch,
    x = x,
    y = y,
    hjust = hjust,
    vjust = vjust,
    rot = rot,
    gpar = gpar
  )
}

#' gridifyCells class
#'
#' Class for creating a list of cells in a gridify layout.
#'
#' @slot cells A list of cell objects.
#' @exportClass gridifyCells
setClass(
  "gridifyCells",
  representation(
    cells = "list"
  )
)

setValidity("gridifyCells", function(object) {
  if (length(object@cells) == 0) {
    stop("gridifyCells can not be empty.")
  }
  if (length(names(object@cells)) != length(object@cells)) {
    stop("All elements in gridifyCells have to be named.")
  }
  if (length(unique(names(object@cells))) != length(object@cells)) {
    stop("All elements in gridifyCells must have unique names.")
  }

  if (
    !all(vapply(object@cells, function(e) is(e, "gridifyCell"), logical(1)))
  ) {
    stop("All elements in gridifyCells have to be gridifyCell.")
  }

  TRUE
})

#' Create a gridifyCells
#'
#' Function for creating a new instance of the gridifyCells class.
#' gridifyCells consists of multiple gridifyCell objects and is an input object for gridifyLayout.
#'
#' @param ... Arguments passed to the new function to create an instance of the gridifyCells class.
#' Each argument should be the result of a call to gridifyCell.
#'
#' @return An instance of the gridifyCells class.
#'
#' @seealso [gridifyLayout()]
#' @export
#' @examples
#' cell1 <- gridifyCell(
#'   row = 1,
#'   col = 1,
#'   x = 0.5,
#'   y = 0.5,
#'   hjust = 0.5,
#'   vjust = 0.5,
#'   rot = 0,
#'   gpar = grid::gpar()
#' )
#' cell2 <- gridifyCell(
#'   row = 2,
#'   col = 2,
#'   x = 0.5,
#'   y = 0.5,
#'   hjust = 0.5,
#'   vjust = 0.5,
#'   rot = 0,
#'   gpar = grid::gpar()
#' )
#' cells <- gridifyCells(title = cell1, footer = cell2)
gridifyCells <- function(...) {
  cells <- list(...)
  new("gridifyCells", cells = cells)
}

#' gridifyObject class
#'
#' Class for creating an object in a gridify layout.
#'
#' @slot row A numeric value, span or sequence specifying the row position of the object.
#' @slot col A numeric value, span or sequence specifying the column position of the object.
#' @slot height A numeric value specifying the height of the object.
#' @slot width A numeric value specifying the width of the object.
#' @exportClass gridifyObject
setClass(
  "gridifyObject",
  representation(
    row = "numeric",
    col = "numeric",
    height = "numeric",
    width = "numeric"
  )
)

setValidity("gridifyObject", function(object) {
  if (min(object@row) < 1 || !all(object@row %% 1 == 0)) {
    stop("cell row has to be positive integer.")
  }
  if (min(object@col) < 1 || !all(object@col %% 1 == 0)) {
    stop("cell col has to be positive integer.")
  }

  TRUE
})

#' Create a gridifyObject
#'
#' Function for creating a new instance of the gridifyObject class.
#'
#' @param row A numeric value, span or sequence specifying the row position of the object.
#' @param col A numeric value, span or sequence specifying the row position of the object.
#' @param height A numeric value specifying the height of the object. Default is 1.
#' @param width A numeric value specifying the width of the object. Default is 1.
#'
#' @return An instance of the gridifyObject class.
#'
#' @seealso [gridifyLayout()]
#' @export
#' @examples
#' object <- gridifyObject(row = 1, col = 1, height = 1, width = 1)
gridifyObject <- function(row, col, height = 1, width = 1) {
  new("gridifyObject", row = row, col = col, height = height, width = width)
}

#' gridifyClass class
#'
#' Class for creating a gridify object.
#'
#' @slot object A grob like object.
#' @slot layout A gridifyLayout object.
#' @slot elements A list of text elements, calls to `set_cell()`.
#' @exportClass gridifyClass
setClass(
  "gridifyClass",
  representation(
    object = "ANY",
    layout = "gridifyLayout",
    elements = "list"
  )
)

setValidity("gridifyClass", function(object) {
  elem_diff <- setdiff(names(object@elements), names(object@layout@cells@cells))
  if ((length(object@elements) > 0) && (length(elem_diff) > 0)) {
    stop(
      sprintf(
        "\nCell value(s) listed in elements argument not valid:\n%s \n\nHere is a list of valid cells:\n%s ",
        paste0(elem_diff, collapse = "\n"),
        paste0(names(object@layout@cells@cells), collapse = "\n")
      )
    )
  }
  TRUE
})

#' Create a gridify object
#'
#' This function creates a gridify object, which represents an object with a
#' specific layout and text elements around the output.
#' The object can be a grob, ggplot2, gt, flextable, formula object. The layout can be a gridifyLayout object or
#' a function that returns a gridifyLayout object.
#'
#' @param object A grob or ggplot2, gt, flextable, formula object. Default is `grid::nullGrob()`.
#' @param layout A gridifyLayout object or a function that returns a gridifyLayout object.
#' You can use predefined layouts; the `get_layouts()` function prints names of available layouts.
#' You can create your own layout, please read `vignette("create_custom_layout", package = "gridify")`
#' for more information.
#' @param elements A list of text elements to fill the cells in the layout.
#' Useful only in specific situations, please consider using `set_cell` method to set text elements around the output.
#' Please note the elements list has to have a specific structure, please see the example.
#' @param ... Additional arguments.
#'
#' @details
#' The elements argument is a list of elements to fill the cells, it can be used
#' instead of or in conjunction with `set_cell`.
#' Please access the vignettes for more information about gridify.
#'
#' @seealso [set_cell()], [show_layout()], [print,gridifyClass-method], [show,gridifyClass-method]
#'
#' @return A gridifyClass object.
#'
#' @note
#' When setting your text within the `elements` argument, you can add new lines by using the newline character, `\n`.
#' The addition of `\n` may require setting a smaller `lineheight` argument in the `grid::gpar`.
#' For all layouts with the default `scales = "fixed"`, the layout will automatically adjust to fit the new lines,
#' ensuring no elements overlap.
#'
#' @export
#' @examples
#' library(magrittr)
#' object <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
#'   ggplot2::geom_point()
#' gridify(
#'   object = object,
#'   layout = simple_layout()
#' ) %>%
#'   set_cell("title", "My Title", gpar = grid::gpar(fontsize = 30)) %>%
#'   set_cell("footer", "My Footer", gpar = grid::gpar(fontsize = 10))
#'
#' gridify(
#'   gt::gt(head(mtcars)),
#'   layout = complex_layout(scales = "fixed")
#' ) %>%
#'   set_cell("header_left", "Left Header") %>%
#'   set_cell("header_middle", "Middle Header") %>%
#'   set_cell("header_right", "Right Header") %>%
#'   set_cell("title", "Title") %>%
#'   set_cell("subtitle", "Subtitle") %>%
#'   set_cell("note", "Note") %>%
#'   set_cell("footer_left", "Left Footer") %>%
#'   set_cell("footer_middle", "Middle Footer") %>%
#'   set_cell("footer_right", "Right Footer")
#'
#' # We encourage usage of set_cell but you can also use the elements argument
#' # to set text elements around the output.
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = simple_layout(),
#'   elements = list(
#'     title = list(text = "My Title", gpar = grid::gpar(fontsize = 30)),
#'     footer = list(text = "My Footer", gpar = grid::gpar(fontsize = 10))
#'   )
#' )
gridify <- function(
  object = grid::nullGrob(),
  layout,
  elements = list(),
  ...
) {
  # Check the classes of the inputs
  accepted_classes <- c("grob", "ggplot", "flextable", "gt_tbl", "formula")
  if (!(inherits(object, accepted_classes))) {
    stop(sprintf(
      "object argument of gridify has to be one of %s class.",
      paste(accepted_classes, collapse = ", ")
    ))
  }

  if (!(inherits(layout, "gridifyLayout") || is.function(layout))) {
    stop("layout argument of gridify has to be of gridifyLayout class.")
  }
  if (!is.list(elements)) {
    stop("elements argument of gridify has to be a list.")
  }

  if (is.function(layout)) {
    layout <- layout()
    if (!inherits(layout, "gridifyLayout")) {
      stop("layout argument function must result in a gridifyLayout class.")
    }
  }

  if (inherits(object, "ggplot")) {
    if (requireNamespace("ggplot2")) {
      object <- ggplot2::ggplotGrob(object)
    } else {
      stop("Please install ggplot2 to use it in gridify.")
    }
  }

  if (inherits(object, "flextable")) {
    if (
      requireNamespace("flextable") &&
        (utils::packageVersion("flextable") >= "0.8.0")
    ) {
      object <- flextable::gen_grob(object)
    } else {
      stop("Please install flextable >= 0.8.0 to use it in gridify, as it depends on flextable::gen_grob.")
    }
  }

  if (inherits(object, "gt_tbl")) {
    if (requireNamespace("gt") && (utils::packageVersion("gt") >= "0.11.0")) {
      object <- gt::as_gtable(object)
    } else {
      stop("Please install gt >= 0.11.0 to use it in gridify, as it depends on gt::as_gtable.")
    }
  }

  if (inherits(object, "formula")) {
    if (requireNamespace("gridGraphics")) {
      object_expr <- object[[2]]
      object <- grid::grid.grabExpr(
        gridGraphics::grid.echo(function() eval(object_expr))
      )
    } else {
      stop("Please install gridGraphics to use it in gridify.")
    }
  }

  # Create a new gridify object
  new(
    "gridifyClass",
    object = object,
    layout = layout,
    elements = if (length(elements)) elements else list()
  )
}
