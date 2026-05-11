# gridify 0.7.7.9000

* `export_to()` gains a `metadata` argument that records `set_cell()` text values
  alongside the exported output. With the default `metadata = "sidecar"` a JSON
  sidecar `<file>.json` is written next to the output; `metadata = "embed"`
  (PDF only) injects the same JSON payload as the PDF `/Title` so the metadata
  travels inside the file. Set `metadata = "none"` to disable the feature.


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
