# Create a gridifyCells

Function for creating a new instance of the gridifyCells class.
gridifyCells consists of multiple gridifyCell objects and is an input
object for gridifyLayout.

## Usage

``` r
gridifyCells(...)
```

## Arguments

- ...:

  Arguments passed to the new function to create an instance of the
  gridifyCells class. Each argument should be the result of a call to
  gridifyCell.

## Value

An instance of the gridifyCells class.

## See also

[`gridifyLayout()`](https://pharmaverse.github.io/gridify/reference/gridifyLayout.md)

## Examples

``` r
cell1 <- gridifyCell(
  row = 1,
  col = 1,
  x = 0.5,
  y = 0.5,
  hjust = 0.5,
  vjust = 0.5,
  rot = 0,
  gpar = grid::gpar()
)
cell2 <- gridifyCell(
  row = 2,
  col = 2,
  x = 0.5,
  y = 0.5,
  hjust = 0.5,
  vjust = 0.5,
  rot = 0,
  gpar = grid::gpar()
)
cells <- gridifyCells(title = cell1, footer = cell2)
```
