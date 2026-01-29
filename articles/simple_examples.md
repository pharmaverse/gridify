# Simple Examples

## Introduction

This document provides simple examples to illustrate the use of
`gridify` to add headers, footers and more to both figures and tables.

We will cover the use of
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md),
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md),
[`pharma_layout_base()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_base.md),
[`pharma_layout_A4()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_A4.md)
and
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md),
and show how to add these layouts to `ggplot2` figures, base R figures,
`flextables`, and `gt` tables.

`gridify` does not support `rtables` directly, but we will demonstrate
how users can implement `gridify` with `rtables` by converting them to
`flextables` (with **rtables.officer**).

## Examples with Figures

We can use `gridify` with both `ggplot2` figures and base R figures.

### Examples with `ggplot2` Figures

#### Precedence of Operators

When using the `ggplot2` package in conjunction with pipes (`%>%` or
native `|>`), it’s important to understand the precedence of operators
to ensure your code works as expected.

In R, the pipe operator (`%>%` or `|>`) has a higher precedence than the
addition operator (`+`) used by `ggplot2`. This means that the `%>%` or
`|>` operator will be evaluated before the `+` operator.

Because of this, if you’re piping into a `ggplot2` call, you need to
wrap it in brackets `()` or [`{}`](https://rdrr.io/r/base/Paren.html).
This ensures that the entire `ggplot2` call is evaluated first, before
the result is passed to the next function in the pipe.

Here’s an example:

``` r
# Load the necessary libraries
library(ggplot2)
# (to use |> version 4.1.0 of R is required, for lower versions we recommend %>% from magrittr)
library(magrittr)

# Create a scatter plot
mtcars %>%
  {
    ggplot2::ggplot(., aes(x = mpg, y = wt)) +
      ggplot2::geom_point()
  } %>%
  print()
```

![](simple_examples_files/figure-html/unnamed-chunk-2-1.png)

#### Simple Layout Example

Here we create a line plot of `mpg` against `wt` using the `mtcars`
dataset.

``` r
library(gridify)
fig_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()
```

We then use the
[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)
function to apply
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md).

``` r
g <- gridify(fig_obj, layout = simple_layout())
```

Next, we use the
[`set_cell()`](https://pharmaverse.github.io/gridify/reference/set_cell.md)
function to add a title and footer to our figure before printing it.

``` r
g <- g %>%
  set_cell("title", "Title") %>%
  set_cell("footer", "Footer")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-5-1.png)

#### Complex Layout Example

Here we create a line plot of `mpg` against `wt` using the `mtcars`
dataset.

``` r
fig_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()
```

We then use
[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)
to apply
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md).

``` r
g <- gridify(fig_obj, layout = complex_layout()) %>%
  set_cell("header_left", "Left Header") %>%
  set_cell("header_middle", "Middle Header") %>%
  set_cell("header_right", "Right Header") %>%
  set_cell("title", "Title") %>%
  set_cell("subtitle", "Subtitle") %>%
  set_cell("note", "Note") %>%
  set_cell("footer_left", "Left Footer") %>%
  set_cell("footer_middle", "Middle Footer") %>%
  set_cell("footer_right", "Right Footer")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-7-1.png)

#### Pharma Layout Examples

Pharma layout base, letter, and A4 are specific layouts for
pharmaceutical outputs provided by the `gridify` package. They have
identical predefined cells for headers, footers, titles, subtitles,
notes, watermarks, and references. Some of these cells are set by
default but can be overwritten.

##### Pharma Layout Base Example

Here we create a line plot of `mpg` against `wt` using the `mtcars`
dataset. We then use the
[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)
function to apply
[`pharma_layout_base()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_base.md).

``` r
figure_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()

g <- gridify(object = figure_obj, layout = pharma_layout_base()) %>%
  set_cell("header_left_1", "Left Header 1") %>%
  set_cell("header_left_2", "Left Header 2") %>%
  set_cell("header_left_3", "Left Header 3") %>%
  set_cell("header_right_1", "Right Header 1") %>%
  set_cell("header_right_2", "Right Header 2") %>%
  set_cell("header_right_3", "Right Header 3") %>%
  set_cell("output_num", "Output") %>%
  set_cell("title_1", "Title 1") %>%
  set_cell("title_2", "Title 2") %>%
  set_cell("title_3", "Title 3") %>%
  set_cell("by_line", "By Line") %>%
  set_cell("note", "Note") %>%
  set_cell("references", "References") %>%
  set_cell("footer_left", "Left Footer") %>%
  set_cell("footer_right", "Right Footer") %>%
  set_cell("watermark", "Watermark")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-8-1.png)

##### Pharma Layout Letter Example

Here we apply
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md)
with just the main cells filled in.

``` r
figure_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()

g <- gridify(object = figure_obj, layout = pharma_layout_letter()) %>%
  set_cell("header_left_1", "My Company") %>%
  set_cell("header_left_2", "<PROJECT> / <INDICATION>") %>%
  set_cell("header_left_3", "<STUDY>") %>%
  set_cell("header_right_2", "<Draft or Final>") %>%
  set_cell("output_num", "<Figure> xx.xx.xx") %>%
  set_cell("title_1", "<Title 1>") %>%
  set_cell("title_2", "<Title 2>") %>%
  set_cell("note", "<Note or Footnotes>") %>%
  set_cell("references", "<References:>") %>%
  set_cell("footer_left", "Program: <PROGRAM NAME>, YYYY-MM-DD at HH:MM") %>%
  set_cell("footer_right", "Page xx of nn") %>%
  set_cell("watermark", "Draft")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-9-1.png)

##### Pharma Layout A4 Example

Here we apply
[`pharma_layout_A4()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_A4.md)
to the prior example. Note the difference in the margin on the right for
the A4 sized output.

``` r
figure_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()

g <- gridify(object = figure_obj, layout = pharma_layout_A4()) %>%
  set_cell("header_left_1", "My Company") %>%
  set_cell("header_left_2", "<PROJECT> / <INDICATION>") %>%
  set_cell("header_left_3", "<STUDY>") %>%
  set_cell("header_right_2", "<Draft or Final>") %>%
  set_cell("output_num", "<Figure> xx.xx.xx") %>%
  set_cell("title_1", "<Title 1>") %>%
  set_cell("title_2", "<Title 2>") %>%
  set_cell("note", "<Note or Footnotes>") %>%
  set_cell("references", "<References:>") %>%
  set_cell("footer_left", "Program: <PROGRAM NAME>, YYYY-MM-DD at HH:MM") %>%
  set_cell("footer_right", "Page xx of nn") %>%
  set_cell("watermark", "Draft")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-10-1.png)

### Example with a Base R Figure

The `gridify` package can also be used with base R figures. To use base
R figures with `gridify`, we first convert them to a formula using `~`,
before passing them to
[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md).

In this example, we create a simple base R bar plot and convert it to a
formula using `~`.

``` r
formula_object <- ~ barplot(1:10)
```

Then we pass the formula to
[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)
and apply
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md).

``` r
g <- gridify(object = formula_object, layout = complex_layout()) %>%
  set_cell("header_left", "Left Header") %>%
  set_cell("header_middle", "Middle Header") %>%
  set_cell("header_right", "Right Header") %>%
  set_cell("title", "Title") %>%
  set_cell("subtitle", "Subtitle") %>%
  set_cell("note", "Note") %>%
  set_cell("footer_left", "Left Footer") %>%
  set_cell("footer_middle", "Middle Footer") %>%
  set_cell("footer_right", "Right Footer")
#> Loading required namespace: gridGraphics

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-12-1.png)

## Examples with Tables

We can add text elements using all the previously mentioned layouts to
`flextable` and `gt` tables using `gridify`. `rtables` objects are not
directly supported by `gridify`, but we can use `gridify` with `rtables`
by first converting them to `flextables`.

### Example with a `flextable`

Here we create a `flextable` using the `mtcars` dataset.

``` r
# (to use `gridify` with flextables we require the function `as_grob()` to convert flextables into grob
# objects, which exists in versions >= 0.8.0 of `flextable`)

library(flextable)

ft <- flextable::flextable(head(mtcars[1:10]))
```

Then we pass the table to
[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)
and apply
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md).

``` r
g <- gridify(object = ft, layout = pharma_layout_letter()) %>%
  set_cell("header_left_1", "My Company") %>%
  set_cell("header_left_2", "<PROJECT> / <INDICATION>") %>%
  set_cell("header_left_3", "<STUDY>") %>%
  set_cell("header_right_2", "<Draft or Final>") %>%
  set_cell("output_num", "<Table> xx.xx.xx") %>%
  set_cell("title_1", "<Title 1>") %>%
  set_cell("title_2", "<Title 2>") %>%
  set_cell("note", "<Note or Footnotes>") %>%
  set_cell("references", "<References:>") %>%
  set_cell("footer_left", "Program: <PROGRAM NAME>, YYYY-MM-DD at HH:MM") %>%
  set_cell("footer_right", "Page xx of nn") %>%
  print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-14-1.png)

### Example with a `gt` Table

Here we create a `gt` table using the `mtcars` dataset.

``` r
# (to use `gridify` with gt tables we require the function `as_gtable()` to convert gt tables into
# grob objects, which exists in versions >= 0.11.0 of `gt`)

library(gt)

gt_obj <- gt::gt(head(mtcars[1:10]))
```

Then we pass the table to
[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)
and apply
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md).

``` r
g <- gridify(object = gt_obj, layout = pharma_layout_letter()) %>%
  set_cell("header_left_1", "My Company") %>%
  set_cell("header_left_2", "<PROJECT> / <INDICATION>") %>%
  set_cell("header_left_3", "<STUDY>") %>%
  set_cell("header_right_2", "<Draft or Final>") %>%
  set_cell("output_num", "<Table> xx.xx.xx") %>%
  set_cell("title_1", "<Title 1>") %>%
  set_cell("title_2", "<Title 2>") %>%
  set_cell("note", "<Note or Footnotes>") %>%
  set_cell("references", "<References:>") %>%
  set_cell("footer_left", "Program: <PROGRAM NAME>, YYYY-MM-DD at HH:MM") %>%
  set_cell("footer_right", "Page xx of nn")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-16-1.png)

### Example with an `rtable` via `flextable` conversion

We will demonstrate how to use `gridify` with `rtables` by converting
the `rtable` to a `flextable` and then modifying any aesthetics.

Here we build a simple `rtable` using the `iris` dataset.

``` r
library(rtables)
rtabl <- rtables::basic_table(main_footer = " ") %>%
  rtables::split_cols_by("Species") %>%
  rtables::analyze(
    c("Sepal.Length", "Sepal.Width", "Petal.Length"),
    function(x, ...) {
      rtables::in_rows(
        "Mean (sd)" = c(mean(x), stats::sd(x)),
        "Median" = median(x),
        "Min - Max" = range(x),
        .formats = c("xx.xx (xx.xx)", "xx.xx", "xx.xx - xx.xx")
      )
    }
  ) %>%
  rtables::build_table(iris)
```

Then we convert the `rtable` to a `flextable` using the function
[`tt_to_flextable()`](https://insightsengineering.github.io/rtables.officer/latest-release/reference/tt_to_flextable.html)
from the `rtables.officer` package. We specify `theme = NULL` to prevent
the addition of borders which
[`tt_to_flextable()`](https://insightsengineering.github.io/rtables.officer/latest-release/reference/tt_to_flextable.html)
adds by default.

``` r
library(rtables.officer)

ft <- rtables.officer::tt_to_flextable(rtabl, theme = NULL)
```

Next we adjust some of the aesthetics of the `flextable`.

``` r
ft <- flextable::font(ft, fontname = "serif", part = "all")
```

Finally we pass the `flextable` to
[`gridify()`](https://pharmaverse.github.io/gridify/reference/gridify.md)
and apply
[`pharma_layout_A4()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_A4.md),
before printing the table.

``` r
g <- gridify(ft, layout = pharma_layout_A4()) %>%
  set_cell("header_left_1", "My Company") %>%
  set_cell("header_left_2", "PROJECT") %>%
  set_cell("header_left_3", "STUDY") %>%
  set_cell("header_right_1", "CONFIDENTIAL") %>%
  set_cell("header_right_2", "Draft") %>%
  set_cell("header_right_3", "Data Cut-off: 2000-01-01") %>%
  set_cell("output_num", "<Table> xx.xx.xx") %>%
  set_cell("title_1", "Summary Table for Iris Dataset") %>%
  set_cell("note", "Note") %>%
  set_cell("references", "References") %>%
  set_cell("footer_left", sprintf("Program: My Programme, %s at %s", Sys.Date(), format(Sys.time(), "%H:%M"))) %>%
  set_cell("footer_right", "Page 1 of 1") %>%
  set_cell("watermark", "DRAFT")

print(g)
```

## Using the `show()` Methods

When using `gridify`, we can utilize the
[`show()`](https://rdrr.io/r/methods/show.html) methods to find out
information such as the cells available in a `gridify` object or the
specifications of a layout object.

Here we take the earlier example where we applied
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md)
to a line plot.

``` r
fig_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()

g <- gridify(fig_obj, layout = simple_layout())
```

To access the available cells in a `gridify` object, we can use the
[`show()`](https://rdrr.io/r/methods/show.html) method.

``` r
show(g)
```

Alternatively, you can simply evaluate the object. This will display the
cells included in the applied layout, and whether or not they have been
filled by the `gridify` object.

``` r
g
#> gridifyClass object
#> ---------------------
#> Please run `show_spec(object)` or print the layout to get more specs.
#> 
#> Cells:
#>   title: empty
#>   footer: empty
```

![](simple_examples_files/figure-html/unnamed-chunk-23-1.png)

As stated in the console output from the above example, we can use
`show_spec(g)` to gain further insight into the specifications of `g`’s
layout.

``` r
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
#>   transparent
#> 
#> Default Cell Info:
#>   title:
#>     row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   footer:
#>     row:3, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0,
```

We can do the same with
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md)
(and any other layout) if we want to view its specs.

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
#>   transparent
#> 
#> Default Cell Info:
#>   title:
#>     row:1, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0, 
#>   footer:
#>     row:3, col:1, text:NULL, mch:Inf, x:0.5, y:0.5, hjust:0.5, vjust:0.5, rot:0,
```

**Note:** This is effectively the same as calling
`show_spec(simple_layout)`.

## Graphical Parameters

Within every layout function, you can set the global graphical
parameters for all text elements and default graphical parameters for
individual text elements. You can use the
[`show_spec()`](https://pharmaverse.github.io/gridify/reference/show_spec.md)
function to see if global and default graphical parameters are set.

You can alter individual graphical parameters using the
[`set_cell()`](https://pharmaverse.github.io/gridify/reference/set_cell.md)
function. Setting a value at the individual level supersedes the global
level.

If not specified in your function calls, the defaults within the
`gridify` function are used.

Please read more about Default Graphical Parameters in
[`vignette("create_custom_layout", package = "gridify")`](https://pharmaverse.github.io/gridify/articles/create_custom_layout.md).

To see all available graphical parameters view [grid::gpar
documentation](https://www.rdocumentation.org/packages/grid/versions/3.6.2/topics/gpar).

### Global and Individual Graphical Parameters Example

Here is an example where we set global graphical parameters to a complex
layout. We set the font colour to `"navy"`, and font size to `12`.

``` r
figure_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()

g <- gridify(object = figure_obj, layout = complex_layout(global_gpar = grid::gpar(col = "navy", fontsize = 12))) %>%
  set_cell("header_left", "Left Header") %>%
  set_cell("header_middle", "Middle Header") %>%
  set_cell("title", "Title") %>%
  set_cell("subtitle", "Subtitle") %>%
  set_cell("note", "Note") %>%
  set_cell("footer_left", "Left Footer") %>%
  set_cell("footer_middle", "Middle Footer") %>%
  set_cell("footer_right", "Right Footer")
```

Now we set individual graphical parameters for the `right_header`. We
set the font colour to `"purple"` and the font size to `20`.

``` r
g <- g %>%
  set_cell("header_right", "Right Header", gpar = grid::gpar(col = "purple", fontsize = 20))

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-27-1.png)

## Background Colour Example

Here is an example of how to set the background colour using the
`background` argument in
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md).
By default, it uses `grid::get.gpar()$fill` (white background). In this
example, we set the background colour to `"beige"`.

The `background` argument works across all built-in layout functions,
including
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md),
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md),
[`pharma_layout_base()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_base.md),
[`pharma_layout_A4()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_A4.md),
and
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md).
It can also be applied in any custom layouts you create
([`vignette("create_custom_layout", package = "gridify")`](https://pharmaverse.github.io/gridify/articles/create_custom_layout.md)).

**Note:** When using `ggplot2`, you may also need to set the plot’s
background colour to match the layout’s background.

``` r
figure_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::theme(
    plot.background = ggplot2::element_rect(fill = "beige", colour = NA),  # Entire plot background
    panel.background = ggplot2::element_rect(fill = "beige", colour = NA),     # Panel (where data is plotted)
    panel.border = ggplot2::element_rect(colour = "black", fill = NA)
  ) +
  ggplot2::geom_line()

g <- gridify(figure_obj, layout = simple_layout(background = "beige")) %>%
  set_cell("title", "Title") %>%
  set_cell("footer", "Footer")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-28-1.png)

## `set_cell()` Arguments

As well as adjusting the individual graphical parameters as shown above,
we can also use
[`set_cell()`](https://pharmaverse.github.io/gridify/reference/set_cell.md)
to customise various features such as maximum characters per line,
position, and rotation for text elements.

### Maximum Characters

We can specify the maximum number of characters per line using the
argument `mch`. This is useful for wrapping long strings across multiple
lines.

Here is an example of a figure with
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md)
applied. We set the footer to a long string, and then set the maximum
number of characters per line to `45` using the `mch` argument.

``` r
figure_obj <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
  ggplot2::geom_line()

long_footer_string <- paste0(
  "This is a footer. We can have a long description here.",
  "We can have another long description here.",
  "We can have another long description here."
)

g <- gridify(figure_obj, layout = simple_layout()) %>%
  set_cell("title", "Title") %>%
  set_cell("footer", long_footer_string, mch = 45)

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-29-1.png)

### Position and Rotation

We can also use
[`set_cell()`](https://pharmaverse.github.io/gridify/reference/set_cell.md)
to adjust position and rotation of text elements:

- `x` and `y` define the x and y coordinates of the text element. For
  example `x = 0` places the element at the far left and `x = 1` at the
  far right.

- `hjust` and `vjust` control how the text element is anchored relative
  to the `x` or `y` point. For instance:

  - `hjust = 0` aligns the left edge of the element to `x`.
  - `hjust = 0.5` centers the element at `x`.
  - `hjust = 1` aligns the right edge of the element to `x`.

- `vjust` works in a similar way with `y`.

  - `vjust = 0` aligns the bottom edge of the element to `y`.
  - `vjust = 0.5` centers the element at `y`.
  - `vjust = 1` aligns the top edge of the element to `y`.

- `rot` sets the rotation angle of the text element in degrees, applied
  anticlockwise from the x-axis.

`x`, `y`, `hjust`, and `vjust` all take values between `0` and `1`.

We now take the previous example and apply `x = 0`, `hjust = 0`, and
`rot = 5` to the footer. This aligns the left edge of the footer to the
left corner of the cell, with a rotation of 5 degrees.

``` r
g <- gridify(figure_obj, layout = simple_layout()) %>%
  set_cell("title", "Title") %>%
  set_cell("footer", long_footer_string, mch = 45, x = 0, hjust = 0, rot = 5)

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-30-1.png)

## Altering Scales and Adjusting Dimensions

When using the
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md)
and
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md)
functions, there is an optional `scales` argument which can be either
`"fixed"` (default) or `"free"`.

The `"fixed"` scale ensures that cells for text elements (titles,
footers, etc.) retain a static height, with the figure / table taking up
the remaining space. This prevents text overlap while maintaining a
structured layout, but may result in different height proportions
between the text elements and the output. The `"free"` scale sets the
heights of the cells to be proportional to the size of the output.

Here is an example of a figure with
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md)
and the default `scales = "fixed"` applied.

``` r
fixed_scales_g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = complex_layout()
) %>%
  set_cell("header_right", "Right Header") %>%
  set_cell("title", "Title", gpar = grid::gpar(fontsize = 30)) %>%
  set_cell("subtitle", "Subtitle", gpar = grid::gpar(fontsize = 30)) %>%
  set_cell("note", "Note", gpar = grid::gpar(fontsize = 30)) %>%
  set_cell("footer_left", "Left Footer", hjust = 1, vjust = 0.5, gpar = grid::gpar(fontsize = 10)) %>%
  set_cell("footer_middle", "Middle Footer", gpar = grid::gpar(fontsize = 30)) %>%
  set_cell("footer_right", "Right Footer", hjust = 0, vjust = 0.5, gpar = grid::gpar(fontsize = 10))

print(fixed_scales_g)
```

![](simple_examples_files/figure-html/unnamed-chunk-31-1.png)

When we apply `scales = "free"` text elements scale dynamically, which
may cause overlap if the output space is small.

``` r
free_scales_g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = complex_layout(scales = "free")
) %>%
  set_cell("header_right", "Right Header") %>%
  set_cell("title", "Title", gpar = grid::gpar(fontsize = 30)) %>%
  set_cell("subtitle", "Subtitle", gpar = grid::gpar(fontsize = 30)) %>%
  set_cell("note", "Note", gpar = grid::gpar(fontsize = 30)) %>%
  set_cell("footer_left", "Left Footer", hjust = 1, vjust = 0.5, gpar = grid::gpar(fontsize = 10)) %>%
  set_cell("footer_middle", "Middle Footer", gpar = grid::gpar(fontsize = 30)) %>%
  set_cell("footer_right", "Right Footer", hjust = 0, vjust = 0.5, gpar = grid::gpar(fontsize = 10))

print(free_scales_g)
```

![](simple_examples_files/figure-html/unnamed-chunk-32-1.png)

When working with `.Rmd` or `.Qmd` files, we can also remove the text
overlap when `scales = "free"` by adjusting the `knitr` options
`fig.width` and `fig.height` to expand the output.

``` r
print(free_scales_g)
```

![](simple_examples_files/figure-html/unnamed-chunk-33-1.png)

When exporting to `.pdf`, `.png` or `.jpeg` we can remove text overlap
by adjusting `width` and `height` whilst using the
[`export_to()`](https://pharmaverse.github.io/gridify/reference/export_to.md)
function. This will be explained in more detail in the section
[Exporting to PDF, PNG, TIFF, and JPEG](#exporting-section) below.

### Adjusting the Height of Rows using Global Options

`gridify` provides two global options (`gridify.adjust_height.default`
and `gridify.adjust_height.line`) for adjusting row heights in layouts,
based on measurement height units and when `adjust_height` (a layout
argument) equals `TRUE`.

It is not recommended to set these options unless truly needed, as it
may lead to inconsistencies between projects.

#### How These Options Work

By default:

- For non-line units (`"cm"`, `"inches"`, `"mm"`), row heights are
  adjusted by `0.25`.
- For line-based units (`"lines"`), row heights are adjusted by `0.10`.

These values can be increased to create more spacing between text
elements using the following global options:

- `gridify.adjust_height.default` – applies when row heights are in
  `"cm"`, `"inches"`, or `"mm"`.
- `gridify.adjust_height.line` – applies when row heights are in
  `"lines"`.

Please note that these options will **not** affect any row with a unit
of `"npc"`, as then the row height is not defined by a measurement but a
percentage of available height. These options will work only with height
units `"cm"`, `"inch"`, `"mm"`, or `"lines"` and when the
`adjust_height` argument equals `TRUE`.

For
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md)
and
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md):

- When `scales = "free"`, the height unit is `"npc"` (not supported by
  either adjustment option).
- When `scales = "fixed"` (the default), the height unit is `"lines"`,
  making only `gridify.adjust_height.line` applicable.
- `adjust_height` is always set to `TRUE` within the function code.

For
[`pharma_layout_base()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_base.md),
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md)
and
[`pharma_layout_A4()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_A4.md):

- The height unit is `"lines"`, making only `gridify.adjust_height.line`
  applicable.
- The `adjust_height` argument is `TRUE` by default, so users do not
  have to set this argument.

In summary, only `gridify.adjust_height.line` is applicable to
predefined layouts, and for
[`simple_layout()`](https://pharmaverse.github.io/gridify/reference/simple_layout.md)
and
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md),
only when `scales = "fixed"`.

In contrast, `gridify.adjust_height.default` is not applicable to any
predefined layout. It can instead be used with custom layouts in a
similar way to `gridify.adjust_height.line` - see
[`vignette("create_custom_layout", package = "gridify")`](https://pharmaverse.github.io/gridify/articles/create_custom_layout.md).

#### Examples using Global Options

**Example with
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md)**

Here is an example of the use of `gridify.adjust_height.line` with
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md).
We create a `gridify` object by applying
[`complex_layout()`](https://pharmaverse.github.io/gridify/reference/complex_layout.md)
with `scales = "fixed"` to a line plot and print the object to view it
with default adjustments.

``` r
g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = complex_layout()
) %>%
  set_cell("header_left", "Left Header") %>%
  set_cell("header_middle", "Middle Header") %>%
  set_cell("header_right", "Right Header") %>%
  set_cell("title", "Title") %>%
  set_cell("subtitle", "Subtitle") %>%
  set_cell("note", "Note") %>%
  set_cell("footer_left", "Left Footer") %>%
  set_cell("footer_middle", "Middle Footer") %>%
  set_cell("footer_right", "Right Footer")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-34-1.png)

Now we set `gridify.adjust_height.line` to `0.7` using the
[`options()`](https://rdrr.io/r/base/options.html) function. This
increases the height of the rows and the space between text elements.

``` r
options(gridify.adjust_height.line = 0.7)

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-35-1.png)

**Example with
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md)**

Here is an example of the use of `gridify.adjust_height.line` with
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md).
We set the `gridify.adjust_height.line` option back to the default of
`0.1`. Then we create a `gridify` object by applying
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md)
to a line plot.

``` r
options(gridify.adjust_height.line = 0.1)

g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = pharma_layout_letter()
) %>%
  set_cell("header_left_1", "My Company") %>%
  set_cell("header_left_2", "<PROJECT> / <INDICATION>") %>%
  set_cell("header_left_3", "<STUDY>") %>%
  set_cell("header_right_2", "<Draft or Final>") %>%
  set_cell("output_num", "<Figure> xx.xx.xx") %>%
  set_cell("note", "<Note or Footnotes>") %>%
  set_cell("references", "<References:>") %>%
  set_cell("footer_left", "Program: <PROGRAM NAME>, YYYY-MM-DD at HH:MM") %>%
  set_cell("footer_right", "Page xx of nn")

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-36-1.png)

Now we set `gridify.adjust_height.line` to `0.7`.

``` r
options(gridify.adjust_height.line = 0.7)

print(g)
```

![](simple_examples_files/figure-html/unnamed-chunk-37-1.png)

## Export to PDF, PNG, TIFF, and JPEG

We can export `gridify` objects to PDF, PNG, TIFF, and JPEG files using
the
[`export_to()`](https://pharmaverse.github.io/gridify/reference/export_to.md)
function.

Here is an example where we export a `gridify` object to a PDF file.

We take the earlier example where we applied
[`pharma_layout_letter()`](https://pharmaverse.github.io/gridify/reference/pharma_layout_letter.md)
to a line plot.

``` r
gridify_obj <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = pharma_layout_letter()
) %>%
  set_cell("header_left_1", "My Company") %>%
  set_cell("header_left_2", "<PROJECT> / <INDICATION>") %>%
  set_cell("header_left_3", "<STUDY>") %>%
  set_cell("header_right_2", "<Draft or Final>") %>%
  set_cell("output_num", "<Figure> xx.xx.xx") %>%
  set_cell("title_1", "<Title 1>") %>%
  set_cell("title_2", "<Title 2>") %>%
  set_cell("note", "<Note or Footnotes>") %>%
  set_cell("references", "<References:>") %>%
  set_cell("footer_left", "Program: <PROGRAM NAME>, YYYY-MM-DD at HH:MM") %>%
  set_cell("footer_right", "Page xx of nn") %>%
  set_cell("watermark", "Draft")
```

Then we pass the `gridify` object to the
[`export_to()`](https://pharmaverse.github.io/gridify/reference/export_to.md)
function. We specify the desired file type and name using the `to`
argument.

``` r
export_to(gridify_obj, to = "output.pdf")
```

Instead of just a file name, the `to` argument can also be set to a file
path if we want to change the location where the file is saved.

``` r
export_to(gridify_obj, to = "~/folder1/output.pdf")
```

To export the object to a PNG file, we specify a file name with the
`.png` file extension.

``` r
export_to(gridify_obj, to = "output.png")
```

To export the object to a TIFF file, we specify a file name with the
`.tiff` or `.tif` file extension.

``` r
export_to(gridify_obj, to = "output.tiff")
```

Similarly, to export the object to a JPEG file, we specify a file name
with the `.jpeg` or `.jpg` file extension. We can also modify
characteristics such as `width` and `height` by passing them into
[`export_to()`](https://pharmaverse.github.io/gridify/reference/export_to.md)
after the `to` argument.

``` r
export_to(gridify_obj, to = "output.jpeg", width = 2400, height = 1800, res = 300)
```

## Conclusion

These examples should give you a good understanding of how to use the
`gridify` package to add text elements to simple figures and tables.
Remember, you can customize the layout and text elements to suit your
needs. Happy gridifying!

To see how to use `gridify` with more complex examples such as
multi-page figures and tables please check out
[`vignette("multi_page_examples", package = "gridify")`](https://pharmaverse.github.io/gridify/articles/multi_page_examples.md).
If you need a custom layout suited for your needs please check out
[`vignette("create_custom_layout", package = "gridify")`](https://pharmaverse.github.io/gridify/articles/create_custom_layout.md).
