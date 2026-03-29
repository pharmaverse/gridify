#' Shiny module to render a gridify object with size controls
#'
#' @name gridify_with_settings
#' @rdname gridify_with_settings
#'
#' @description
#' A Shiny module that renders a [`gridifyClass-class`] object (from [gridify()])
#' with height and width sliders, plus PNG and PDF download buttons.
#'
#' @param id (`character(1)`) Shiny module id.
#'
#' @seealso [gridify()], [set_cell()], [gridifyLayout()]
#'
#' @examples
#' if (interactive() && requireNamespace("shiny", quietly = TRUE) &&
#'     requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(shiny)
#'   library(ggplot2)
#'   library(gridify)
#'
#'   ui <- fluidPage(
#'     gridify_with_settings_ui("demo")
#'   )
#'
#'   server <- function(input, output, session) {
#'     gridify_r <- reactive({
#'       gridify(
#'         object = ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
#'           ggplot2::geom_point(),
#'         layout = simple_layout()
#'       ) |>
#'         set_cell("title", "My Plot")
#'     })
#'
#'     gridify_with_settings_srv("demo", gridify_r = gridify_r)
#'   }
#'
#'   shinyApp(ui, server)
#' }
NULL

#' @noRd
gridify_require_shiny <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop(
      "The 'shiny' package is required to use gridify_with_settings.\n",
      "Install it with: install.packages(\"shiny\")",
      call. = FALSE
    )
  }
}

#' @noRd
assert_hwvec <- function(x, nm) {
  if (!is.numeric(x) || length(x) != 3L || any(!is.finite(x))) {
    stop(
      "'", nm, "' must be a numeric vector of length 3 (value, min, max).",
      call. = FALSE
    )
  }
  if (x[1L] < x[2L] || x[1L] > x[3L]) {
    stop(
      "'", nm, "' value (", x[1L], ") must be between min (", x[2L],
      ") and max (", x[3L], ").",
      call. = FALSE
    )
  }
}

#' @rdname gridify_with_settings
#'
#' @return
#' `gridify_with_settings_ui()` returns a `shiny::sidebarLayout`.
#'
#' @export
gridify_with_settings_ui <- function(id) {
  gridify_require_shiny()
  if (!is.character(id) || length(id) != 1L) {
    stop("'id' must be a single character string.", call. = FALSE)
  }

  ns <- shiny::NS(id)

  shiny::sidebarLayout(
    sidebarPanel = shiny::sidebarPanel(
      width = 3,
      shiny::sliderInput(
        inputId = ns("height"),
        label = "Height (px)",
        min = 200L,
        max = 2000L,
        value = 600L,
        step = 10L,
        ticks = FALSE
      ),
      shiny::sliderInput(
        inputId = ns("width"),
        label = "Width (px)",
        min = 200L,
        max = 2000L,
        value = 800L,
        step = 10L,
        ticks = FALSE
      ),
      shiny::tags$hr(),
      shiny::downloadButton(ns("dl_png"), "PNG", class = "btn-sm"),
      shiny::tags$span("  "),
      shiny::downloadButton(ns("dl_pdf"), "PDF", class = "btn-sm")
    ),
    mainPanel = shiny::mainPanel(
      width = 9,
      shiny::uiOutput(ns("plot_ui"))
    )
  )
}

#' @rdname gridify_with_settings
#'
#' @param gridify_r (`reactive` or `function`)
#'   A `shiny::reactive()` (or plain function) returning a [`gridifyClass-class`]
#'   object produced by [gridify()].
#'
#' @param height (`numeric(3)`)
#'   Height slider values `c(value, min, max)` in pixels.
#'
#' @param width (`numeric(3)`)
#'   Width slider values `c(value, min, max)` in pixels.
#'
#' @return
#' `gridify_with_settings_srv()` invisibly returns `NULL`.
#'
#' @export
gridify_with_settings_srv <- function(
    id,
    gridify_r,
    height = c(600L, 200L, 2000L),
    width = c(800L, 200L, 2000L)) {

  gridify_require_shiny()

  if (!is.character(id) || length(id) != 1L) {
    stop("'id' must be a single character string.", call. = FALSE)
  }
  if (!inherits(gridify_r, c("function", "reactive"))) {
    stop("'gridify_r' must be a shiny::reactive() or a plain function.",
      call. = FALSE)
  }

  assert_hwvec(height, "height")
  assert_hwvec(width, "width")

  shiny::moduleServer(id, function(input, output, session) {

    shiny::observe({
      shiny::updateSliderInput(
        session, "height",
        min = height[2], max = height[3], value = height[1]
      )
      shiny::updateSliderInput(
        session, "width",
        min = width[2], max = width[3], value = width[1]
      )
    }) |> shiny::bindEvent(session$token, ignoreNULL = TRUE, once = TRUE)

    get_obj <- shiny::reactive({
      obj <- if (inherits(gridify_r, "reactive")) gridify_r() else gridify_r()
      if (!methods::is(obj, "gridifyClass")) {
        stop(
          "gridify_with_settings_srv: 'gridify_r' must return a 'gridifyClass' object.\n",
          "Received class: ", paste(class(obj), collapse = ", "),
          call. = FALSE
        )
      }
      obj
    })

    p_height <- shiny::reactive(as.integer(input$height))
    p_width <- shiny::reactive(as.integer(input$width))

    output$plot_ui <- shiny::renderUI({
      shiny::plotOutput(
        outputId = shiny::NS(id)("plot_out"),
        height = paste0(p_height(), "px"),
        width = paste0(p_width(), "px")
      )
    })

    output$plot_out <- shiny::renderPlot(
      expr = {
        methods::show(get_obj())
      },
      height = p_height,
      width = p_width
    )

    output$dl_png <- shiny::downloadHandler(
      filename = function() {
        paste0("gridify_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".png")
      },
      content = function(file) {
        grDevices::png(
          filename = file,
          width = p_width(),
          height = p_height(),
          units = "px",
          res = 96L
        )
        print(get_obj())
        grDevices::dev.off()
      }
    )

    output$dl_pdf <- shiny::downloadHandler(
      filename = function() {
        paste0("gridify_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".pdf")
      },
      content = function(file) {
        grDevices::pdf(
          file = file,
          width = p_width() / 96,
          height = p_height() / 96
        )
        print(get_obj())
        grDevices::dev.off()
      }
    )

    invisible(NULL)
  })
}
