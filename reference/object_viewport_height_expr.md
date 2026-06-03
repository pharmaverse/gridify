# Build the viewport-height expression for the object's grob

Chooses between the grob's natural height
([`grid::grobHeight()`](https://rdrr.io/r/grid/grobWidth.html)) and a
layout-driven height in npc, then floors the result via
[`grid::unit.pmax()`](https://rdrr.io/r/grid/unit.pmin.html) so the
viewport never collapses to zero.

## Usage

``` r
object_viewport_height_expr(
  grob,
  vjust,
  height,
  min_height = grid::unit(1, "inches")
)
```

## Arguments

- grob:

  a grob; used to evaluate `use_grob_height_for_object`.

- vjust:

  numeric, the layout's object vjust.

- height:

  numeric, the layout's object height (in npc). Ignored on the
  [`grid::grobHeight()`](https://rdrr.io/r/grid/grobWidth.html) branch
  (i.e. when `use_grob_height_for_object` returns `TRUE`); used
  otherwise.

- min_height:

  a [`grid::unit`](https://rdrr.io/r/grid/unit.html) floor applied via
  [`grid::unit.pmax()`](https://rdrr.io/r/grid/unit.pmin.html). Default
  `grid::unit(1, "inch")`.

## Value

an unevaluated call producing a
[`grid::unit`](https://rdrr.io/r/grid/unit.html).

## Details

`use_grob_height_for_object` evaluates to `TRUE` when the caller has
opted into vertical anchoring (`vjust != 0.5`) and the grob has a
meaningful natural height (i.e. is not flexible, see
[`is_flexible_grob()`](https://pharmaverse.github.io/gridify/reference/is_flexible_grob.md)).
The `vjust == 0.5` short-circuit preserves the historical "fill the row"
behaviour for users who did not opt in.

The returned expression references an unbound symbol `OBJECT`; the
caller is responsible for evaluating it in an environment that binds
`OBJECT` to the grob.
