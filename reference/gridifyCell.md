# Create a gridifyCell

Function for creating a new instance of the gridifyCell class. Multiple
gridifyCell objects are inputs for gridifyCells.

## Usage

``` r
gridifyCell(
  row,
  col,
  text = character(0),
  mch = Inf,
  x = 0.5,
  y = 0.5,
  hjust = 0.5,
  vjust = 0.5,
  rot = 0,
  gpar = grid::gpar()
)
```

## Arguments

- row:

  A numeric value, span or a sequence specifying the range of occupied
  rows of the cell.

- col:

  A numeric value, span or a sequence specifying the range of occupied
  columns of the cell.

- text:

  A character value specifying the default text for the cell. Default
  `character(0)`.

- mch:

  A numeric value specifying the maximum number of characters per line.
  The functionality is based on the `strwrap` function. By default, it
  avoids breaking up words and only splits lines when specified. Default
  `Inf`.

- x:

  A numeric value specifying the x position of text in the cell. Default
  `0.5`.

- y:

  A numeric value specifying the y position of text in the cell. Default
  `0.5`.

- hjust:

  A numeric value specifying the horizontal position of the text in the
  cell, relative to the x value. Default `0.5`.

- vjust:

  A numeric value specifying the vertical position of the text in the
  cell, relative to the y value. Default `0.5`.

- rot:

  A numeric value specifying the rotation of the cell. Default `0`.

- gpar:

  A [`grid::gpar()`](https://rdrr.io/r/grid/gpar.html) object specifying
  the graphical parameters of the cell. Default
  [`grid::gpar()`](https://rdrr.io/r/grid/gpar.html).

## Value

An instance of the gridifyCell class.

## See also

[`gridifyCells()`](https://pharmaverse.github.io/gridify/reference/gridifyCells.md),
[`gridifyLayout()`](https://pharmaverse.github.io/gridify/reference/gridifyLayout.md)

## Examples

``` r
cell <- gridifyCell(
  row = 1,
  col = 1:2,
  text = "Default cell text",
  mch = Inf,
  x = 0.5,
  y = 0.5,
  hjust = 0.5,
  vjust = 0.5,
  rot = 0,
  gpar = grid::gpar()
)
```
