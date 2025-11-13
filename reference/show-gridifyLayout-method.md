# Show method for gridifyLayout

Method for showing a gridifyLayout object. It prints the names of the
cells in the layout.

## Usage

``` r
# S4 method for class 'gridifyLayout'
show(object)
```

## Arguments

- object:

  A gridifyLayout object.

## Value

The list of cells defined in the layout.

## See also

[`gridifyLayout()`](https://pharmaverse.github.io/gridify/reference/gridifyLayout.md)

## Examples

``` r
show(complex_layout())
#> gridifyLayout object
#> ---------------------
#> Layout dimensions:
#>   Number of rows: 6
#>   Number of columns: 3
#> 
#> Heights of rows:
#>   Row 1: 0 lines
#>   Row 2: 0 lines
#>   Row 3: 0 lines
#>   Row 4: 1 null
#>   Row 5: 0 lines
#>   Row 6: 0 lines
#> 
#> Widths of columns:
#>   Column 1: 0.333333333333333 npc
#>   Column 2: 0.333333333333333 npc
#>   Column 3: 0.333333333333333 npc
#> 
#> Object Position:
#>   Row: 4
#>   Col: 1-3
#>   Width: 1
#>   Height: 1
#> 
#> Object Row Heights:
#>   Row 4: 1 null
#> 
#> Margin:
#>   Top: 0.1 npc
#>   Right: 0.1 npc
#>   Bottom: 0.1 npc
#>   Left: 0.1 npc
#> 
#> Global graphical parameters:
#>   Are not set
#> 
#> Background colour:
#>   white
#> 
#> Default Cell Info:
#>   header_left:
#>     row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   header_middle:
#>     row:1, col:2, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   header_right:
#>     row:1, col:3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   title:
#>     row:2, col:1-3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   subtitle:
#>     row:3, col:1-3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   note:
#>     row:5, col:1-3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   footer_left:
#>     row:6, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   footer_middle:
#>     row:6, col:2, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   footer_right:
#>     row:6, col:3, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#> 
```
