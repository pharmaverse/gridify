% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gridify-methods.R
\name{show,gridifyClass-method}
\alias{show,gridifyClass-method}
\title{Show method for gridifyClass}
\usage{
\S4method{show}{gridifyClass}(object)
}
\arguments{
\item{object}{A gridifyClass object.}
}
\value{
The object with all the titles, subtitles, footnotes, and other text
elements around the output is printed in the graphics device.
A list is also printed to the console containing:
\itemize{
\item the dimensions of the layout
\item where the object is located in the layout
\item the size of the margin
\item any global graphical parameters
\item the list of elements cells and if they are filled or empty
}
}
\description{
Method for showing a gridifyClass object.
}
\examples{
g <- gridify(
  object = ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg, y = wt)) +
    ggplot2::geom_line(),
  layout = complex_layout()
)
show(g)
}
\seealso{
\code{\link[=gridify]{gridify()}}
}
