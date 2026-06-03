# Detect a "flexible" grob whose natural height is not meaningful

A flexible grob is one designed to fill whatever container it is placed
in, so [`grid::grobHeight()`](https://rdrr.io/r/grid/grobWidth.html)
cannot be used to size its viewport. Detection layers, in order of
precedence:

1.  an explicit `gridify.flexible` attribute on the grob (set by the
    [`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)
    constructor for grobs produced via
    [`grid::grid.grabExpr()`](https://rdrr.io/r/grid/grid.grab.html) on
    the `formula` input path);

2.  a `gtable` with at least one `null` unit in its `heights` (e.g.
    [`ggplot2::ggplotGrob()`](https://ggplot2.tidyverse.org/reference/ggplotGrob.html)).

## Usage

``` r
is_flexible_grob(grob)
```

## Arguments

- grob:

  a grob.

## Value

`TRUE` if `grob` is flexible, `FALSE` otherwise.

## Details

All other grobs
([`gt::as_gtable()`](https://gt.rstudio.com/reference/as_gtable.html),
[`flextable::gen_grob()`](https://davidgohel.github.io/flextable/reference/gen_grob.html),
plain [`grid::rectGrob()`](https://rdrr.io/r/grid/grid.rect.html) /
[`grid::nullGrob()`](https://rdrr.io/r/grid/grid.null.html), user
gTrees, ...) are treated as fixed-size. The previous heuristic of "any
gTree carrying a `childrenvp`" was dropped because `childrenvp` is set
for many reasons unrelated to container-filling (clip viewports, custom
transforms, ...).
