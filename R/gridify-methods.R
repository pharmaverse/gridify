#' Add text elements to a gridify cell
#'
#' This function sets a text element for a specific cell in a gridify object.
#' The element can be positioned and rotated as desired, and its graphical parameters can be customized.
#'
#' @param object A gridifyClass object.
#'  (See note)
#' @param cell A single character string specifying the name of the cell.
#' @param text A single character string specifying the text of the element.
#' When setting your string within the `text` argument, you can add new lines by using the newline character, `\n`.
#' @param mch A positive numeric value specifying the maximum number of characters per line.
#' The functionality is based on the `strwrap()` function.
#' By default, it avoids breaking up words and only splits lines when specified.
#' @param x A numeric value specifying the x (horizontal) location of the text element in the cell.
#' Takes values between 0 and 1; 0 places the text element at the left
#' side of the cell and 1 at the right side.
#' @param y A numeric value specifying the y (vertical) location of the text element in the cell.
#' Takes values between 0 and 1; 0 places the text element at the bottom
#' of the cell and 1 at the top.
#' @param hjust A numeric value specifying which part of the text element lines up with the x value.
#' Adjusting this value changes how the text element is positioned horizontally
#' relative to the x coordinate specified before. Takes values between 0 and 1; 0 aligns the left side of the text
#' element with the x coordinate and 1 aligns the right side.
#' @param vjust A numeric value specifying which part of the text element lines up with the y value.
#' Adjusting this value changes how the text element is positioned vertically
#' relative to the y coordinate specified before. Takes values between 0 and 1; 0 aligns the bottom of the text element
#' with the y coordinate and 1 aligns the top.
#' @param rot A numeric value specifying the rotation of the text element anticlockwise from the x-axis.
#' @param gpar A `grid::gpar()` object specifying the graphical parameters of the text element.
#' @param ... Additional arguments.
#'
#' @seealso [gridify()]
#' @return The gridifyClass object with the added text element.
#'
#' @details
#' `set_cell()` can also make minor adjustments to the positioning of the text elements in the layout.
#'
#' If the existing layouts generally meet your needs and you only require additional lines in certain cells,
#' there is no need to create a new layout. By using the newline character, `\n`, within your text,
#' you can add as many new lines as desired. For all layouts with the default `scales = "fixed"`,
#' the layout will automatically adjust to fit the new lines, ensuring no elements overlap.
#'
#' For applying more substantial changes to a layout or when applying adjustments across multiple objects
#' and projects, it is recommended to create a custom layout instead. This will promote
#' reproducibility and consistency across projects. See `vignette("create_custom_layout", package = "gridify")`
#' for more information on how to create a custom layout.
#'
#' @note
#' The `object` argument has to be passed directly only when adding `set_cell()` after a `gridify` object
#' has already been defined. We do NOT need to pass the `object` directly when using pipes. See first example.
#'
#' @export
#' @name set_cell
#' @examples
#' # using set_cell() without the pipe operator
#' object <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'   ggplot2::geom_line()
#'
#' g <- gridify(object = object, layout = simple_layout())
#' g <- set_cell(g, "title", "TITLE")
#' g
#'
#' # using set_cell() with the pipe operator
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#'
#' gridify(object = object, layout = simple_layout()) %>%
#'   set_cell("title", "TITLE")
#'
#' # using multiple lines in set_cell()
#' gridify(object, layout = simple_layout()) %>%
#'   set_cell(cell = "title", text = "THIS IS THE MAIN TITLE\nA Second Title\nSubtitle") %>%
#'   set_cell(
#'     cell = "footer", text = "This is a footer.\nWe can have multiple lines here as well.",
#'     x = 0, hjust = 0
#'   )
#'
#' # using mch in set_cell()
#' long_footer_string <- paste0(
#'   "This is a footer. We can have a long description here.",
#'   "We can have another long description here.",
#'   "We can have another long description here."
#' )
#' gridify(object, layout = simple_layout()) %>%
#'   set_cell(
#'     cell = "footer", long_footer_string, mch = 60, x = 0, hjust = 0
#'   )
#'
#' # using the location and alignment arguments
#' # the left side of the text is on the left side of the cell
#' gridify(object = object, layout = simple_layout()) %>%
#'   set_cell("title", "TITLE", x = 0, hjust = 0)
#'
#' # the right side of the text is on the right side of the cell
#' gridify(object = object, layout = simple_layout()) %>%
#'   set_cell("title", "TITLE", x = 1, hjust = 1)
#'
#' # the right side of the text is 30% from the right side of the cell
#' gridify(object = object, layout = simple_layout()) %>%
#'   set_cell("title", "TITLE", x = 0.7, hjust = 1)
#'
#' # using the rotation argument
#' gridify(object = object, layout = simple_layout()) %>%
#'   set_cell("title", "TITLE", x = 0.7, rot = 45)
#'
#' # using the graphical parameters argument
#' gridify(object = object, layout = simple_layout()) %>%
#'   set_cell("title", "TITLE", x = 0.7, rot = 45, gpar = grid::gpar(fontsize = 20)) %>%
#'   set_cell("footer", "FOOTER", x = 0.2, y = 1, gpar = grid::gpar(col = "blue"))
setGeneric(
  "set_cell",
  function(
    object,
    cell,
    text,
    mch = NULL,
    x = NULL,
    y = NULL,
    hjust = NULL,
    vjust = NULL,
    rot = NULL,
    gpar = NULL,
    ...
  ) {
    if (!inherits(object, "gridifyClass")) {
      stop("The first argument in `set_cell` should be a gridifyClass object.")
    }
    standardGeneric("set_cell")
  }
)

#' @rdname set_cell
setMethod(
  "set_cell",
  "gridifyClass",
  function(
    object,
    cell,
    text,
    mch = NULL,
    x = NULL,
    y = NULL,
    hjust = NULL,
    vjust = NULL,
    rot = NULL,
    gpar = NULL,
    ...
  ) {
    # Add the text elements to the elements list
    # Validate cell name
    if (!(inherits(cell, "character") && length(cell) == 1)) {
      stop("The cell argument is not a character string")
    } else if (!(cell %in% names(object@layout@cells@cells))) {
      stop(
        paste0(
          "\nCell value used is not valid, here is a list of valid cells: \n",
          paste0(names(object@layout@cells@cells), collapse = "\n")
        )
      )
    }

    # Validate cell text
    if (inherits(text, "character") && length(text) > 1) {
      stop(
        "The text argument is not a character string, please use '\\n' to concatenate values."
      )
    }

    if (!(inherits(text, "character") && length(text) == 1)) {
      stop("The text argument is not a character string.")
    }

    if (!(is.null(mch) || (inherits(mch, "numeric") && length(mch) == 1) && mch > 0)) {
      stop("The mch argument is not a positive numeric value.")
    }

    # Validate numeric values
    if (!(is.null(x) || (inherits(x, "numeric") && length(x) == 1))) {
      stop("The x argument is not a numeric value.")
    }

    if (!(is.null(y) || (inherits(y, "numeric") && length(y) == 1))) {
      stop("The y argument is not a numeric value.")
    }

    if (
      !(is.null(hjust) || (inherits(hjust, "numeric") && length(hjust) == 1))
    ) {
      stop("The hjust argument is not a numeric value.")
    }

    if (
      !(is.null(vjust) || (inherits(vjust, "numeric") && length(vjust) == 1))
    ) {
      stop("The vjust argument is not a numeric value.")
    }

    if (!(is.null(rot) || (inherits(rot, "numeric") && length(rot) == 1))) {
      stop("The rot argument is not a numeric value.")
    }

    if (!(is.null(gpar) || inherits(gpar, "gpar"))) {
      stop("The gpar argument is not a gpar instance.")
    }

    object@elements[[cell]] <- list(
      text = text,
      mch = mch,
      x = x,
      y = y,
      hjust = hjust,
      vjust = vjust,
      rot = rot,
      gpar = gpar
    )
    object
  }
)

#' Print method for gridifyClass
#'
#' Method for printing a gridifyClass object.
#' Prevents the `show` method from being triggered.
#'
#' @param x A gridifyClass object.
#' @param ... Additional arguments. Not yet in use.
#'
#' @return Invisibly a grid call used to draw the object.
#'
#' @seealso [gridify()], [set_cell()]
#' @export
#' @examples
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#'
#' g <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = simple_layout()
#' ) %>%
#'   set_cell("title", "TITLE")
#'
#' print(g)
#'
#' # grid call is returned when printed to a variable
#' gg <- print(g)
#' # unevaluated grid code
#' gg
#' # evaluate the code
#' grid::grid.draw(eval(gg, envir = attr(gg, "env")))
#' # or
#' OBJECT <- attr(gg, "env")[["OBJECT"]]
#' grid::grid.draw(eval(gg))
setMethod("print", "gridifyClass", function(x, ...) {
  grid::grid.newpage()

  pp_list <- list(
    substitute(
      grid::grobTree(
        grid::editGrob(
          OBJECT,
          vp = grid::viewport(
            height = grid::unit.pmax(
              grid::unit(height_value, "npc"),
              grid::unit(1, "inch")
            ),
            width = grid::unit.pmax(
              grid::unit(width_value, "npc"),
              grid::unit(1, "inch")
            )
          )
        ),
        vp = grid::viewport(
          layout.pos.row = nrow_value,
          layout.pos.col = ncol_value
        )
      ),
      env = list(
        height_value = x@layout@object@height,
        width_value = x@layout@object@width,
        nrow_value = x@layout@object@row,
        ncol_value = x@layout@object@col
      )
    )
  )

  # Initialize a vector to store the maximum height for each row
  # Needed when adjust_height is TRUE
  max_heights <- numeric(x@layout@nrow)

  # Print each element and calculate heights if adjust_height is TRUE
  for (cell in names(x@layout@cells@cells)) {
    # Get the elements and its position
    elem <- x@elements[[cell]]
    cell_info <- x@layout@cells@cells[[cell]]
    # Skip the elements if there is noting to add
    if (is.null(elem) && length(cell_info@text) == 0) {
      next
    }

    # pass the fontsize on local level if needed
    global_fontsize <- x@layout@global_gpar$fontsize
    default_fontsize <- cell_info@gpar$fontsize
    if (inherits(elem$gpar, "gpar")) {
      elem$gpar$fontsize <- c(
        elem$gpar$fontsize,
        default_fontsize,
        global_fontsize
      )[1]
    } else if (!is.null(global_fontsize) || !is.null(default_fontsize)) {
      elem$gpar <- grid::gpar(
        fontsize = c(default_fontsize, global_fontsize)[1]
      )
    }

    label <- c(elem$text, cell_info@text)[1]
    mch <- c(elem$mch, cell_info@mch)[1]
    label_value <- if (length(mch) && !is.infinite(mch)) {
      paste(
        unlist(lapply(strsplit(label, "\n")[[1]], strwrap, width = mch)),
        collapse = "\n"
      )
    } else {
      label
    }

    tgrob <- substitute(
      grid::textGrob(
        label = label_value,
        x = x_value,
        y = y_value,
        hjust = hjust_value,
        vjust = vjust_value,
        rot = rot_value,
        gp = gp_value
      ),
      env = list(
        label_value = label_value,
        x_value = c(elem$x, cell_info@x, 0.5)[1],
        y_value = c(elem$y, cell_info@y, 0.5)[1],
        hjust_value = c(elem$hjust, cell_info@hjust, 0.5)[1],
        vjust_value = c(elem$vjust, cell_info@vjust, 0.5)[1],
        rot_value = c(elem$rot, cell_info@rot, 0)[1],
        gp_value = gpar_call(elem$gpar)
      )
    )

    pp_list <- c(
      pp_list,
      list(
        substitute(
          grid::grobTree(
            tgrob,
            gp = gp_value,
            vp = grid::viewport(
              layout.pos.row = row_value,
              layout.pos.col = col_value
            )
          ),
          env = list(
            tgrob = tgrob,
            gp_value = gpar_call(cell_info@gpar),
            row_value = cell_info@row,
            col_value = cell_info@col
          )
        )
      )
    )

    # Calculate the height of the textGrob when adjust_height is TRUE
    if (x@layout@adjust_height) {
      grob_height <- grid::convertHeight(
        grid::grobHeight(eval(tgrob)),
        "cm",
        valueOnly = TRUE
      )
      # Determine the rows the text elements around the output spans
      rows <- cell_info@row
      rows_span <- rows[1]:rows[length(rows)]
      # Update the maximum height for the rows spanned by the text elements
      max_heights[rows_span] <- pmax(
        max_heights[rows_span],
        grob_height,
        na.rm = TRUE
      )
    }
  }

  # Update the heights for each row in the layout when adjust_height is TRUE
  height_types <- grid_unit_type(x@layout@heights)
  supported_types <- c("cm", "inches", "mm", "lines")
  if (x@layout@adjust_height && any(height_types %in% supported_types)) {
    new_heights <- list()
    default_adjustment <- getOption("gridify.adjust_height.default", 0.25)
    line_adjustment <- getOption("gridify.adjust_height.line", 0.10)
    for (i in seq_along(max_heights)) {
      height_type <- height_types[[i]]
      if (
        x@layout@adjust_height &&
          height_type %in% supported_types &&
          !is.na(max_heights[i]) &&
          max_heights[i] > 0
      ) {
        adjustment <- if (height_type != "lines") {
          default_adjustment
        } else {
          line_adjustment
        }
        new_heights[[i]] <- grid::unit(max_heights[i] + adjustment, "cm")
      } else {
        new_heights[[i]] <- x@layout@heights[i]
      }
    }
    x@layout@heights <- do.call(grid::unit.c, new_heights)
  }

  margin1 <- x@layout@margin[1]
  margin2 <- x@layout@margin[2]
  margin3 <- x@layout@margin[3]
  margin4 <- x@layout@margin[4]

  result <- substitute(
    grid::gTree(
      children = grid::gList(
        background,
        grid::gTree(
          children = do.call(grid::gList, outputs_list),
          vp = grid::viewport(
            name = "lyt",
            x = margin4_val,
            y = margin3_val,
            just = c("left", "bottom"),
            width = grid::unit(1, "npc") - margin4_val - margin2_val,
            height = grid::unit(1, "npc") - margin1_val - margin3_val,
            gp = global_gpar,
            layout = grid::grid.layout(
              nrow = nrow_val,
              ncol = ncol_val,
              heights = heights_val,
              widths = widths_val
            )
          )
        )
      )
    ),
    env = list(
      margin1_val = as.call(c(
        quote(grid::unit),
        list(as.numeric(margin1), grid_unit_type(margin1))
      )),
      margin2_val = as.call(c(
        quote(grid::unit),
        list(as.numeric(margin2), grid_unit_type(margin2))
      )),
      margin3_val = as.call(c(
        quote(grid::unit),
        list(as.numeric(margin3), grid_unit_type(margin3))
      )),
      margin4_val = as.call(c(
        quote(grid::unit),
        list(as.numeric(margin4), grid_unit_type(margin4))
      )),
      nrow_val = x@layout@nrow,
      ncol_val = x@layout@ncol,
      heights_val = as.call(c(
        quote(grid::unit),
        list(
          round(as.numeric(x@layout@heights), 2),
          grid_unit_type(x@layout@heights)
        )
      )),
      widths_val = as.call(c(
        quote(grid::unit),
        list(
          round(as.numeric(x@layout@widths), 2),
          grid_unit_type(x@layout@widths)
        )
      )),
      outputs_list = as.call(c(quote(list), pp_list)),
      global_gpar = gpar_call(x@layout@global_gpar),
      background = substitute(
        grid::rectGrob(
          x = 0,
          y = 0,
          width = 1,
          height = 1,
          just = c("left", "bottom"),
          gp = grid::gpar(fill = fill_value, col = fill_value)
        ),
        env = list(fill_value = x@layout@background)
      )
    )
  )

  ee <- new.env()
  ee[["OBJECT"]] <- x@object

  # Draw the object
  grid::grid.draw(eval(result, ee))
  # Return invisibly grid call with environment
  invisible(structure(result, env = ee))
})

#' Show the cells in a gridify object or layout
#'
#' Method for showing the cells of a gridifyClass or gridifyLayout object.
#' It prints the names of the cells and for gridifyClass it indicates whether each cell is filled or empty.
#'
#' @param object A gridifyClass or gridifyLayout object.
#'
#' @return A print out of the available cells and for gridifyClass indicates whether each cell is filled or empty.
#'
#' @export
#' @name show_cells
#' @examples
#' show_cells(complex_layout())
#'
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#'
#' g <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = simple_layout()
#' ) %>%
#'   set_cell("title", "TITLE")
#'
#' show_cells(g)
#'
#' g <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = complex_layout()
#' ) %>%
#'   set_cell("header_left", "Left Header") %>%
#'   set_cell("header_right", "Right Header") %>%
#'   set_cell("title", "Title") %>%
#'   set_cell("note", "Note") %>%
#'   set_cell("footer_left", "Left Footer") %>%
#'   set_cell("footer_right", "Right Footer")
#'
#' show_cells(g)
setGeneric("show_cells", function(object) standardGeneric("show_cells"))

#' @rdname show_cells
setMethod("show_cells", "gridifyClass", function(object) {
  cat("Cells:\n")
  for (cell in names(object@layout@cells@cells)) {
    cell <- trimws(cell)
    if (
      !is.null(object@elements[[cell]]) ||
        length(object@layout@cells@cells[[cell]]@text) > 0
    ) {
      cat(sprintf(
        "  %s: %s\n",
        cell,
        ifelse(interactive(), coloured_print("filled", "green"), "filled")
      ))
    } else {
      cat(sprintf(
        "  %s: %s\n",
        cell,
        ifelse(interactive(), coloured_print("empty", "red"), "empty")
      ))
    }
  }
})

#' @rdname show_cells
setMethod("show_cells", "gridifyLayout", function(object) {
  cat("Cells:\n")
  for (cell in names(object@cells@cells)) {
    cat(paste0("  ", trimws(cell), "\n"))
  }
})

#' Show the layout specifications of a gridifyClass or gridifyLayout
#'
#' Method for showing the specifications of the layout in a gridifyClass or gridifyLayout object, including, but
#' not limited to:
#' * Layout dimensions
#' * Heights of rows
#' * Widths of columns
#' * Margins
#' * Graphical parameters defined in the layout.
#' * Default specs per cell.

#' @param object A gridifyClass or gridifyLayout object.
#'
#' @return A print out of the specifications of a gridifyClass or gridifyLayout object.
#'
#' @export
#' @name show_spec
#' @examples
#' show_spec(complex_layout())
#'
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#'
#' g <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = simple_layout()
#' ) %>%
#'   set_cell("title", "TITLE")
#'
#' show_spec(g)
#'
#' g <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = complex_layout()
#' ) %>%
#'   set_cell("header_left", "Left Header") %>%
#'   set_cell("header_right", "Right Header") %>%
#'   set_cell("title", "Title") %>%
#'   set_cell("note", "Note") %>%
#'   set_cell("footer_left", "Left Footer") %>%
#'   set_cell("footer_right", "Right Footer")
#'
#' show_spec(g)
setGeneric("show_spec", function(object) standardGeneric("show_spec"))

#' @rdname show_spec
setMethod("show_spec", "gridifyLayout", function(object) {
  # Show the dimensions of the layout
  cat("Layout dimensions:\n")
  cat(sprintf("  Number of rows: %s\n", object@nrow))
  cat(sprintf("  Number of columns: %s\n", object@ncol))

  heights <- object@heights
  widths <- object@widths
  object_row <- object@object@row
  object_col <- object@object@col

  cat("\nHeights of rows:\n")
  cat(
    sprintf(
      "  Row %d: %s %s\n",
      seq_along(heights),
      as.numeric(heights),
      grid_unit_type(heights)
    ),
    sep = ""
  )

  cat("\nWidths of columns:\n")
  cat(
    sprintf(
      "  Column %d: %s %s\n",
      seq_along(widths),
      as.numeric(widths),
      grid_unit_type(widths)
    ),
    sep = ""
  )

  # Show the position of the object
  cat("\nObject Position:\n")
  cat(sprintf(
    "  Row: %s\n",
    paste(unique(c(min(object_row), max(object_row))), collapse = "-")
  ))
  cat(sprintf(
    "  Col: %s\n",
    paste(unique(c(min(object_col), max(object_col))), collapse = "-")
  ))

  cat(sprintf("  Width: %s\n", object@object@width))
  cat(sprintf("  Height: %s\n", object@object@height))

  cat("\nObject Row Heights:\n")
  rows_span <- object_row[1]:object_row[length(object_row)]
  cat(
    sprintf(
      "  Row %s: %s %s\n",
      rows_span,
      as.numeric(heights[rows_span]),
      grid_unit_type(heights[rows_span])
    ),
    sep = ""
  )

  # Show the margin
  cat("\nMargin:\n")
  cat(
    "  Top:",
    object@margin[1],
    paste0(grid_unit_type(object@margin[1]), "\n")
  )
  cat(
    "  Right:",
    object@margin[2],
    paste0(grid_unit_type(object@margin[2]), "\n")
  )
  cat(
    "  Bottom:",
    object@margin[3],
    paste0(grid_unit_type(object@margin[3]), "\n")
  )
  cat(
    "  Left:",
    object@margin[4],
    paste0(grid_unit_type(object@margin[4]), "\n")
  )

  # Show the global graphical parameters
  cat("\nGlobal graphical parameters:\n")
  if (length(object@global_gpar) == 0) {
    cat("  Are not set\n")
  } else {
    cat(
      paste0(
        "  ",
        names(object@global_gpar),
        ": ",
        object@global_gpar,
        collapse = "\n"
      ),
      "\n"
    )
  }

  # Show background colour
  cat("\nBackground colour:\n")
  cat(paste0("  ", object@background, "\n"))
  # Show default cell info

  cat("\nDefault Cell Info:\n")
  for (cell in names(object@cells@cells)) {
    cat("  ", cell, ":\n    ", sep = "")
    cell_obj <- object@cells@cells[[cell]]
    for (layout_slot in methods::slotNames(cell_obj)) {
      cell_content <- methods::slot(cell_obj, layout_slot)

      if (layout_slot == "text") {
        if (length(cell_content) == 0) {
          methods::slot(cell_obj, layout_slot) <- "NULL"
        } else if (nchar(cell_content) >= 10) {
          methods::slot(cell_obj, layout_slot) <- paste0(
            substr(cell_content, 1, 10),
            "..."
          )
        }
      }

      if (layout_slot == "gpar") {
        gpar_arguments <- gpar_args(cell_obj@gpar)
        if (length(gpar_arguments)) {
          cat(
            "\n    gpar - ",
            paste(
              sprintf("%s:%s, ", names(gpar_arguments), gpar_arguments),
              collapse = ""
            ),
            sep = ""
          )
        }
      } else {
        cat(
          "",
          layout_slot,
          ":",
          paste(methods::slot(cell_obj, layout_slot), collapse = "-"),
          ", ",
          sep = ""
        )
      }
    }
    cat("\n")
  }
})

#' @rdname show_spec
setMethod("show_spec", "gridifyClass", function(object) {
  show_spec(object@layout)
})

#' Show the layout in a given gridify object or layout
#'
#' Method for showing the layout of a gridifyClass or gridifyLayout object. It prints the layout of the object,
#' including the number of rows and columns and the heights and widths of the rows and columns in the graphics device.
#'
#' @note When using `show_layout()`, not all lines are initially visible. Some lines may be assigned zero space and are
#' dynamically updated to have more space once the text is added.
#'
#' @param x A gridifyClass or gridifyLayout object.
#'
#' @return An object showing the layout, including the widths and heights of all the rows and columns.
#' @seealso [gridify()], [simple_layout()], [complex_layout()], [pharma_layout],
#' [pharma_layout_base()], [pharma_layout_A4()], [pharma_layout_letter()]
#' @export
#' @name show_layout
#' @examples
#' g <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = simple_layout()
#' )
#' show_layout(g)
#'
#' g <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = complex_layout()
#' )
#' show_layout(g)
#'
#' show_layout(simple_layout())
#' show_layout(complex_layout())
#'
#' # Example with a custom layout
#'
#' custom_layout <- gridifyLayout(
#'   nrow = 3L,
#'   ncol = 2L,
#'   heights = grid::unit(c(0.15, 0.7, 0.15), "npc"),
#'   widths = grid::unit(c(0.5, 0.5), "npc"),
#'   margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
#'   global_gpar = grid::gpar(),
#'   adjust_height = FALSE,
#'   object = gridifyObject(row = 2, col = 1),
#'   cells = gridifyCells(header = gridifyCell(
#'     row = 1,
#'     col = 1,
#'     x = 0.5,
#'     y = 0.5,
#'     hjust = 0.5,
#'     vjust = 0.5,
#'     rot = 0,
#'     gpar = grid::gpar()
#'   ), footer = gridifyCell(
#'     row = 2,
#'     col = 2,
#'     x = 0.5,
#'     y = 0.5,
#'     hjust = 0.5,
#'     vjust = 0.5,
#'     rot = 0,
#'     gpar = grid::gpar()
#'   ))
#' )
#'
#' show_layout(custom_layout)
#'
setGeneric("show_layout", function(x) standardGeneric("show_layout"))

#' @rdname show_layout
setMethod("show_layout", "gridifyClass", function(x) {
  grid::grid.show.layout(grid::grid.layout(
    nrow = x@layout@nrow,
    ncol = x@layout@ncol,
    heights = x@layout@heights,
    widths = x@layout@widths
  ))
})

#' @rdname show_layout
setMethod("show_layout", "gridifyLayout", function(x) {
  grid::grid.show.layout(grid::grid.layout(
    nrow = x@nrow,
    ncol = x@ncol,
    heights = x@heights,
    widths = x@widths
  ))
})

#' Show method for gridifyClass
#'
#' Method for showing a gridifyClass object.
#'
#' @param object A gridifyClass object.
#'
#' @return The object with all the titles, subtitles, footnotes, and other text
#' elements around the output is printed in the graphics device.
#' A list is also printed to the console containing:
#' * the dimensions of the layout
#' * where the object is located in the layout
#' * the size of the margin
#' * any global graphical parameters
#' * the list of elements cells and if they are filled or empty
#'
#' @importFrom methods show
#' @seealso [gridify()]
#' @export
#' @examples
#' g <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = complex_layout()
#' )
#' show(g)
setMethod("show", "gridifyClass", function(object) {
  cat("gridifyClass object\n")
  cat("---------------------\n")
  cat("Please run `show_spec(object)` or print the layout to get more specs.\n")

  cat("\n")

  # Show the text elements using the show_cells method
  show_cells(object)

  print(object)
})

#' Show method for gridifyLayout
#'
#' Method for showing a gridifyLayout object. It prints the names of the cells in the layout.
#'
#' @param object A gridifyLayout object.
#'
#' @return The list of cells defined in the layout.
#'
#' @importFrom methods show
#'
#' @seealso [gridifyLayout()]
#' @export
#' @examples
#' show(complex_layout())
#'
setMethod("show", "gridifyLayout", function(object) {
  cat("gridifyLayout object\n")
  cat("---------------------\n")

  show_spec(object)
  cat("\n")
})

#' Export gridify objects to a file
#'
#' @description
#' The `export_to()` function exports a `gridifyClass` object or a list of such objects to a specified file.
#' Supported formats include PDF, PNG, TIFF and JPEG.
#' For lists, if a single file name with a PDF file extension is provided,
#' the objects
#' are combined into a multi-page PDF; if a character vector with one file per object is provided,
#' each object is written to its corresponding file. It is not possible to create multi-page PNG or JPEG files.
#'
#' @param x A `gridifyClass` object or a list of `gridifyClass` objects.
#' @param to A character string (or vector) specifying the output file name(s).
#' The extension determines the output format.
#' @param device a function for graphics device.
#' By default a file name extension is used to choose a graphics device function. Default `NULL`
#' @param ... Additional arguments passed to the graphics device functions
#' (`pdf()`, `png()`, `tiff()`, `jpeg()` or your custom one).
#' Default width and height for each export type, respectively:
#'  * PDF: 11.69 inches x 8.27 inches
#'  * PNG: 600 px x 400 px
#'  * TIFF: 600 px x 400 px
#'  * JPEG: 600 px x 400 px
#'
#' @note `gridify` objects can be saved directly in `.Rmd` and `.Qmd` documents,
#' just like in the `gridify` package vignettes.
#'
#' **gt `pct()` issue**
#'
#' Using `pct()` to set the width of `gt` tables can be unreliable when exporting to PDF. It is recommended to use
#' `px()` to set the width in pixels instead.
#'
#' @details
#' For PDF export, a new device is opened, the grid is printed using the object's
#' custom print method, and then the device is closed.
#' For PNG and JPEG, the device is opened, a new grid page is started, the grid is
#' printed, and then the device is closed.
#'
#' When exporting a list of objects:
#' \itemize{
#'   \item If `to` is a single PDF file (length is 1), the function creates a multi-page PDF.
#'   \item If a vector of file names (one per object) is provided, each gridify object is
#'   written to its corresponding file.
#' }
#' @return No value is returned; the function is called for its side effect of writing output to a file.
#'
#' @examples
#' library(gridify)
#' library(magrittr)
#' library(ggplot2)
#'
#' # Create a gridify object using a ggplot and a custom layout:
#'
#' # Set text elements on various cells:
#' gridify_obj <- gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = pharma_layout_base(
#'     margin = grid::unit(c(0.5, 0.5, 0.5, 0.5), "inches"),
#'     global_gpar = grid::gpar(fontfamily = "serif", fontsize = 10)
#'   )
#' ) %>%
#'   set_cell("header_left_1", "My Company") %>%
#'   set_cell("header_left_2", "<PROJECT> / <INDICATION>") %>%
#'   set_cell("header_left_3", "<STUDY>") %>%
#'   set_cell("header_right_1", "CONFIDENTIAL") %>%
#'   set_cell("header_right_2", "<Draft or Final>") %>%
#'   set_cell("header_right_3", "Data Cut-off: YYYY-MM-DD") %>%
#'   set_cell("output_num", "<Output> xx.xx.xx") %>%
#'   set_cell("title_1", "<Title 1>") %>%
#'   set_cell("title_2", "<Title 2>") %>%
#'   set_cell("title_3", "<Optional Title 3>") %>%
#'   set_cell("by_line", "By: <GROUP>, <optionally: Demographic parameters>") %>%
#'   set_cell("note", "<Note or Footnotes>") %>%
#'   set_cell("references", "<References:>") %>%
#'   set_cell("footer_left", "Program: <PROGRAM NAME>, YYYY-MM-DD at HH:MM") %>%
#'   set_cell("footer_right", "Page xx of nn") %>%
#'   set_cell("watermark", "DRAFT")
#'
#' # Export a result to different file types
#'
#' # Different file export formats require specific capabilities in your R installation.
#' # Use capabilities() to check which formats are supported in your R build.
#'
#' # PNG
#' temp_png_default <- tempfile(fileext = ".png")
#' export_to(
#'   gridify_obj,
#'   to = temp_png_default
#' )
#'
#' temp_png_custom <- tempfile(fileext = ".png")
#' export_to(
#'   gridify_obj,
#'   to = temp_png_custom,
#'   width = 2400,
#'   height = 1800,
#'   res = 300
#' )
#'
#' # JPEG
#' temp_jpeg_default <- tempfile(fileext = ".jpeg")
#' export_to(
#'   gridify_obj,
#'   to = temp_jpeg_default
#' )
#'
#' temp_jpeg_custom <- tempfile(fileext = ".jpeg")
#' export_to(
#'   gridify_obj,
#'   to = temp_jpeg_custom,
#'   width = 2400,
#'   height = 1800,
#'   res = 300
#' )
#'
#' # TIFF
#' temp_tiff_default <- tempfile(fileext = ".tiff")
#' export_to(
#'   gridify_obj,
#'   to = temp_tiff_default
#' )
#'
#' temp_tiff_custom <- tempfile(fileext = ".tiff")
#' export_to(
#'   gridify_obj,
#'   to = temp_tiff_custom,
#'   width = 2400,
#'   height = 1800,
#'   res = 300
#' )
#'
#' # PDF
#' temp_pdf_A4 <- tempfile(fileext = ".pdf")
#' export_to(
#'   gridify_obj,
#'   to = temp_pdf_A4
#' )
#'
#' temp_pdf_A4long <- tempfile(fileext = ".pdf")
#' export_to(
#'   gridify_obj,
#'   to = temp_pdf_A4long,
#'   width = 8.3,
#'   height = 11.7
#' )
#'
#' # Use different pdf device - cairo_pdf
#' temp_pdf_A4long_cairo <- tempfile(fileext = ".pdf")
#' export_to(
#'   gridify_obj,
#'   to = temp_pdf_A4long_cairo,
#'   device = grDevices::cairo_pdf,
#'   width = 8.3,
#'   height = 11.7
#' )
#'
#' # Multiple Objects - a list
#'
#' gridify_list <- list(gridify_obj, gridify_obj)
#'
#' temp_pdf_multipageA4 <- tempfile(fileext = ".pdf")
#' export_to(
#'   gridify_list,
#'   to = temp_pdf_multipageA4
#' )
#'
#' temp_pdf_multipageA4long <- tempfile(fileext = ".pdf")
#' export_to(
#'   gridify_list,
#'   to = temp_pdf_multipageA4long,
#'   width = 8.3,
#'   height = 11.7
#' )
#'
#' temp_png_multi <- c(tempfile(fileext = ".png"), tempfile(fileext = ".png"))
#' export_to(
#'   gridify_list,
#'   to = temp_png_multi
#' )
#'
#' temp_png_multi_custom <- c(tempfile(fileext = ".png"), tempfile(fileext = ".png"))
#' export_to(
#'   gridify_list,
#'   to = temp_png_multi_custom,
#'   width = 800,
#'   height = 600,
#'   res = 96
#' )
#'
#' @export
setGeneric("export_to", function(x, to, device = NULL, ...) {
  standardGeneric("export_to")
})

#' @rdname export_to
#' @export
setMethod("export_to", "gridifyClass", function(x, to, device = NULL, ...) {
  if (!(length(to) == 1 && is.character(to))) {
    stop("`to` must be a single string (file path) for single gridify object.")
  }

  dir_name <- dirname(to)
  if (!(dir.exists(dir_name))) {
    stop(sprintf(
      "The directory `%s` specified by `to` does not exist.",
      dir_name
    ))
  }

  if (!(is.null(device) || is.function(device))) {
    stop("`device` must be a NULL or a graphics device function.")
  }

  ext <- tolower(tools::file_ext(to))
  accepted_ext <- c("png", "jpg", "jpeg", "pdf", "tiff", "tif")
  if (!all(ext %in% accepted_ext)) {
    stop(
      sprintf(
        "Accepted extensions are %s. For other extensions, please consider using Rmd or Qmd documents.",
        paste(accepted_ext, collapse = ", ")
      )
    )
  }

  user_args <- list(...)

  if (ext %in% c("pdf")) {
    default_args <- list(width = 11.69, height = 8.27)
    dev_args <- utils::modifyList(default_args, user_args)
    dev_args$file <- to

    if (is.null(device)) {
      device <- grDevices::pdf
    }

    do.call(device, dev_args)
    print(x)
    on.exit(grDevices::dev.off())
  } else if (ext %in% c("png", "jpeg", "jpg", "tiff", "tif")) {
    default_args <- list(width = 600, height = 400)
    dev_args <- utils::modifyList(default_args, user_args)
    dev_args$file <- to

    dev_func <- switch(
      ext,
      png = grDevices::png,
      jpeg = grDevices::jpeg,
      jpg = grDevices::jpeg,
      tiff = grDevices::tiff,
      tif = grDevices::tiff
    )

    if (is.null(device)) {
      device <- dev_func
    }
    do.call(device, dev_args)
    grid::grid.newpage()
    print(x)
    on.exit(grDevices::dev.off())
  }
})


#' @rdname export_to
#' @export
setMethod("export_to", "list", function(x, to, device = NULL, ...) {
  if (
    !all(vapply(x, function(elem) inherits(elem, "gridifyClass"), logical(1)))
  ) {
    stop("All elements of the list must be 'gridifyClass' objects.")
  }

  to_dirs <- dirname(to)
  dir_exists <- dir.exists(to_dirs)
  if (!all(dir_exists)) {
    stop(
      sprintf(
        "The directory `%s` specified by `to` does not exist.",
        paste(unique(to_dirs[!dir_exists]), collapse = ", ")
      )
    )
  }

  if (!(is.null(device) || is.function(device))) {
    stop("`device` must be a NULL or a graphics device function.")
  }

  ext <- unique(tolower(tools::file_ext(to)))
  accepted_ext <- c("png", "jpg", "jpeg", "pdf", "tiff", "tif")
  if (!all(ext %in% accepted_ext)) {
    stop(
      sprintf(
        "Accepted extensions are %s. Please consider using Rmd or Qmd documents.",
        paste(accepted_ext, collapse = ", ")
      )
    )
  }

  # Single output file or multiple?
  if (length(to) == 1) {
    if (ext == "pdf") {
      if (is.null(device)) {
        device <- grDevices::pdf
      }

      do.call(
        device,
        utils::modifyList(
          list(file = to, width = 11.69, height = 8.27, onefile = TRUE),
          list(...)
        )
      )
      on.exit(grDevices::dev.off(), add = TRUE)

      for (obj in x) {
        print(obj)
      }
    } else {
      stop(
        "For a list of gridify objects and a single file path, the `to` extension has to be pdf."
      )
    }
  } else if (length(to) == length(x)) {
    # Each plot goes to a separate file path in `to`
    for (i in seq_along(x)) {
      export_to(x[[i]], to[[i]], ...)
    }
  } else {
    stop(
      "`to` must be either a single pdf file path or a character vector matching the length of `x`."
    )
  }
})


#' @rdname export_to
#' @export
setMethod("export_to", "ANY", function(x, to, ...) {
  stop(
    "export_to is supported for gridifyClass or list of gridifyClass objects."
  )
})
