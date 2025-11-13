# Add text elements to a gridify cell

This function sets a text element for a specific cell in a gridify
object. The element can be positioned and rotated as desired, and its
graphical parameters can be customized.

## Usage

``` r
set_cell(
  object,
  cell,
  text,
  mch = NULL,
  x = NULL,
  y = NULL,
  hjust = NULL,
  vjust = NULL,
  rot = NULL,
  gpar = NULL,
  ...
)

# S4 method for class 'gridifyClass'
set_cell(
  object,
  cell,
  text,
  mch = NULL,
  x = NULL,
  y = NULL,
  hjust = NULL,
  vjust = NULL,
  rot = NULL,
  gpar = NULL,
  ...
)
```

## Arguments

- object:

  A gridifyClass object. (See note)

- cell:

  A single character string specifying the name of the cell.

- text:

  A single character string specifying the text of the element. When
  setting your string within the `text` argument, you can add new lines
  by using the newline character, `\n`.

- mch:

  A positive numeric value specifying the maximum number of characters
  per line. The functionality is based on the
  [`strwrap()`](https://rdrr.io/r/base/strwrap.html) function. By
  default, it avoids breaking up words and only splits lines when
  specified.

- x:

  A numeric value specifying the x (horizontal) location of the text
  element in the cell. Takes values between 0 and 1; 0 places the text
  element at the left side of the cell and 1 at the right side.

- y:

  A numeric value specifying the y (vertical) location of the text
  element in the cell. Takes values between 0 and 1; 0 places the text
  element at the bottom of the cell and 1 at the top.

- hjust:

  A numeric value specifying which part of the text element lines up
  with the x value. Adjusting this value changes how the text element is
  positioned horizontally relative to the x coordinate specified before.
  Takes values between 0 and 1; 0 aligns the left side of the text
  element with the x coordinate and 1 aligns the right side.

- vjust:

  A numeric value specifying which part of the text element lines up
  with the y value. Adjusting this value changes how the text element is
  positioned vertically relative to the y coordinate specified before.
  Takes values between 0 and 1; 0 aligns the bottom of the text element
  with the y coordinate and 1 aligns the top.

- rot:

  A numeric value specifying the rotation of the text element
  anticlockwise from the x-axis.

- gpar:

  A [`grid::gpar()`](https://rdrr.io/r/grid/gpar.html) object specifying
  the graphical parameters of the text element.

- ...:

  Additional arguments.

## Value

The gridifyClass object with the added text element.

## Details

`set_cell()` can also make minor adjustments to the positioning of the
text elements in the layout.

If the existing layouts generally meet your needs and you only require
additional lines in certain cells, there is no need to create a new
layout. By using the newline character, `\n`, within your text, you can
add as many new lines as desired. For all layouts with the default
`scales = "fixed"`, the layout will automatically adjust to fit the new
lines, ensuring no elements overlap.

For applying more substantial changes to a layout or when applying
adjustments across multiple objects and projects, it is recommended to
create a custom layout instead. This will promote reproducibility and
consistency across projects. See
[`vignette("create_custom_layout", package = "gridify")`](https://pharmaverse.github.io/gridify/articles/create_custom_layout.md)
for more information on how to create a custom layout.

## Note

The `object` argument has to be passed directly only when adding
`set_cell()` after a `gridify` object has already been defined. We do
NOT need to pass the `object` directly when using pipes. See first
example.

## See also

[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)

## Examples

``` r
# using set_cell() without the pipe operator
object <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()

g <- gridify(object = object, layout = simple_layout())
g <- set_cell(g, "title", "TITLE")
g
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: empty


# using set_cell() with the pipe operator
# (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
library(magrittr)

gridify(object = object, layout = simple_layout()) %>%
  set_cell("title", "TITLE")
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: empty


# using multiple lines in set_cell()
gridify(object, layout = simple_layout()) %>%
  set_cell(cell = "title", text = "THIS IS THE MAIN TITLE\nA Second Title\nSubtitle") %>%
  set_cell(
    cell = "footer", text = "This is a footer.\nWe can have multiple lines here as well.",
    x = 0, hjust = 0
  )
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: filled


# using mch in set_cell()
long_footer_string <- paste0(
  "This is a footer. We can have a long description here.",
  "We can have another long description here.",
  "We can have another long description here."
)
gridify(object, layout = simple_layout()) %>%
  set_cell(
    cell = "footer", long_footer_string, mch = 60, x = 0, hjust = 0
  )
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: empty
#>   footer: filled


# using the location and alignment arguments
# the left side of the text is on the left side of the cell
gridify(object = object, layout = simple_layout()) %>%
  set_cell("title", "TITLE", x = 0, hjust = 0)
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: empty


# the right side of the text is on the right side of the cell
gridify(object = object, layout = simple_layout()) %>%
  set_cell("title", "TITLE", x = 1, hjust = 1)
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: empty


# the right side of the text is 30% from the right side of the cell
gridify(object = object, layout = simple_layout()) %>%
  set_cell("title", "TITLE", x = 0.7, hjust = 1)
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: empty


# using the rotation argument
gridify(object = object, layout = simple_layout()) %>%
  set_cell("title", "TITLE", x = 0.7, rot = 45)
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: empty


# using the graphical parameters argument
gridify(object = object, layout = simple_layout()) %>%
  set_cell("title", "TITLE", x = 0.7, rot = 45, gpar = grid::gpar(fontsize = 20)) %>%
  set_cell("footer", "FOOTER", x = 0.2, y = 1, gpar = grid::gpar(col = "blue"))
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: filled
```
