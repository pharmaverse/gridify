# Show method for gridifyClass

Method for showing a gridifyClass object.

## Usage

``` r
# S4 method for class 'gridifyClass'
show(object)
```

## Arguments

- object:

  A gridifyClass object.

## Value

The object with all the titles, subtitles, footnotes, and other text
elements around the output is printed in the graphics device. A list is
also printed to the console containing:

- the dimensions of the layout

- where the object is located in the layout

- the size of the margin

- any global graphical parameters

- the list of elements cells and if they are filled or empty

## See also

[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)

## Examples

``` r
g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = complex_layout()
)
show(g)
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   header_left: empty
#>   header_middle: empty
#>   header_right: empty
#>   title: empty
#>   subtitle: empty
#>   note: empty
#>   footer_left: empty
#>   footer_middle: empty
#>   footer_right: empty
```
