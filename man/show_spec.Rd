% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gridify-methods.R
\name{show_spec}
\alias{show_spec}
\alias{show_spec,gridifyLayout-method}
\alias{show_spec,gridifyClass-method}
\title{Show the layout specifications of a gridifyClass or gridifyLayout}
\usage{
show_spec(object)

\S4method{show_spec}{gridifyLayout}(object)

\S4method{show_spec}{gridifyClass}(object)
}
\arguments{
\item{object}{A gridifyClass or gridifyLayout object.}
}
\value{
A print out of the specifications of a gridifyClass or gridifyLayout object.
}
\description{
Method for showing the specifications of the layout in a gridifyClass or gridifyLayout object, including, but
not limited to:
\itemize{
\item Layout dimensions
\item Heights of rows
\item Widths of columns
\item Margins
\item Graphical parameters defined in the layout.
\item Default specs per cell.
}
}
\examples{
show_spec(complex_layout())

# (to use |> version 4.1.0 of R is required, for lower versions we recommend \%>\% from magrittr)
library(magrittr)

g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = simple_layout()
) \%>\%
  set_cell("title", "TITLE")

show_spec(g)

g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = complex_layout()
) \%>\%
  set_cell("header_left", "Left Header") \%>\%
  set_cell("header_right", "Right Header") \%>\%
  set_cell("title", "Title") \%>\%
  set_cell("note", "Note") \%>\%
  set_cell("footer_left", "Left Footer") \%>\%
  set_cell("footer_right", "Right Footer")

show_spec(g)
}
