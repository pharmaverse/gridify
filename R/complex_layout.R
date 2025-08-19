#' Complex Layout for a gridify object
#'
#' This function creates a complex layout for a gridify object.
#' The layout consists of six rows and three columns for headers, titles,
#' notes and footnotes around the output.
#'
#' @name complex_layout
#' @param margin A unit object specifying the margins around the output. Default is 10% of the output area on all sides.
#' @param global_gpar A gpar object specifying the global graphical parameters.
#'  Must be the result of a call to `grid::gpar()`.
#' @param background A string specifying the background fill colour.
#' Default `grid::get.gpar()$fill` for a white background.
#' @param scales A string, either `"free"` or `"fixed"`.
#' By default, `"fixed"` ensures that text elements (titles, footers, etc.)
#' retain a static height, preventing text overlap while maintaining a
#' structured layout. However, this may result in different height proportions
#' between the text elements and the output.
#'
#' The `"free"` option makes the row heights proportional,
#' allowing them to scale dynamically based on the overall output size.
#' This ensures that the text elements and the output maintain relative proportions.
#'
#' @details The layout consists of six rows for headers, titles, object (figure or table), notes, and footnotes.
#' The object is placed in the fourth row.\cr
#' - With `"free"` scales, the row heights are 5%, 5%, 5%, 70%, 5%, and 10% of
#' the area, respectively.
#' - With `"fixed"` scales, the row heights are adjusted by the number of lines for all text elements around the object,
#' with the remaining area occupied by the object.
#' Note that reducing the output space will retain the space for all text elements, making the object appear smaller.
#'
#' @return A gridifyLayout object.
#'
#' @examples
#' complex_layout()
#'
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#'
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = complex_layout()
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
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = complex_layout(margin = grid::unit(c(t = 0.2, r = 0.2, b = 0.2, l = 0.2), units = "npc"))
#' ) %>%
#'   set_cell("header_left", "Left Header") %>%
#'   set_cell("header_right", "Right Header") %>%
#'   set_cell("title", "Title") %>%
#'   set_cell("note", "Note") %>%
#'   set_cell("footer_left", "Left Footer")
#'
#' gridify(
#'   object = gt::gt(head(mtcars)),
#'   layout = complex_layout(
#'     margin = grid::unit(c(t = 0.2, r = 0.2, b = 0.2, l = 0.2), units = "npc"),
#'     global_gpar = grid::gpar(col = "blue", fontsize = 18)
#'   )
#' ) %>%
#'   set_cell("header_left", "Left Header") %>%
#'   set_cell("header_right", "Right Header") %>%
#'   set_cell("title", "Title") %>%
#'   set_cell("note", "Note") %>%
#'   set_cell("footer_left", "Left Footer")
#' @inherit layout_issue note
#' @rdname complex_layout
#' @export
complex_layout <- function(
  margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
  global_gpar = grid::gpar(),
  background = grid::get.gpar()$fill,
  scales = c("fixed", "free")
) {
  scales <- match.arg(scales, c("fixed", "free"))

  heights <- if (scales == "free") {
    grid::unit(c(0.05, 0.05, 0.05, 0.7, 0.05, 0.1), "npc")
  } else {
    grid::unit(
      c(0, 0, 0, 1, 0, 0),
      c("lines", "lines", "lines", "null", "lines", "lines")
    )
  }

  gridifyLayout(
    nrow = 6L,
    ncol = 3L,
    heights = heights,
    widths = grid::unit(rep(1, 3) / 3, units = "npc"),
    global_gpar = global_gpar,
    background = background,
    margin = margin,
    adjust_height = TRUE,
    object = gridifyObject(row = 4, col = c(1, 3)),
    cells = gridifyCells(
      header_left = gridifyCell(row = 1, col = 1),
      header_middle = gridifyCell(row = 1, col = 2),
      header_right = gridifyCell(row = 1, col = 3),
      title = gridifyCell(row = 2, col = c(1, 3)),
      subtitle = gridifyCell(row = 3, col = c(1, 3)),
      note = gridifyCell(row = 5, col = c(1, 3)),
      footer_left = gridifyCell(row = 6, col = 1),
      footer_middle = gridifyCell(row = 6, col = 2),
      footer_right = gridifyCell(row = 6, col = 3)
    )
  )
}
