library(shiny)

# define a ui for the app ----
# remember, apps will usually always begin with a call to `container()`
ui <- container(
  row(
    col(
      "dull text"
    )
  ),
  row(
    col(
      default = 12,
      md = 3,
      h6("Choose a dataset:"),
      
      # select input, choose a dataset ----
      selectInput(
        id = "dataset",
        choices = c("rock", "pressure", "cars")
      ),

      # number input, choose number of observations ----
      numberInput(
        id = "obs",
        value = 10
      )
    ),
    col(
      verbatimTextOutput("summary"),

      tableOutput("view")
    )
  )
)

server <- function(input, output) {
  dataset <- reactive({
    switch(
      input$dataset,
      rock = rock,
      pressure = pressure,
      cars = cars
    )
  })

  output$summary <- renderPrint({
    summary(dataset())
  })

  output$view <- renderTable({
    head(dataset(), n = input$obs)
  })
}

# create shiny app ----
shinyApp(ui = ui, server = server)
