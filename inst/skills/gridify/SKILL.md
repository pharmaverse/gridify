---
name: gridify
description: Help users write correct R code for adding headers, titles, footnotes, watermarks and other text around figures and tables using gridify. Use when users need to annotate ggplot2, gt, flextable, rtables, base R plots or grobs, choose or build a layout (simple, complex, pharma A4/letter, custom gridifyLayout), fill cells with set_cell(), paginate long tables, or export TLF outputs to PDF/PNG/TIFF/JPEG.
metadata:
  author: Maciej Nasinski (@Polkas)
  version: "1.0"
license: Apache-2.0
---

gridify is an R package, built on base `grid`, that places text elements (headers, titles, notes, footers, watermarks) around a figure or table using a predefined or custom layout. The result is always a graphic: stable, non-editable, and with searchable text when exported to PDF.

## Core Workflow

1. Create the object (`ggplot`, `gt`, `flextable`, grob, base R plot as formula).
2. Pick a layout — `get_layouts()` lists the predefined ones.
3. `gridify(object, layout)` creates a `gridifyClass` object.
4. Print it (or call `show_cells()`) to see the available cell names.
5. Fill cells with `set_cell()`.
6. Print, or write to file with `export_to()`.

```r
library(gridify)

p <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) + ggplot2::geom_point()

g <- gridify(object = p, layout = pharma_layout_A4()) |>
  set_cell("header_left_1", "My Company") |>
  set_cell("header_left_2", "<PROJECT> / <INDICATION>") |>
  set_cell("header_left_3", "<STUDY>") |>
  set_cell("header_right_2", "<Draft or Final>") |>
  set_cell("header_right_3", "Data Cut-off: YYYY-MM-DD") |>
  set_cell("output_num", "Figure 14.1.1") |>
  set_cell("title_1", "Weight by Miles per Gallon") |>
  set_cell("by_line", "Safety Population") |>
  set_cell("note", "Note: Data from mtcars.") |>
  set_cell("footer_left", "Program: fig_14_1_1.R, YYYY-MM-DD at HH:MM") |>
  set_cell("footer_right", "Page 1 of 1") |>
  set_cell("watermark", "DRAFT")

g                                      # draw on the current device
export_to(g, to = "fig_14_1_1.pdf")    # A4 landscape PDF by default
```

The native pipe `|>` needs R >= 4.1.0; otherwise use `%>%` from magrittr.

## Supported Inputs

`gridify()` accepts objects inheriting from `grob`, `ggplot`, `flextable`, `gt_tbl` or `formula`. Conversion happens inside `gridify()`:

| Input | Converted with | Requirement |
|-------|----------------|-------------|
| `ggplot` | `ggplot2::ggplotGrob()` | ggplot2 |
| `gt_tbl` | `gt::as_gtable()` | gt >= 0.11.0 (and gtable) |
| `flextable` | `flextable::gen_grob()` | flextable >= 0.8.0 |
| base R plot as `~ expr` | `gridGraphics::grid.echo()` | gridGraphics |
| `grob` / `gtable` | used as is | — |

```r
# Base R plots must be wrapped in a one-sided formula
gridify(~ barplot(1:10), layout = simple_layout())

# rtables are not supported directly: convert to flextable first
ft <- rtables.officer::tt_to_flextable(my_rtable, theme = NULL)
gridify(ft, layout = pharma_layout_letter())
```

Anything else (data.frame, `rtables` object, file path, ...) errors. Convert it to one of the classes above first, e.g. with `grid::grid.grabExpr()` for code that draws on a grid device.

## Predefined Layouts and Their Cells

Cell names are fixed by the layout. `set_cell()` with an unknown name errors and lists the valid names. Check them with `show_cells(layout_or_object)`.

| Layout | Cells |
|--------|-------|
| `simple_layout()` | `title`, `footer` |
| `complex_layout()` | `header_left`, `header_middle`, `header_right`, `title`, `subtitle`, `note`, `footer_left`, `footer_middle`, `footer_right` |
| `pharma_layout_base()`, `pharma_layout_A4()`, `pharma_layout_letter()` | `header_left_1`, `header_left_2`, `header_left_3`, `header_right_1`, `header_right_2`, `header_right_3`, `output_num`, `title_1`, `title_2`, `title_3`, `by_line`, `note`, `references`, `footer_left`, `footer_right`, `watermark` |

Layout arguments:

- `simple_layout()` / `complex_layout()`: `margin`, `global_gpar` (a `grid::gpar()`), `background`, `scales = c("fixed", "free")`, `object_vjust`.
- `pharma_layout_base()`: `margin` (default 1 inch on each side), `global_gpar` (a **list** of overrides merged into `fontfamily = "serif", fontsize = 9, lineheight = 0.95`), `background`, `adjust_height`, `object_vjust`.
- `pharma_layout_A4()` / `pharma_layout_letter()`: only `global_gpar`, `background`, `object_vjust`. Margins are fixed (A4: t=1, r=1.69, b=1, l=1 in; letter: t=1, r=1, b=1.23, l=1 in). Use `pharma_layout_base(margin = ...)` for custom margins.

`pharma_layout_*()` pre-fills `header_right_1` with `"CONFIDENTIAL"`; override it with `set_cell()` if needed. The `note` cell wraps at `mch = 100` characters by default.

`layout` may be the layout object (`simple_layout()`) or the function itself (`simple_layout`); gridify calls it with defaults.

### `scales`: `"fixed"` vs `"free"`

- `"fixed"` (default): text rows are sized in `lines` and grow with the text (including `\n`), so text never overlaps; the object takes the remaining space.
- `"free"`: rows are proportional (`npc`); text can overlap the object on small devices. Enlarge the device (or `fig.width`/`fig.height` in R Markdown) if it does.

## set_cell()

```r
set_cell(object, cell, text, mch = NULL, x = NULL, y = NULL,
         hjust = NULL, vjust = NULL, rot = NULL, gpar = NULL)
```

- `text` must be a **single string**. Use `"\n"` for line breaks — never a character vector.
- `mch`: maximum characters per line (wraps via `strwrap()`, does not split words).
- `x`, `y` in `[0, 1]` locate the anchor in the cell; `hjust`, `vjust` in `[0, 1]` say which part of the text sits on the anchor. Left-align: `x = 0, hjust = 0`. Right-align: `x = 1, hjust = 1`.
- `rot`: rotation in degrees, anticlockwise.
- `gpar`: a `grid::gpar()` object (not a list).
- `NULL` arguments fall back to the cell defaults defined in the layout.

```r
g <- gridify(p, layout = simple_layout())

# WRONG: vector text
set_cell(g, "title", c("Line 1", "Line 2"))
# CORRECT
set_cell(g, "title", "Line 1\nLine 2")

# WRONG: gpar as a list in set_cell
set_cell(g, "title", "T", gpar = list(fontsize = 14))
# CORRECT
set_cell(g, "title", "T", gpar = grid::gpar(fontsize = 14, fontface = "bold"))
```

Graphical parameter precedence: `set_cell(gpar)` > `gridifyCell(gpar)` > layout `global_gpar`.

## Custom Layouts

Build a reusable layout with `gridifyLayout()`. Wrap it in a function so it can be parametrised and shared across a project.

```r
my_layout <- function(
    margin = grid::unit(c(t = 0.5, r = 0.5, b = 0.5, l = 0.5), "inches"),
    global_gpar = grid::gpar(fontfamily = "sans", fontsize = 10)) {
  gridifyLayout(
    nrow = 4L,
    ncol = 2L,
    heights = grid::unit(c(1, 1, 1, 1), c("lines", "lines", "null", "lines")),
    widths = grid::unit(c(0.5, 0.5), "npc"),
    margin = margin,
    global_gpar = global_gpar,
    background = grid::get.gpar()$fill,
    adjust_height = TRUE,
    object = gridifyObject(row = 3, col = 1:2),
    cells = gridifyCells(
      company = gridifyCell(row = 1, col = 2, x = 1, hjust = 1),
      title = gridifyCell(row = 2, col = 1:2, gpar = grid::gpar(fontface = "bold")),
      footer = gridifyCell(row = 4, col = 1, x = 0, hjust = 0, text = "Default footer"),
      watermark = gridifyCell(
        row = 3, col = 1:2, rot = 45,
        gpar = grid::gpar(fontsize = 80, alpha = 0.3)
      )
    )
  )
}

gridify(p, layout = my_layout()) |>
  set_cell("company", "Company Ltd") |>
  set_cell("title", "My Title")
```

Rules:

- `heights` / `widths` are `grid::unit()` vectors of length `nrow` / `ncol`. Units can be mixed: `grid::unit(c(1, 1, 1), c("lines", "null", "lines"))`.
- Give the object row `"null"` (it takes the leftover space). Use `"lines"`, `"cm"`, `"mm"` or `"inches"` for text rows; `adjust_height = TRUE` grows those rows to fit the text but never affects `npc` rows.
- Do **not** add empty rows/columns for margins — use `margin = grid::unit(c(t = , r = , b = , l = ), unit)` (length 4: top, right, bottom, left).
- `row` / `col` in `gridifyCell()` and `gridifyObject()` accept a single value (`3`), a sequence (`2:4`) or a span (`c(1, 3)` means rows 1 to 3). A text cell may share the object's row (e.g. a watermark), but text cells overlapping each other trigger an "Overlapping cells" warning.
- All cells in `gridifyCells()` must be named, unique, and created with `gridifyCell()`.
- `gridifyCell(text = ...)` sets a default text; `set_cell()` overrides it.
- `scales` is not a `gridifyLayout()` argument; implement it in your wrapper function (as `simple_layout()` does) if you need it.
- Inspect with `show_layout(layout)`, `show_spec(layout)` and `show_cells(layout)`. Zero-height `lines` rows look empty in `show_layout()` until text is added.

## Vertical Anchoring of Tables (`object_vjust`)

Fixed-size grobs (`gt`, `flextable`) are centred in the object row by default. Anchor them with `object_vjust` on any predefined layout, or `gridifyObject(vjust = ...)` in a custom layout: `1` = top, `0.5` = centre, `0` = bottom.

```r
gridify(gt::gt(head(mtcars)), layout = pharma_layout_A4(object_vjust = 0.95))
```

Edge values `0`/`1` place the table directly against neighbouring text; prefer insets like `0.95`/`0.05`. Flexible grobs (ggplot, base R formula) always fill the row, so `vjust` has no effect on them.

## Multi-Page Outputs

`paginate_table()` splits a data frame into a list of pages; build one gridify object per page and export the list.

```r
pages <- paginate_table(mtcars, rows_per_page = 10, fill_empty = " ")
# also: split_by = "cyl" (one page per group, list named by group value),
# or combine split_by with rows_per_page

gridify_list <- lapply(seq_along(pages), function(i) {
  tab <- gt::gt(pages[[i]]) |>
    gt::tab_options(table.font.size = 9 * 96 / 72, table.font.names = "serif")

  gridify(tab, layout = pharma_layout_A4(object_vjust = 0.95)) |>
    set_cell("title_1", "Table 14.1.1 Car Characteristics") |>
    set_cell("footer_right", sprintf("Page %d of %d", i, length(pages)))
})

# one multi-page PDF
export_to(gridify_list, to = "table_14_1_1.pdf")
# one file per page
export_to(gridify_list, to = sprintf("page_%02d.png", seq_along(gridify_list)))
```

- `fill_empty` pads short pages with blank rows so the table stays at the same position on every page. A character value coerces columns to character; use `NA` to keep column types.
- At least one of `rows_per_page` or `split_by` is required.
- `paginate_table()` only splits data; it does not create gridify objects.

## Exporting

```r
export_to(x, to, device = NULL, ...)
```

- Format is chosen from the extension of `to`: `pdf`, `png`, `jpg`/`jpeg`, `tiff`/`tif`. Other extensions error; use R Markdown/Quarto for HTML/DOCX.
- `...` is passed to the device. Defaults: PDF `width = 11.69, height = 8.27` inches (A4 landscape); raster `width = 600, height = 400` pixels.
- For a high-resolution PNG set `width`, `height` **and** `res`: `export_to(g, "out.png", width = 2400, height = 1800, res = 300)`.
- Portrait A4 PDF: `width = 8.27, height = 11.69`. US letter landscape: `width = 11, height = 8.5`.
- Alternative device: `export_to(g, "out.pdf", device = grDevices::cairo_pdf)` (better font/Unicode support).
- Lists: a single `.pdf` path gives a multi-page PDF; a vector of paths (same length as the list) writes one file per object. Multi-page PNG/JPEG/TIFF is not possible.
- The target directory must already exist.
- In `.Rmd` / `.qmd`, just print the gridify object in a chunk and control its size with `fig.width` / `fig.height`.

## Common Mistakes

### Piping a ggplot without braces

`|>` / `%>%` bind tighter than `+`, so the pipe only receives the last layer.

```r
# WRONG: gridify() receives geom_point(), not the plot
ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
  ggplot2::geom_point() |>
  gridify(layout = simple_layout())

# CORRECT: build the plot first (or wrap it in parentheses / braces)
p <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) + ggplot2::geom_point()
gridify(p, layout = simple_layout())
```

### Font sizes differ between gt and gridify

`gt` interprets font sizes in pixels, `grid` in points. Multiply points by `96 / 72` for gt:

```r
gt::tab_options(tab, table.font.size = 9 * 96 / 72, table.font.names = "serif")
```

### gt `pct()` widths in PDF

`gt::pct()` table widths can be unreliable when exporting to PDF. Prefer `gt::px()`.

### Font family not available

Some devices ignore `fontfamily`. Use generic families (`"serif"`, `"sans"`, `"mono"`), a device with better font support (`grDevices::cairo_pdf`), or register fonts with `extrafont`.

### Object too small or distorted

With many text lines, or `scales = "free"` on a small device, the object row shrinks (gridify enforces a 1 inch minimum). Enlarge the device/export size, reduce `fontsize`, or use `mch` to wrap long notes.

### Wrong `global_gpar` type

`simple_layout()`, `complex_layout()` and `gridifyLayout()` expect `grid::gpar(...)`. `pharma_layout_*()` accept a list of overrides (a `grid::gpar()` also works).

## Transparency / Reproducibility

`print()` draws the output and invisibly returns the underlying `grid` call, so the exact code can be audited:

```r
grid_call <- print(g)
grid_call                                    # inspect the grid code
OBJECT <- attr(grid_call, "env")[["OBJECT"]]
grid::grid.draw(eval(grid_call))             # redraw from the call
```

## Global Options

Only relevant when the layout has `adjust_height = TRUE`. Avoid changing them unless needed, as they reduce consistency across projects.

- `gridify.adjust_height.line` (default `0.10`): extra padding for rows sized in `"lines"` (predefined layouts with `scales = "fixed"`, pharma layouts).
- `gridify.adjust_height.default` (default `0.25`): extra padding for rows sized in `"cm"`, `"mm"` or `"inches"` (custom layouts only).

```r
options(gridify.adjust_height.line = 0.7)
```

## Further Reading

- `vignette("gridify", package = "gridify")`: getting started
- `vignette("simple_examples", package = "gridify")`: every input type, gpar, scales, anchoring, export
- `vignette("multi_page_examples", package = "gridify")`: loops and paginated tables
- `vignette("create_custom_layout", package = "gridify")`: building layouts
- `vignette("transparency", package = "gridify")`: extracting the grid code
