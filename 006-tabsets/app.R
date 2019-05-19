library(yonder)

# Define UI for random distribution app ----
ui <- container(

  # App title ----
  h2("Tabsets"),

  # Sidebar layout with input and output definitions ----
  columns(

    # Sidebar panel for inputs ----
    column(
      width = 4,

      # Input: Select the random distribution type ----
      formGroup(
        label = "Distribution type:",
        radioInput(
          id = "dist",
          choices = c("Normal", "Uniform", "Log-normal", "Exponential"),
          values = c("norm", "unif", "lnorm", "exp")
        )
      ),

      # Input: Slider for the number of observations to generate ----
      formGroup(
        label = "Number of observations:",
        rangeInput(
          id = "n",
          value = 500,
          min = 1,
          max = 1000
        )
      )

    ),

    # Main panel for displaying outputs ----
    column(

      # Output: Nav w/ plot, summary, and table ----
      navInput(
        id = "view",
        appearance = "tabs",
        choices = c("Plot", "Summary", "Table")
      ) %>%
        margin(bottom = 3),

      navContent(
        navPane("Plot", plotOutput("plot")),
        navPane("Summary", verbatimTextOutput("summary")),
        navPane("Table", tableOutput("table"))
      )

    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # Observe nav input to change nav panes
  observe({
    showNavPane(input$view)
  })

  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  d <- reactive({
    dist <- switch(
      input$dist,
      norm = rnorm,
      unif = runif,
      lnorm = rlnorm,
      exp = rexp,
      rnorm
    )

    dist(input$n)
  })

  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$plot <- renderPlot({
    dist <- input$dist
    n <- input$n

    hist(
      d(),
      main = paste("r", dist, "(", n, ")", sep = ""),
      col = "#75AADB", border = "white"
    )
  })

  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(d())
  })

  # Generate an HTML table view of the data ----
  output$table <- renderTable({
    d()
  })

}

# Create Shiny app ----
shinyApp(ui, server)
