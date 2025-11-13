# gridifyLayout class

Class for creating a layout for a gridify object.

## Slots

- `nrow`:

  An integer specifying the number of rows in the layout.

- `ncol`:

  An integer specifying the number of columns in the layout.

- `heights`:

  A [`grid::unit()`](https://rdrr.io/r/grid/unit.html) call specifying
  the heights of the rows.

- `widths`:

  A [`grid::unit()`](https://rdrr.io/r/grid/unit.html) call specifying
  the widths of the columns.

- `margin`:

  A [`grid::unit()`](https://rdrr.io/r/grid/unit.html) specifying the
  margins around the object.

- `global_gpar`:

  A [`grid::gpar()`](https://rdrr.io/r/grid/gpar.html) object specifying
  the global graphical parameters.

- `background`:

  A string with background colour.

- `adjust_height`:

  A logical value indicating whether to adjust the height of the object.
  Only applies for cells with height defined in cm, mm, inch or lines
  units.

- `object`:

  A grob object.

- `cells`:

  A list of cell objects.
