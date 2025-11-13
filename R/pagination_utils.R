#' Split a data frame into pages for multi-page tables
#'
#' @description
#' A lightweight utility function to split a data frame into pages based on the number of rows per page.
#' This is useful when creating multi-page tables with `gridify`.
#'
#' @param data A data frame to split into pages.
#' @param rows_per_page Integer or NULL. The maximum number of rows per page.
#'   When used with `split_by`, groups larger than `rows_per_page` will be split into multiple pages.
#'   When used alone, splits the entire dataset by row count.
#'   At least one of `rows_per_page` or `split_by` must be provided.
#' @param split_by Character string or NULL. Name of a column in `data` to split by.
#'   Each unique value in this column starts a new page. Can be combined with `rows_per_page`
#'   to further split large groups.
#'   At least one of `rows_per_page` or `split_by` must be provided.
#' @param fill_empty Character string or NULL. When provided, fills incomplete pages
#'   with empty rows to match the target row count. Default is `NULL` (no filling).
#'   Providing a value (e.g., `"|"`, `""`, or `"—"`) automatically enables filling and uses that
#'   value for all cells in the empty rows. This helps maintain consistent vertical positioning
#'   across all pages. The target row count is the maximum page size across all pages.
#'
#' @return A list of data frames, one for each page. When `split_by` is used, the list
#'   is named with the group values. If a group spans multiple pages (when combined with
#'   `rows_per_page`), multiple list elements will have the same name.
#'   When only `rows_per_page` is used, returns an unnamed list.
#'
#' @details
#' This is a simple utility to help with the common task of paginating large tables.
#' After splitting the data, you can use a loop to create multiple `gridify` objects
#' and export them as a multi-page PDF or separate image files.
#'
#' The function does not perform the gridify conversion itself - it only prepares the data.
#' This keeps the package lightweight and flexible.
#'
#' @note This function is designed to work with data frames.
#' It is suited especially for use with gt package.
#'
#' @seealso [gridify()], [export_to()]
#'
#' @examples
#' # Basic usage - split mtcars into pages of 10 rows
#' pages <- paginate_table(mtcars, rows_per_page = 10)
#' length(pages) # Number of pages
#'
#' # With filled last page for consistent positioning
#' pages_filled <- paginate_table(mtcars, rows_per_page = 10, fill_empty = "-")
#' nrow(pages_filled[[1]]) # 10 rows
#' nrow(pages_filled[[length(pages_filled)]]) # Also 10 rows (filled with empty rows)
#'
#' # With empty string fill
#' pages_empty <- paginate_table(mtcars, rows_per_page = 10, fill_empty = " ")
#'
#' # Without filling (default)
#' pages_no_fill <- paginate_table(mtcars, rows_per_page = 10)
#'
#' # Split by a grouping column
#' pages_by_cyl <- paginate_table(mtcars, split_by = "cyl")
#' length(pages_by_cyl) # 3 pages (one for each cylinder count: 4, 6, 8)
#' names(pages_by_cyl) # "4", "6", "8" - named with group values
#'
#' # Split by column with filling to match maximum page size
#' pages_by_cyl_filled <- paginate_table(mtcars, split_by = "cyl", fill_empty = "|")
#' sapply(pages_by_cyl_filled, nrow) # All pages have same number of rows
#' names(pages_by_cyl_filled) # "4", "6", "8"
#'
#' # Combine split_by and rows_per_page: split by cylinder, then by 5 rows
#' pages_combined <- paginate_table(mtcars, split_by = "cyl", rows_per_page = 5)
#' # Groups with more than 5 rows will be split into multiple pages
#' names(pages_combined) # e.g., "4", "6", "8", "8", "8" (8 cylinder group split into 3 pages)
#'
#' # With filling for combined approach
#' pages_combined_filled <- paginate_table(
#'   mtcars, 
#'   split_by = "cyl", 
#'   rows_per_page = 5, 
#'   fill_empty = "-"
#' )
#'
#'
#' library(gridify)
#' library(gt)
#' # (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
#' library(magrittr)
#'
#' # Regular Example with gt
#'
#' pages <- paginate_table(mtcars, rows_per_page = 10, fill_empty = " ")
#'
#' row_height_pixels <- 10
#' font_size <- 12
#' font_type <- "serif"
#'
#' # Create gridify objects for each page
#' gridify_list <- lapply(seq_along(pages), function(page) {
#'   gt_table <- gt::gt(pages[[page]]) %>%
#'     gt::tab_options(
#'       table.width = gt::pct(80),
#'       data_row.padding = gt::px(row_height_pixels),
#'       table.font.size = font_size,
#'       table.font.names = font_type
#'     )
#'
#'   gridify(
#'     gt_table,
#'     layout = pharma_layout_A4(global_gpar = grid::gpar(fontfamily = font_type))
#'   ) %>%
#'     set_cell("title_1", "My Multi-Page Table") %>%
#'     set_cell("footer_right", paste("Page", page, "of", length(pages)))
#' })
#'
#' # Export as multi-page PDF
#' temp_my_multipage_table_gt_simple <- tempfile(fileext = ".pdf")
#' export_to(gridify_list, temp_my_multipage_table_gt_simple)
#'
#' # By var Example with gt
#'
#' pages <- paginate_table(mtcars, split_by = "cyl")
#'
#' row_height_pixels <- 10
#' font_size <- 12
#' font_type <- "serif"
#'
#' # Create gridify objects for each page
#' gridify_list <- lapply(seq_along(pages), function(page) {
#'   gt_table <- gt::gt(pages[[page]]) %>%
#'     gt::tab_options(
#'       table.width = gt::pct(80),
#'       data_row.padding = gt::px(row_height_pixels),
#'       table.font.size = font_size,
#'       table.font.names = font_type
#'     )
#'
#'   gridify(
#'     gt_table,
#'     layout = pharma_layout_A4(global_gpar = grid::gpar(fontfamily = font_type))
#'   ) %>%
#'     set_cell("title_1", "My Multi-Page Table") %>%
#'     set_cell("by_line", sprintf("cyl is equal to %s", names(pages)[page])) %>%
#'     set_cell("footer_right", paste("Page", page, "of", length(pages)))
#' })
#'
#' # Export as multi-page PDF
#' temp_my_multipage_table_gt_by <- tempfile(fileext = ".pdf")
#' export_to(gridify_list, temp_my_multipage_table_gt_by)
#'
#' @export
paginate_table <- function(
    data,
    rows_per_page = NULL,
    split_by = NULL,
    fill_empty = NULL) {

  if (!is.data.frame(data)) {
    stop("`data` must be a data frame.")
  }

  # Check that at least one of rows_per_page or split_by is provided
  if (is.null(rows_per_page) && is.null(split_by)) {
    stop("At least one of `rows_per_page` or `split_by` must be provided.")
  }

  # Validate rows_per_page if provided
  if (!is.null(rows_per_page)) {
    if (!(is.numeric(rows_per_page) && length(rows_per_page) == 1 && rows_per_page > 0)) {
      stop("`rows_per_page` must be a positive integer.")
    }
    rows_per_page <- as.integer(rows_per_page)
  }

  # Validate split_by if provided
  if (!is.null(split_by)) {
    if (!is.character(split_by) || length(split_by) != 1) {
      stop("`split_by` must be a single character string.")
    }
    if (!split_by %in% colnames(data)) {
      stop("`split_by` column '", split_by, "' not found in data.")
    }
  }

  if (!is.null(fill_empty) && (!is.character(fill_empty) || length(fill_empty) != 1)) {
    stop("`fill_empty` must be NULL or a single character string.")
  }

    # Split data based on method
  if (!is.null(split_by)) {
    # Split by column values only - keep names
    groups <- split(data, data[[split_by]], drop = TRUE)
    # if rows_per_page is null then take max number of rows of the groups
    if(is.null(rows_per_page)) rows_per_page <- max(unlist(lapply(groups, nrow)))
  } else { 
    # don't split by column, only have 1 element in list
    groups <- list(data)
  }
  group_names <- names(groups)
  
  pages <- list()
  page_names <- character()

  for(i in seq_along(groups)){
    group <- groups[[i]]
    group_name <- group_names[i]
    group_rows <- nrow(group)
    
    if (group_rows <= rows_per_page) {
      # Group fits in one page
      pages <- c(pages, list(group))
      page_names <- c(page_names, group_name)
    } else {
      # Split group into multiple pages
      n_pages <- ceiling(group_rows / rows_per_page)
      page_assignments <- rep(
        seq_len(n_pages),
        each = rows_per_page,
        length.out = group_rows
      )
      group_pages <- split(group, page_assignments)
      pages <- c(pages, group_pages)
      # Repeat group name for each page in this group
      page_names <- c(page_names, rep(group_name, n_pages))
      
    }
  }
  names(pages) <- if (!is.null(split_by)) page_names else NULL

  # Fill pages if requested
  if (!is.null(fill_empty)) {

    pages <- lapply(pages, function(page) {
      page_nrows <- nrow(page)

      if (page_nrows < rows_per_page) {
        rows_difference <- rows_per_page - page_nrows

        # Create empty rows with specified fill value
        empty_df <- data.frame(
          matrix(fill_empty, nrow = rows_difference, ncol = ncol(data)),
          stringsAsFactors = FALSE
        )
        colnames(empty_df) <- colnames(data)

        # Append to page
        page <- rbind(page, empty_df)
      }

      page
    })
  }

  pages
}
