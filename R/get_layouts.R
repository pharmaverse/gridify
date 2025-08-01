#' Get the gridify layouts
#'
#' Lists out all the layout functions exported from the gridify package.
#'
#' @return A vector listing out the names of the layout functions from the gridify package.
#'
#' @seealso [complex_layout()], [simple_layout()], [pharma_layout_base()],
#' [pharma_layout_A4()], [pharma_layout_letter()]
#' @export
#' @examples
#' get_layouts()
get_layouts <- function() {
  c("complex_layout", "simple_layout", "pharma_layout_base", "pharma_layout_A4", "pharma_layout_letter")
}
