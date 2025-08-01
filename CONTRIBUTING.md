# Contributing to gridify

This outlines how to propose a change to gridify.

### License

All your contributions will be covered by this project's LICENSE.

### Fixing typos

Small typos or grammatical errors in documentation may be edited directly using
the GitHub web interface, so long as the changes are made in the _source_ file.

*  YES: you edit a roxygen comment in a `.R` file below `R/`.
*  NO: you edit an `.Rd` file below `man/`.

### Prerequisites

Before you make a substantial pull request, you should always file an issue and
make sure someone from the team agrees that it's a problem or accepted new feature. 
If you've found a bug, create an associated issue and illustrate the bug with a minimal 
[reprex](https://www.tidyverse.org/help/#reprex). 

New developers can view the UML diagram for a detailed overview of the
package’s design and class relationships using the mermaid code from
`inst/UML/UML_graph.md`.

`system.file("UML/UML_graph.md", package = "gridify")`

### Pull request process

*  We recommend that you create a Git branch for each pull request (PR).  
*  Look at the CI build status before and after making changes.
The `README` should contain badges for any continuous integration services used
by the package.  
*  New code should follow the tidyverse [style guide](http://style.tidyverse.org).
You should use the [styler](https://CRAN.R-project.org/package=styler) package to
apply these styles, but please don't restyle code that has nothing to do with 
your PR.  
*  We use [roxygen2](https://cran.r-project.org/package=roxygen2), with
[Markdown syntax](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd-formatting.html), 
for documentation.  
*  We use [testthat](https://cran.r-project.org/package=testthat). Contributions
with test cases included are easier to accept.  
*  For user-facing changes, add a bullet to the top of `NEWS.md` below the current
development version header describing the changes made followed by your GitHub
username, and links to relevant issue(s)/PR(s).
*  Suppose your changes are related to a current issue in the current project; please name your branch as follows: `<issue_id>_<short_description>`. 
Please use underscore (`_`) as a delimiter for word separation.

### Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to
abide by its terms.
