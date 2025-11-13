# Wrapper for `grid::unitType` which supports older R versions

Wrapper for [`grid::unitType`](https://rdrr.io/r/grid/unitType.html)
which supports older R versions

## Usage

``` r
grid_unit_type(x, use_grid = TRUE)
```

## Arguments

- x:

  a grid::unit

- use_grid:

  means try to call grid::unitType if it exists. The main purpose of
  this argument is to have full test coverage in tests. Default TRUE.

## Value

a character vector with unit type for each element.
