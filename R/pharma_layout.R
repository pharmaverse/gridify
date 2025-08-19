#' Pharma Layouts
#'
#' The `pharma_layout` functions define structured layouts for positioning text
#' elements (titles, subtitles, footnotes, captions, etc.) around the outputs.
#' These layouts ensure consistency in pharmaceutical reporting across different
#' output formats, including A4 and letter paper sizes.
#'
#' @section Available Layouts:
#' - `pharma_layout_base()`: The base function for pharma layouts.
#' - `pharma_layout_A4()`: Layout specifically designed for A4 paper size.
#' - `pharma_layout_letter()`: Layout specifically designed for letter paper size.
#'
#' @inherit layout_issue note
#' @seealso [pharma_layout_base()], [pharma_layout_A4()], [pharma_layout_letter()]
#' @name pharma_layout
NULL

#' Base Function for Pharma Layouts
#'
#' This function sets up the general structure for positioning text
#' elements for pharma layouts.
#' It defines the layout with specified margins, global graphical parameters, and height adjustment.
#' The layout includes cells for headers, titles, footers, and optional elements like watermarks.
#'
#' This function is primarily used internally by other layout functions such as `pharma_layout_A4()` and
#' `pharma_layout_letter()` to create specific layouts.
#'
#' @param margin A `grid::unit` object defining the margins of the layout (top, right, bottom, left) in inches.
#' Default is `grid::unit(c(1, 1, 1, 1), "inches")`.
#' @param global_gpar A list specifying global graphical parameters to change in the layout.
#'  Default is NULL,
#'  however the defaults in the layout are: `fontfamily = "Serif", fontsize = 9 and lineheight = 0.95`,
#'  which can be overwritten alongside other graphical parameters found by `grid::get.gpar()`.
#' @param background A string specifying the background fill colour.
#' Default `grid::get.gpar()$fill` for a white background.
#' @param adjust_height A logical value indicating whether to adjust the height of the layout. Default is `TRUE`.
#'
#' @return A `gridifyLayout` object that defines the general structure and parameters for a pharma layout.
#'
#' @examples
#' # Create a general pharma layout with default settings
#' pharma_layout_base()
#'
#' library(magrittr)
#' # Customize margins and global graphical parameters and fill all cells
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = pharma_layout_base(
#'     margin = grid::unit(c(0.5, 0.5, 0.5, 0.5), "inches"),
#'     global_gpar = list(col = "blue", fontsize = 10)
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
#' @inherit layout_issue note
#'
#' @seealso [pharma_layout], [pharma_layout_A4()], [pharma_layout_letter()]
#' @rdname pharma_layout_base
#' @export
pharma_layout_base <- function(
  margin = grid::unit(c(t = 1, r = 1, b = 1, l = 1), units = "inches"),
  global_gpar = NULL,
  background = grid::get.gpar()$fill,
  adjust_height = TRUE
) {
  default_gpar <- list(fontfamily = "serif", fontsize = 9, lineheight = 0.95)
  global_gpar <- if (!is.null(global_gpar)) {
    utils::modifyList(default_gpar, global_gpar)
  } else {
    default_gpar
  }

  base_options <- grid::get.gpar()
  global_gpar <- utils::modifyList(base_options, global_gpar)

  gridifyLayout(
    nrow = 14L,
    ncol = 3L,
    heights = grid::unit(
      c(rep(1, 6), 0, 0, rep(1, 4), 0, 1),
      c(rep("lines", 9), "null", rep("lines", 4))
    ),
    widths = grid::unit(rep(1, 3) / 3, units = "npc"),
    global_gpar = global_gpar,
    background = background,
    margin = margin,
    adjust_height = adjust_height,
    object = gridifyObject(row = 10, col = c(1, 3)),
    cells = gridifyCells(
      header_left_1 = gridifyCell(row = 1, col = 1, x = 0, hjust = 0),
      header_left_2 = gridifyCell(row = 2, col = 1, x = 0, hjust = 0),
      header_left_3 = gridifyCell(row = 3, col = 1, x = 0, hjust = 0),
      header_right_1 = gridifyCell(
        row = 1,
        col = 3,
        text = "CONFIDENTIAL",
        x = 1,
        hjust = 1
      ),
      header_right_2 = gridifyCell(row = 2, col = 3, x = 1, hjust = 1),
      header_right_3 = gridifyCell(row = 3, col = 3, x = 1, hjust = 1),
      output_num = gridifyCell(row = 4, col = 2),
      title_1 = gridifyCell(row = 5, col = 2),
      title_2 = gridifyCell(row = 6, col = 2),
      title_3 = gridifyCell(row = 7, col = 2),
      by_line = gridifyCell(row = 8:9, col = c(1, 3), x = 0, hjust = 0),
      note = gridifyCell(row = 11, col = c(1, 3), mch = 100, x = 0, hjust = 0),
      references = gridifyCell(row = 13, col = 1, x = 0, hjust = 0),
      footer_left = gridifyCell(row = 14, col = 1, x = 0, hjust = 0),
      footer_right = gridifyCell(row = 14, col = 3, x = 1, hjust = 1),
      watermark = gridifyCell(
        row = 10,
        col = 2,
        x = 0.5,
        y = 0.5,
        rot = 45,
        gpar = grid::gpar(fontsize = 80, alpha = 0.3)
      )
    )
  )
}
#' Pharma Layout (A4) for a gridify object
#'
#' This function sets up the general structure for positioning the text
#' elements for pharma layouts using the A4 paper size.
#'
#' @param global_gpar A list specifying global graphical parameters to change in the layout.
#'  Default is NULL, however the defaults in the layout, inherited from `pharma_layout_base()`,
#'  are: `fontfamily = "Serif", fontsize = 9 and lineheight = 0.95`,
#'  which can be overwritten alongside other graphical parameters found by `grid::get.gpar()`.
#' @param background A character string specifying the background fill colour.
#' Default `grid::get.gpar()$fill` for a white background.
#' @details
#' The margins for the A4 layout are:
#' * top = 1 inch
#' * right = 1.69 inches
#' * bottom = 1 inch
#' * left = 1 inch
#'
#' The `pharma_layout_base()` function is used to set up the general layout structure,
#' with these specific margins applied for the A4 format.
#'
#' @return A `gridifyLayout` object with the structure defined for A4 paper size.
#'
#' @examples
#' pharma_layout_A4()
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#' # Example with all cells filled out
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = pharma_layout_A4()
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
#' @inherit layout_issue note
#'
#' @seealso [pharma_layout], [pharma_layout_base()], [pharma_layout_letter()]
#' @rdname pharma_layout_A4
#' @export
pharma_layout_A4 <- function(
  global_gpar = NULL,
  background = grid::get.gpar()$fill
) {
  pharma_layout_base(
    global_gpar = global_gpar,
    background = background,
    margin = grid::unit(c(t = 1, r = 1.69, b = 1, l = 1), units = "inches")
  )
}

#' Pharma Layout (Letter) for a gridify object
#'
#' This function sets up the general structure for positioning the text
#' elements for pharma layouts using the letter paper size.
#'
#' @param global_gpar A list specifying global graphical parameters to change in the layout.
#'  Default is NULL, however the defaults in the layout, inherited from `pharma_layout_base()`,
#'  are: `fontfamily = "Serif", fontsize = 9 and lineheight = 0.95`,
#'  which can be overwritten alongside other graphical parameters found by `grid::get.gpar()`.
#' @param background A character string specifying the background fill colour.
#' Default `grid::get.gpar()$fill` for a white background.
#' @details
#' The margins for the letter layout are:
#' * top = 1 inch
#' * right = 1 inch
#' * bottom = 1.23 inches
#' * left = 1 inch
#'
#' The `pharma_layout_base()` function is used to set up the general layout structure,
#' with these specific margins applied for the letter format.
#'
#' @return A `gridifyLayout` object with the structure defined for letter paper size.
#'
#' @examples
#' pharma_layout_letter()
#'
#' library(magrittr)
#' # Example with all cells filled out
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = pharma_layout_letter()
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
#' @inherit layout_issue note
#'
#' @seealso [pharma_layout], [pharma_layout_base()], [pharma_layout_A4()]
#' @rdname pharma_layout_letter
#' @export
pharma_layout_letter <- function(
  global_gpar = NULL,
  background = grid::get.gpar()$fill
) {
  pharma_layout_base(
    global_gpar = global_gpar,
    background = background,
    margin = grid::unit(c(t = 1, r = 1, b = 1.23, l = 1), units = "inches")
  )
}
