#' Simple Layout for a gridify object
#'
#' Creates a simple layout only containing two text element cells: a title and a footer.
#'
#' @name simple_layout
#' @param margin A unit object specifying the margins around the output. Default is 10% of the output area on all sides.
#' @param global_gpar A gpar object specifying the global graphical parameters.
#' Must be the result of a call to `grid::gpar()`.
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
#' @details The layout consists of three rows, one each for the title, output, and footer.\cr
#' The heights of the rows in simple_layout with `"free"` scales are 15%, 70% and 15% of the area respectively.\cr
#' The heights of the rows in simple_layout with `"fixed"` scales are adjusted n number of lines for
#' all text elements around the output
#'  and the rest of the area taken up by the output.\cr
#' Please note that as output space is reduced, all text elements around the output retain their
#' space which makes the output appear smaller.
#'
#' @return A gridifyLayout object.
#' @importFrom methods is new
#' @examples
#' simple_layout()
#'
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#'
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = simple_layout()
#' ) %>%
#'   set_cell("title", "TITLE") %>%
#'   set_cell("footer", "FOOTER")
#'
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = simple_layout(
#'     margin = grid::unit(c(5, 2, 2, 2), "cm"),
#'     global_gpar = grid::gpar(fontsize = 20, col = "blue")
#'   )
#' ) %>%
#'   set_cell("title", "TITLE") %>%
#'   set_cell("footer", "FOOTER")
#'
#' gridify(
#'   object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
#'     ggplot2::geom_line(),
#'   layout = simple_layout()
#' ) %>%
#'   set_cell("title", "TITLE\nSUBTITLE", x = 0.7, gpar = grid::gpar(fontsize = 12)) %>%
#'   set_cell("footer", "FOOTER", x = 0.5, y = 0.5, gpar = grid::gpar())

#' @inherit layout_issue note
#' @rdname simple_layout
#' @export
simple_layout <- function(
  margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
  global_gpar = grid::gpar(),
  background = grid::get.gpar()$fill,
  scales = c("fixed", "free")
) {
  scales <- match.arg(scales, c("fixed", "free"))

  heights <- if (scales == "free") {
    grid::unit(c(0.15, 0.7, 0.15), "npc")
  } else {
    grid::unit(c(0, 1, 0), c("lines", "null", "lines"))
  }

  gridifyLayout(
    nrow = 3L,
    ncol = 1L,
    heights = heights,
    widths = grid::unit(1, "npc"),
    margin = margin,
    global_gpar = global_gpar,
    background = background,
    adjust_height = TRUE,
    object = gridifyObject(row = 2, col = 1),
    cells = gridifyCells(
      title = gridifyCell(row = 1, col = 1),
      footer = gridifyCell(row = 3, col = 1)
    )
  )
}
