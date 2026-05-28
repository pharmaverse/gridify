# gridify 0.7.7.9000

## New features

* `export_to()` gains a `metadata` argument that records `set_cell()` text values
  alongside the exported output. The default is `metadata = "none"`; pass
  `"sidecar"` to write a JSON sidecar `<file>.json` next to the output.
  The sidecar identifies itself as `gridify.sidecar.metadata` and uses a
  schema-versioned `pages` structure for both single-page and multi-page exports.
  Re-exporting the same output without metadata, or with no metadata values,
  removes any stale sidecar for that output.
  The default can be changed project-wide by setting
  `options(gridify.export.metadata = "sidecar")`.
* Added support for `fill_empty = NA` in the `paginate_table()` function.

## Bug fixes

* When `fill_empty` in the `paginate_table()` function is a character value, 
  the final paginated table now coerces columns to character before filling empty cells (#20).

## Miscellaneous

* Added the active lifecycle badge to `README.md` file (#17).

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
