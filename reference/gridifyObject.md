# Create a gridifyObject

Function for creating a new instance of the gridifyObject class.

## Usage

``` r
gridifyObject(row, col, height = 1, width = 1, vjust = 0.5)
```

## Arguments

- row:

  A numeric value, span or sequence specifying the row position of the
  object.

- col:

  A numeric value, span or sequence specifying the row position of the
  object.

- height:

  A numeric value specifying the height of the object as a fraction of
  the row (interpreted in `npc`). Default is 1. Ignored when
  `vjust != 0.5` and the grob is fixed-size: in that case the viewport
  is sized to
  [`grid::grobHeight()`](https://rdrr.io/r/grid/grobWidth.html) so the
  object can be anchored within a taller row.

- width:

  A numeric value specifying the width of the object. Default is 1.

- vjust:

  A numeric value in `[0, 1]` specifying the vertical anchoring of the
  object within its cell. `0` aligns to the bottom, `0.5` (default)
  centers it, and `1` aligns to the top. Anchoring only takes effect for
  fixed-size grobs (e.g.
  [`gt::as_gtable()`](https://gt.rstudio.com/reference/as_gtable.html),
  [`flextable::gen_grob()`](https://davidgohel.github.io/flextable/reference/gen_grob.html)).
  Flexible grobs (e.g.
  [`ggplot2::ggplotGrob()`](https://ggplot2.tidyverse.org/reference/ggplotGrob.html))
  always fill the full row regardless of `vjust`. For fixed-size table
  grobs, edge values (`0` or `1`) place the table directly against the
  object-row edge; add spacer rows in a custom layout or use an inset
  value such as `0.05` or `0.95` if nearby text appears too close.

## Value

An instance of the gridifyObject class.

## See also

[`gridifyLayout()`](https://pharmaverse.github.io/gridify/reference/gridifyLayout.md)

## Examples

``` r
object <- gridifyObject(row = 1, col = 1, height = 1, width = 1)
```
