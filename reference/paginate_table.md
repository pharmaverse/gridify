# Split a data frame into pages for multi-page tables

A lightweight utility function to split a data frame into pages based on
the number of rows per page. This is useful when creating multi-page
tables with `gridify`.

## Usage

``` r
paginate_table(data, rows_per_page = NULL, split_by = NULL, fill_empty = NULL)
```

## Arguments

- data:

  A data frame to split into pages.

- rows_per_page:

  Integer or NULL. The maximum number of rows per page. When used with
  `split_by`, groups larger than `rows_per_page` will be split into
  multiple pages. When used alone, splits the entire dataset by row
  count. At least one of `rows_per_page` or `split_by` must be provided.

- split_by:

  Character string or NULL. Name of a column in `data` to split by. Each
  unique value in this column starts a new page. Can be combined with
  `rows_per_page` to further split large groups. At least one of
  `rows_per_page` or `split_by` must be provided.

- fill_empty:

  Character string or NULL. When provided, fills incomplete pages with
  empty rows to match the target row count. Default is `NULL` (no
  filling). Providing a value (e.g., `"|"`, `""`, or `"—"`)
  automatically enables filling and uses that value for all cells in the
  empty rows. This helps maintain consistent vertical positioning across
  all pages. The target row count is the maximum page size across all
  pages.

## Value

A list of data frames, one for each page. When `split_by` is used, the
list is named with the group values. If a group spans multiple pages
(when combined with `rows_per_page`), multiple list elements will have
the same name. When only `rows_per_page` is used, returns an unnamed
list.

## Details

This is a simple utility to help with the common task of paginating
large tables. After splitting the data, you can use a loop to create
multiple `gridify` objects and export them as a multi-page PDF or
separate image files.

The function does not perform the gridify conversion itself - it only
prepares the data. This keeps the package lightweight and flexible.

## Note

This function is designed to work with data frames. It is suited
especially for use with gt package.

## See also

[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md),
[`export_to()`](https://pharmaverse.github.io/gridify/reference/export_to.md)

## Examples

``` r
# Basic usage - split mtcars into pages of 10 rows
pages <- paginate_table(mtcars, rows_per_page = 10)
length(pages) # Number of pages
#> [1] 4

# With filled last page for consistent positioning
pages_filled <- paginate_table(mtcars, rows_per_page = 10, fill_empty = "-")
nrow(pages_filled[[1]]) # 10 rows
#> [1] 10
nrow(pages_filled[[length(pages_filled)]]) # Also 10 rows (filled with empty rows)
#> [1] 10

# With empty string fill
pages_empty <- paginate_table(mtcars, rows_per_page = 10, fill_empty = " ")

# Without filling (default)
pages_no_fill <- paginate_table(mtcars, rows_per_page = 10)

# Split by a grouping column
pages_by_cyl <- paginate_table(mtcars, split_by = "cyl")
length(pages_by_cyl) # 3 pages (one for each cylinder count: 4, 6, 8)
#> [1] 3
names(pages_by_cyl) # "4", "6", "8" - named with group values
#> [1] "4" "6" "8"

# Split by column with filling to match maximum page size
pages_by_cyl_filled <- paginate_table(mtcars, split_by = "cyl", fill_empty = "|")
sapply(pages_by_cyl_filled, nrow) # All pages have same number of rows
#>  4  6  8 
#> 14 14 14 
names(pages_by_cyl_filled) # "4", "6", "8"
#> [1] "4" "6" "8"

# Combine split_by and rows_per_page: split by cylinder, then by 5 rows
pages_combined <- paginate_table(mtcars, split_by = "cyl", rows_per_page = 5)
# Groups with more than 5 rows will be split into multiple pages
names(pages_combined) # e.g., "4", "6", "8", "8", "8" (8 cylinder group split into 3 pages)
#> [1] "4" "4" "4" "6" "6" "8" "8" "8"

# With filling for combined approach
pages_combined_filled <- paginate_table(
  mtcars, 
  split_by = "cyl", 
  rows_per_page = 5, 
  fill_empty = "-"
)


library(gridify)
library(gt)
# (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
library(magrittr)

# Regular Example with gt

pages <- paginate_table(mtcars, rows_per_page = 10, fill_empty = " ")

row_height_pixels <- 10
font_size <- 12
font_type <- "serif"

# Create gridify objects for each page
gridify_list <- lapply(seq_along(pages), function(page) {
  gt_table <- gt::gt(pages[[page]]) %>%
    gt::tab_options(
      table.width = gt::pct(80),
      data_row.padding = gt::px(row_height_pixels),
      table.font.size = font_size,
      table.font.names = font_type
    )

  gridify(
    gt_table,
    layout = pharma_layout_A4(global_gpar = grid::gpar(fontfamily = font_type))
  ) %>%
    set_cell("title_1", "My Multi-Page Table") %>%
    set_cell("footer_right", paste("Page", page, "of", length(pages)))
})

# Export as multi-page PDF
temp_my_multipage_table_gt_simple <- tempfile(fileext = ".pdf")
export_to(gridify_list, temp_my_multipage_table_gt_simple)

# By var Example with gt

pages <- paginate_table(mtcars, split_by = "cyl")

row_height_pixels <- 10
font_size <- 12
font_type <- "serif"

# Create gridify objects for each page
gridify_list <- lapply(seq_along(pages), function(page) {
  gt_table <- gt::gt(pages[[page]]) %>%
    gt::tab_options(
      table.width = gt::pct(80),
      data_row.padding = gt::px(row_height_pixels),
      table.font.size = font_size,
      table.font.names = font_type
    )

  gridify(
    gt_table,
    layout = pharma_layout_A4(global_gpar = grid::gpar(fontfamily = font_type))
  ) %>%
    set_cell("title_1", "My Multi-Page Table") %>%
    set_cell("by_line", sprintf("cyl is equal to %s", names(pages)[page])) %>%
    set_cell("footer_right", paste("Page", page, "of", length(pages)))
})

# Export as multi-page PDF
temp_my_multipage_table_gt_by <- tempfile(fileext = ".pdf")
export_to(gridify_list, temp_my_multipage_table_gt_by)
```
