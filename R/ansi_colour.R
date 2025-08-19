#' Add ANSI colour to a string
#'
#' @param text string
#' @param colour colour ("red", "green", etc.) to add. Defaults to "green".
#'
#' @return a character string with ANSI codes surrounding it.
#' @keywords internal
coloured_print <- function(text, colour = "green") {
  # Note ANSI colour codes
  colour_codes <- list(
    "black" = 30,
    "red" = 31,
    "green" = 32,
    "yellow" = 33,
    "blue" = 34,
    "magenta" = 35,
    "cyan" = 36,
    "white" = 37
  )

  if (!(colour %in% names(colour_codes))) {
    stop(
      sprintf(
        "Accepted colours for the colour argument of coloured_print are %s.",
        paste(names(colour_codes), collapse = ", ")
      )
    )
  }

  if (!(is.character(text) && length(text) == 1)) stop("text argument of coloured_print has to be a single string.")

  # Create ANSI version of colour
  ansi_colour <- paste0("\033[", colour_codes[[colour]], "m")

  paste0(ansi_colour, text, "\033[0m")
}
