# Show the cells in a gridify object or layout

Method for showing the cells of a gridifyClass or gridifyLayout object.
It prints the names of the cells and for gridifyClass it indicates
whether each cell is filled or empty.

## Usage

``` r
show_cells(object)

# S4 method for class 'gridifyClass'
show_cells(object)

# S4 method for class 'gridifyLayout'
show_cells(object)
```

## Arguments

- object:

  A gridifyClass or gridifyLayout object.

## Value

A print out of the available cells and for gridifyClass indicates
whether each cell is filled or empty.

## Examples

``` r
show_cells(complex_layout())
#> Cells:
#>   header_left
#>   header_middle
#>   header_right
#>   title
#>   subtitle
#>   note
#>   footer_left
#>   footer_middle
#>   footer_right

# (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
library(magrittr)

g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = simple_layout()
) %>%
  set_cell("title", "TITLE")

show_cells(g)
#> Cells:
#>   title: filled
#>   footer: empty

g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = complex_layout()
) %>%
  set_cell("header_left", "Left Header") %>%
  set_cell("header_right", "Right Header") %>%
  set_cell("title", "Title") %>%
  set_cell("note", "Note") %>%
  set_cell("footer_left", "Left Footer") %>%
  set_cell("footer_right", "Right Footer")

show_cells(g)
#> Cells:
#>   header_left: filled
#>   header_middle: empty
#>   header_right: filled
#>   title: filled
#>   subtitle: empty
#>   note: filled
#>   footer_left: filled
#>   footer_middle: empty
#>   footer_right: filled
```
