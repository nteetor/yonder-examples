library(shiny)

# define ui ----
# remember, start with a `container()`
ui <- container(
  
  # full page width header ----
  row(
    col(
      h3("Reactivity")
    )
  ),

  row(
    # column of inputs ----
    col(

      # text input ----
      # provide a caption
      h6("Caption:"),
      textInput(
        id = "caption",
        value = "Data Summary"
      ),

      # select input ----
      h6("Choose a dataset:"),
      selectInput(
        id = "dataset",
        choices = c("rock", "pressure", "cars")
      ),

      # number input ----
      h6("Number of observations to view:"),
      numberInput(
        id = "obs",
        value = 10
      )
    ),

    # column of outputs ----
    col(

      # text output ----
      h3(
        textOutput(
          outputId = "caption",
          container = span
        )
      ),

      # verbatim text output ----
      verbatimTextOutput("summary"),

      # table output ----
      tableOutput("view")
    )
  )
)

# define server ----
server <- function(input, output) {
  dataset <- reactive({
    switch(
      input$dataset,
      rock = rock,
      pressure = pressure,
      cars = cars
    )
  })

  # create caption ----
  output$caption <- renderText({
    input$caption
  })

  # create summary ----
  output$summary <- renderPrint({
    summary(dataset())
  })

  # create view of dataset ----
  output$view <- renderTable({
    head(dataset(), n = input$obs)
  })
}

# create shiny app ----
shinyApp(ui = ui, server = server)
