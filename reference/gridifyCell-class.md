# gridifyCell class

Class for creating a cell used in a gridify layout.

## Slots

- `row`:

  A numeric value, span or a sequence specifying the range of occupied
  rows of the cell.

- `col`:

  A numeric value, span or a sequence specifying the range of occupied
  columns of the cell.

- `text`:

  A character value specifying the default text for the cell.

- `mch`:

  A numeric value specifying the maximum number of characters per line.
  The functionality is based on the `strwrap` function. By default, it
  avoids breaking up words and only splits lines when specified.

- `x`:

  A numeric value specifying the x position of text in the cell.

- `y`:

  A numeric value specifying the y position of text in the cell.

- `hjust`:

  A numeric value specifying the horizontal position of the text in the
  cell, relative to the x value.

- `vjust`:

  A numeric value specifying the vertical position of the text in the
  cell, relative to the y value.

- `rot`:

  A numeric value specifying the rotation of the cell.

- `gpar`:

  A [`grid::gpar()`](https://rdrr.io/r/grid/gpar.html) object specifying
  the graphical parameters of the cell.
