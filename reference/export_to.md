# Export gridify objects to a file

The `export_to()` function exports a `gridifyClass` object or a list of
such objects to a specified file. Supported formats include PDF, PNG,
TIFF and JPEG. For lists, if a single file name with a PDF file
extension is provided, the objects are combined into a multi-page PDF;
if a character vector with one file per object is provided, each object
is written to its corresponding file. It is not possible to create
multi-page PNG or JPEG files.

## Usage

``` r
export_to(x, to, device = NULL, ...)

# S4 method for class 'gridifyClass'
export_to(x, to, device = NULL, ...)

# S4 method for class 'list'
export_to(x, to, device = NULL, ...)

# S4 method for class 'ANY'
export_to(x, to, device = NULL, ...)
```

## Arguments

- x:

  A `gridifyClass` object or a list of `gridifyClass` objects.

- to:

  A character string (or vector) specifying the output file name(s). The
  extension determines the output format.

- device:

  a function for graphics device. By default a file name extension is
  used to choose a graphics device function. Default `NULL`

- ...:

  Additional arguments passed to the graphics device functions
  ([`pdf()`](https://rdrr.io/r/grDevices/pdf.html),
  [`png()`](https://rdrr.io/r/grDevices/png.html),
  [`tiff()`](https://rdrr.io/r/grDevices/png.html),
  [`jpeg()`](https://rdrr.io/r/grDevices/png.html) or your custom one).
  Default width and height for each export type, respectively:

  - PDF: 11.69 inches x 8.27 inches

  - PNG: 600 px x 400 px

  - TIFF: 600 px x 400 px

  - JPEG: 600 px x 400 px

## Value

No value is returned; the function is called for its side effect of
writing output to a file.

## Details

For PDF export, a new device is opened, the grid is printed using the
object's custom print method, and then the device is closed. For PNG and
JPEG, the device is opened, a new grid page is started, the grid is
printed, and then the device is closed.

When exporting a list of objects:

- If `to` is a single PDF file (length is 1), the function creates a
  multi-page PDF.

- If a vector of file names (one per object) is provided, each gridify
  object is written to its corresponding file.

## Note

`gridify` objects can be saved directly in `.Rmd` and `.Qmd` documents,
just like in the `gridify` package vignettes.

**gt [`pct()`](https://gt.rstudio.com/reference/pct.html) issue**

Using [`pct()`](https://gt.rstudio.com/reference/pct.html) to set the
width of `gt` tables can be unreliable when exporting to PDF. It is
recommended to use [`px()`](https://gt.rstudio.com/reference/px.html) to
set the width in pixels instead.

## Examples

``` r
library(gridify)
library(magrittr)
library(ggplot2)

# Create a gridify object using a ggplot and a custom layout:

# Set text elements on various cells:
gridify_obj <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = pharma_layout_base(
    margin = grid::unit(c(0.5, 0.5, 0.5, 0.5), "inches"),
    global_gpar = grid::gpar(fontfamily = "serif", fontsize = 10)
  )
) %>%
  set_cell("header_left_1", "My Company") %>%
  set_cell("header_left_2", "<PROJECT> / <INDICATION>") %>%
  set_cell("header_left_3", "<STUDY>") %>%
  set_cell("header_right_1", "CONFIDENTIAL") %>%
  set_cell("header_right_2", "<Draft or Final>") %>%
  set_cell("header_right_3", "Data Cut-off: YYYY-MM-DD") %>%
  set_cell("output_num", "<Output> xx.xx.xx") %>%
  set_cell("title_1", "<Title 1>") %>%
  set_cell("title_2", "<Title 2>") %>%
  set_cell("title_3", "<Optional Title 3>") %>%
  set_cell("by_line", "By: <GROUP>, <optionally: Demographic parameters>") %>%
  set_cell("note", "<Note or Footnotes>") %>%
  set_cell("references", "<References:>") %>%
  set_cell("footer_left", "Program: <PROGRAM NAME>, YYYY-MM-DD at HH:MM") %>%
  set_cell("footer_right", "Page xx of nn") %>%
  set_cell("watermark", "DRAFT")

# Export a result to different file types

# Different file export formats require specific capabilities in your R installation.
# Use capabilities() to check which formats are supported in your R build.

# PNG
temp_png_default <- tempfile(fileext = ".png")
export_to(
  gridify_obj,
  to = temp_png_default
)

temp_png_custom <- tempfile(fileext = ".png")
export_to(
  gridify_obj,
  to = temp_png_custom,
  width = 2400,
  height = 1800,
  res = 300
)

# JPEG
temp_jpeg_default <- tempfile(fileext = ".jpeg")
export_to(
  gridify_obj,
  to = temp_jpeg_default
)

temp_jpeg_custom <- tempfile(fileext = ".jpeg")
export_to(
  gridify_obj,
  to = temp_jpeg_custom,
  width = 2400,
  height = 1800,
  res = 300
)

# TIFF
temp_tiff_default <- tempfile(fileext = ".tiff")
export_to(
  gridify_obj,
  to = temp_tiff_default
)

temp_tiff_custom <- tempfile(fileext = ".tiff")
export_to(
  gridify_obj,
  to = temp_tiff_custom,
  width = 2400,
  height = 1800,
  res = 300
)

# PDF
temp_pdf_A4 <- tempfile(fileext = ".pdf")
export_to(
  gridify_obj,
  to = temp_pdf_A4
)

temp_pdf_A4long <- tempfile(fileext = ".pdf")
export_to(
  gridify_obj,
  to = temp_pdf_A4long,
  width = 8.3,
  height = 11.7
)

# Use different pdf device - cairo_pdf
temp_pdf_A4long_cairo <- tempfile(fileext = ".pdf")
export_to(
  gridify_obj,
  to = temp_pdf_A4long_cairo,
  device = grDevices::cairo_pdf,
  width = 8.3,
  height = 11.7
)

# Multiple Objects - a list

gridify_list <- list(gridify_obj, gridify_obj)

temp_pdf_multipageA4 <- tempfile(fileext = ".pdf")
export_to(
  gridify_list,
  to = temp_pdf_multipageA4
)

temp_pdf_multipageA4long <- tempfile(fileext = ".pdf")
export_to(
  gridify_list,
  to = temp_pdf_multipageA4long,
  width = 8.3,
  height = 11.7
)

temp_png_multi <- c(tempfile(fileext = ".png"), tempfile(fileext = ".png"))
export_to(
  gridify_list,
  to = temp_png_multi
)

temp_png_multi_custom <- c(tempfile(fileext = ".png"), tempfile(fileext = ".png"))
export_to(
  gridify_list,
  to = temp_png_multi_custom,
  width = 800,
  height = 600,
  res = 96
)
```
