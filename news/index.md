# Changelog

## gridify 0.7.7.9000

### New features

- Added vertical anchoring for the gridify object inside its cell via
  the new `vjust` slot of
  [`gridifyObject()`](https://pharmaverse.github.io/gridify/reference/gridifyObject.md)
  and the `object_vjust` argument of
  [`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md),
  [`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md),
  [`pharma_layout_base()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_base.md),
  [`pharma_layout_A4()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_A4.md)
  and
  [`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md).
  `0` aligns the object to the bottom, `0.5` (default) centers it, and
  `1` anchors it to the top of the cell. Most useful for fixed-size
  grobs such as `gt` and `flextable` tables. When `vjust != 0.5` is used
  with a fixed-size grob the viewport is sized to
  [`grid::grobHeight()`](https://rdrr.io/r/grid/grobWidth.html) and the
  `height` slot of
  [`gridifyObject()`](https://pharmaverse.github.io/gridify/reference/gridifyObject.md)
  is ignored. For fixed-size tables, edge values (`0` or `1`) place the
  table directly against the object-row edge; add spacer rows in custom
  layouts or use inset values such as `0.05` or `0.95` if nearby text
  appears too close. Reported and proposed by Monika Beh.
- Added support for `fill_empty = NA` in the
  [`paginate_table()`](https://pharmaverse.github.io/gridify/reference/paginate_table.md)
  function.

### Bug fixes

- When `fill_empty` in the
  [`paginate_table()`](https://pharmaverse.github.io/gridify/reference/paginate_table.md)
  function is a character value, the final paginated table now coerces
  columns to character before filling empty cells
  ([\#20](https://github.com/pharmaverse/gridify/issues/20)).

### Miscellaneous

- Added section on pipeline security and PDF searchability to
  `README.md`, `gridify` vignette, and `transparency` vignette.
- Added the active lifecycle badge to `README.md` file
  ([\#17](https://github.com/pharmaverse/gridify/issues/17)).

## gridify 0.7.7

CRAN release: 2026-02-05

- Updated `README.md` file.
- Updated description how to convert points to pixels, example in
  `README.md` file.
- Removed `rtables` examples as installation of `rtables.officer`
  requires R \>= 4.4.0.
- Added the base R `grDevices` in `DESCRIPTION` file `Imports`.

## gridify 0.7.6

- Require a new stable `rtables` version, caused by `rtables` CRAN
  errors.

## gridify 0.7.5

CRAN release: 2025-11-13

- Added new
  [`paginate_table()`](https://pharmaverse.github.io/gridify/reference/paginate_table.md)
  helper function to simplify splitting data frames into pages for
  multi-page tables.
- Updated multi-page vignette to demonstrate the new
  [`paginate_table()`](https://pharmaverse.github.io/gridify/reference/paginate_table.md)
  function.
- Updated `README.md` file.

## gridify 0.7.4

CRAN release: 2025-08-28

- Updated `export_to` method examples to not use `dontrun`.
- Added doi in the DESCRIPTION file.

## gridify 0.7.3

- Improved `show_spec` method for `gridifyLayout`.
- New feature of background colour for layouts, by the new `background`
  argument.

## gridify 0.7.2

- First open-source release.
