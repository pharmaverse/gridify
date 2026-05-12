# gridify 0.7.7.9000

* Added vertical anchoring for the gridify object inside its cell via the new
  `vjust` slot of `gridifyObject()` and the `object_vjust` argument of
  `simple_layout()`, `complex_layout()`, `pharma_layout_base()`,
  `pharma_layout_A4()` and `pharma_layout_letter()`.
  `0` aligns the object to the bottom, `0.5` (default) keeps the previous
  centered behaviour, and `1` anchors it to the top of the cell. Most useful
  for fixed-size grobs such as `gt` and `flextable` tables. When `vjust != 0.5`
  is used with a fixed-size grob the viewport is sized to `grid::grobHeight()`
  and the `height` slot of `gridifyObject()` is ignored. Reported and proposed by Monika Beh.


# gridify 0.7.7

* Updated `README.md` file.
* Updated description how to convert points to pixels, example in `README.md` file.
* Removed `rtables` examples as installation of `rtables.officer` requires R >= 4.4.0.
* Added the base R `grDevices` in `DESCRIPTION` file `Imports`.

# gridify 0.7.6

* Require a new stable `rtables` version, caused by `rtables` CRAN errors. 

# gridify 0.7.5

* Added new `paginate_table()` helper function to simplify splitting data frames into pages for multi-page tables.
* Updated multi-page vignette to demonstrate the new `paginate_table()` function.
* Updated `README.md` file.

# gridify 0.7.4

* Updated `export_to` method examples to not use `dontrun`.
* Added doi in the DESCRIPTION file.

# gridify 0.7.3

* Improved `show_spec` method for `gridifyLayout`.
* New feature of background colour for layouts, by the new `background` argument.

# gridify 0.7.2

* First open-source release.
