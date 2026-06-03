# gridifyObject class

Class for creating an object in a gridify layout.

## Slots

- `row`:

  A numeric value, span or sequence specifying the row position of the
  object.

- `col`:

  A numeric value, span or sequence specifying the column position of
  the object.

- `height`:

  A numeric value specifying the height of the object as a fraction of
  the row (interpreted in `npc`). Ignored when `vjust != 0.5` and the
  grob is fixed-size: in that case the viewport is sized to
  [`grid::grobHeight()`](https://rdrr.io/r/grid/grobWidth.html) so the
  object can be anchored within a taller row. The 1-inch floor in
  applies in both cases.

- `width`:

  A numeric value specifying the width of the object.

- `vjust`:

  A numeric value in `[0, 1]` specifying the vertical anchoring of the
  object within its cell. `0` aligns to the bottom, `0.5` (default)
  centers it, and `1` aligns to the top. Anchoring only takes effect for
  fixed-size grobs (e.g.
  [`gt::as_gtable()`](https://gt.rstudio.com/reference/as_gtable.html),
  [`flextable::gen_grob()`](https://davidgohel.github.io/flextable/reference/gen_grob.html),
  plain [`grid::rectGrob()`](https://rdrr.io/r/grid/grid.rect.html)).
  Flexible grobs whose natural height is meant to fill the container
  (e.g.
  [`ggplot2::ggplotGrob()`](https://ggplot2.tidyverse.org/reference/ggplotGrob.html),
  recorded gTrees from
  [`grid::grid.grabExpr()`](https://rdrr.io/r/grid/grid.grab.html))
  always span the full row regardless of `vjust`. For fixed-size table
  grobs, edge values (`0` or `1`) place the table directly against the
  object-row edge; add spacer rows in a custom layout or use an inset
  value such as `0.05` or `0.95` if nearby text appears too close.
