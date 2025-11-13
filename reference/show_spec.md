# Show the layout specifications of a gridifyClass or gridifyLayout

Method for showing the specifications of the layout in a gridifyClass or
gridifyLayout object, including, but not limited to:

- Layout dimensions

- Heights of rows

- Widths of columns

- Margins

- Graphical parameters defined in the layout.

- Default specs per cell.

## Usage

``` r
show_spec(object)

# S4 method for class 'gridifyLayout'
show_spec(object)

# S4 method for class 'gridifyClass'
show_spec(object)
```

## Arguments

- object:

  A gridifyClass or gridifyLayout object.

## Value

A print out of the specifications of a gridifyClass or gridifyLayout
object.

## Examples

``` r
show_spec(complex_layout())
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

# (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
library(magrittr)

g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = simple_layout()
) %>%
  set_cell("title", "TITLE")

show_spec(g)
#> Layout dimensions:
#>   Number of rows: 3
#>   Number of columns: 1
#> 
#> Heights of rows:
#>   Row 1: 0 lines
#>   Row 2: 1 null
#>   Row 3: 0 lines
#> 
#> Widths of columns:
#>   Column 1: 1 npc
#> 
#> Object Position:
#>   Row: 2
#>   Col: 1
#>   Width: 1
#>   Height: 1
#> 
#> Object Row Heights:
#>   Row 2: 1 null
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
#>   title:
#>     row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   footer:
#>     row:3, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 

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

show_spec(g)
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
```
