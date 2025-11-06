#' Split a data frame into pages for multi-page tables
#'
#' @description
#' A lightweight utility function to split a data frame into pages based on the number of rows per page.
#' This is useful when creating multi-page tables with `gridify`.
#'
#' @param data A data frame to split into pages.
#' @param rows_per_page Integer. The maximum number of rows per page.
#' @param fill_last_page Logical. Whether to fill the last page with empty rows to match `rows_per_page`.
#'   Default is `FALSE`. When `TRUE`, empty rows are added to the last page so all pages have
#'   the same number of rows, which helps with consistent vertical positioning.
#' @param page_col Character string. Name of the column to add that indicates page number.
#'   Default is `"page_number"`. Set to `NULL` to not add a page column.
#'
#' @return A list of data frames, one for each page. If `page_col` is not `NULL`, each data frame
#'   will include a column with the page number.
#'
#' @details
#' This is a simple utility to help with the common task of paginating large tables.
#' After splitting the data, you can use a loop to create multiple `gridify` objects
#' and export them as a multi-page PDF or separate image files.
#'
#' The function does not perform the gridify conversion itself - it only prepares the data.
#' This keeps the package lightweight and flexible.
#'
#' @seealso [gridify()], [export_to()]
#'
#' @examples
#' # Basic usage - split mtcars into pages of 10 rows
#' pages <- paginate_table(mtcars, rows_per_page = 10)
#' length(pages)  # Number of pages
#'
#' # With filled last page for consistent positioning
#' pages_filled <- paginate_table(mtcars, rows_per_page = 10, fill_last_page = TRUE)
#' nrow(pages_filled[[1]])  # 10 rows
#' nrow(pages_filled[[length(pages_filled)]])  # Also 10 rows (filled with empty rows)
#'
#' # Without page column
#' pages_no_col <- paginate_table(mtcars, rows_per_page = 10, page_col = NULL)
#'
#' # Complete workflow example (not run)
#' library(gridify)
#' library(gt)
#' library(magrittr)
#'
#' # Split the data
#' pages <- paginate_table(mtcars, rows_per_page = 10, fill_last_page = TRUE)
#'
#' # Create gridify objects for each page
#' gridify_list <- lapply(seq_along(pages), function(i) {
#'   gt_table <- gt::gt(pages[[i]]) %>%
#'     gt::tab_options(table.font.size = 12)
#'
#'   gridify(gt_table, layout = pharma_layout_A4()) %>%
#'     set_cell("title_1", "My Multi-Page Table") %>%
#'     set_cell("footer_right", paste("Page", i, "of", length(pages)))
#' })
#'
#' # Export as multi-page PDF
#' temp_my_multipage_table <- tempfile(fileext = ".pdf")
#' export_to(gridify_list, temp_my_multipage_table)
#'
#' @export
paginate_table <- function(
    data,
    rows_per_page,
    fill_last_page = FALSE,
    page_col = "page_number"
) {
    # Validate inputs
    if (!is.data.frame(data)) {
        stop("`data` must be a data frame.")
    }

    if (
        !(is.numeric(rows_per_page) &&
            length(rows_per_page) == 1 &&
            rows_per_page > 0)
    ) {
        stop("`rows_per_page` must be a positive integer.")
    }

    rows_per_page <- as.integer(rows_per_page)

    if (!is.logical(fill_last_page) || length(fill_last_page) != 1) {
        stop("`fill_last_page` must be TRUE or FALSE.")
    }

    if (
        !(is.null(page_col) ||
            (is.character(page_col) && length(page_col) == 1))
    ) {
        stop("`page_col` must be NULL or a single character string.")
    }

    # Calculate number of pages
    number_of_rows <- nrow(data)
    number_of_pages <- ceiling(number_of_rows / rows_per_page)

    # Add page number column if requested
    if (!is.null(page_col)) {
        data[[page_col]] <- rep(
            seq_len(number_of_pages),
            each = rows_per_page,
            length.out = number_of_rows
        )

        # Split by page
        pages <- split(data, data[[page_col]])
    } else {
        # Create page assignments without adding column
        page_assignments <- rep(
            seq_len(number_of_pages),
            each = rows_per_page,
            length.out = number_of_rows
        )

        # Split by page
        pages <- split(data, page_assignments)
    }

    # Fill last page if requested
    if (fill_last_page) {
        last_page_idx <- length(pages)
        last_page <- pages[[last_page_idx]]
        last_page_nrows <- nrow(last_page)

        if (last_page_nrows < rows_per_page) {
            rows_difference <- rows_per_page - last_page_nrows

            # Create empty rows
            empty_df <- data.frame(
                matrix(" ", nrow = rows_difference, ncol = ncol(data)),
                stringsAsFactors = FALSE
            )
            colnames(empty_df) <- colnames(data)

            # Append to last page
            pages[[last_page_idx]] <- rbind(last_page, empty_df)
        }
    }

    # Remove names to return a clean list
    names(pages) <- NULL

    return(pages)
}
