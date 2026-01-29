# Simple Layout for a gridify object

Creates a simple layout only containing two text element cells: a title
and a footer.

## Usage

``` r
simple_layout(
  margin = grid::unit(c(t = 0.1, r = 0.1, b = 0.1, l = 0.1), units = "npc"),
  global_gpar = grid::gpar(),
  background = grid::get.gpar()$fill,
  scales = c("fixed", "free")
)
```

## Arguments

- margin:

  A unit object specifying the margins around the output. Default is 10%
  of the output area on all sides.

- global_gpar:

  A gpar object specifying the global graphical parameters. Must be the
  result of a call to
  [`grid::gpar()`](https://rdrr.io/r/grid/gpar.html).

- background:

  A string specifying the background fill colour. Default
  `grid::get.gpar()$fill` for a white background.

- scales:

  A string, either `"free"` or `"fixed"`. By default, `"fixed"` ensures
  that text elements (titles, footers, etc.) retain a static height,
  preventing text overlap while maintaining a structured layout.
  However, this may result in different height proportions between the
  text elements and the output.

  The `"free"` option makes the row heights proportional, allowing them
  to scale dynamically based on the overall output size. This ensures
  that the text elements and the output maintain relative proportions.

## Value

A gridifyLayout object.

## Details

The layout consists of three rows, one each for the title, output, and
footer.  
The heights of the rows in simple_layout with `"free"` scales are 15%,
70% and 15% of the area respectively.  
The heights of the rows in simple_layout with `"fixed"` scales are
adjusted n number of lines for all text elements around the output and
the rest of the area taken up by the output.  
Please note that as output space is reduced, all text elements around
the output retain their space which makes the output appear smaller.

## Note

**The Font Issue Information:**

Changes to the fontfamily may be ignored by some devices, but is
supported by PostScript, PDF, X11, Windows, and Quartz. The fontfamily
may be used to specify one of the Hershey Font families (e.g.,
HersheySerif, serif), and this specification will be honoured on all
devices.

If you encounter this warning, you can register the fonts using the
`extrafont` package:

    library(extrafont)
    font_import()
    loadfonts(device = 'all')

If you still see the warning while using RStudio, try changing the
graphics backend.

**Negative Dimensions Issues:**

grobs from the grid package and ggplot2 objects (when converted to grobs
by gridify) may appear distorted in the output if there is insufficient
space in the window, caused by negative dimensions. This should be
resolved. However, if this is affecting your layout, please increase
your window size or only use static heights/widths for custom layouts.

The negative dimensions are caused by the way grid handles `null` and
`npc` heights/widths so if some dimensions are static, then the `npc` or
`null` values may cause unexpected behaviour when the window size is too
small. It was resolved by setting a minimum size of the object in the
gridify object to 1 inch for each dimension.

The following example demonstrates this behaviour Try resizing your
window:

    library(grid)
    library(ggplot2)
    grid.newpage()
    object <- ggplot2::ggplotGrob(ggplot(mtcars, aes(mpg, wt)) + geom_line())
    grid::grid.draw(
      grid::grobTree(
        grid::grobTree(
          grid::editGrob(
            object,
            vp = grid::viewport(
              # height = grid::unit.pmax(grid::unit(1, "npc"), grid::unit(1, "inch")),
              # width = grid::unit.pmax(grid::unit(1, "npc"), grid::unit(1, "inch"))
            )
          ),
          vp = grid::viewport(
            layout.pos.row = 2,
            layout.pos.col = 1:3
          )
        ),
        vp = grid::viewport(
          layout = grid::grid.layout(
            nrow = 3,
            ncol = 3,
            heights = grid::unit(c(9, 1, 9), c("cm", "null", "cm"))
          )
        )
      )
    )

**gt Font Size Issue:**

When specifying font sizes, the `gt` package interprets values as having
the unit pixels (`px`), whilst the `grid` package, on which `gridify` is
built, assumes points (`pt`). As a result, even if you set the font
sizes in both `gt` and `gridify` (using
[`grid::gpar()`](https://rdrr.io/r/grid/gpar.html)) to the same number,
they may still appear different. To convert point size to pixel size,
multiply the point size by `96 / 72`.

## Examples

``` r
simple_layout()
#> gridifyLayout object
#> ---------------------
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
#> 

# (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
library(magrittr)

gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = simple_layout()
) %>%
  set_cell("title", "TITLE") %>%
  set_cell("footer", "FOOTER")
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: filled


gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = simple_layout(
    margin = grid::unit(c(5, 2, 2, 2), "cm"),
    global_gpar = grid::gpar(fontsize = 20, col = "blue")
  )
) %>%
  set_cell("title", "TITLE") %>%
  set_cell("footer", "FOOTER")
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: filled


gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = simple_layout()
) %>%
  set_cell("title", "TITLE\nSUBTITLE", x = 0.7, gpar = grid::gpar(fontsize = 12)) %>%
  set_cell("footer", "FOOTER", x = 0.5, y = 0.5, gpar = grid::gpar())
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: filled
#>   footer: filled
```
