library(yonder)

# Define UI for dataset viewer app ----
ui <- container(

  # App title ----
  h2("Shiny Text"),

  # Column layout with a input and output definitions ----
  columns(

    # Sidebar panel for inputs ----
    column(
      width = 4,

      # Input: Selector for choosing dataset ----
      formGroup(
        "Choose a dataset:",
        selectInput(
          id = "dataset",
          choices = c("rock", "pressure", "cars")
        )
      ),

      # Input: Number entry for number of obs to view ----
      numberInput(
        id = "obs",
        label = "Number of observations to view:",
        value = 10
      )
    ),

    # Main panel for displaying outputs ----
    column(

      # Output: Verbatim text for data summary ----
      verbatimTextOutput("summary"),

      # Output: HTML table with requested number of observations ----
      tableOutput("view")

    )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {

  # Return the requested dataset ----
  datasetInput <- reactive({
    switch(
      input$dataset,
      rock = rock,
      pressure = pressure,
      cars = cars
    )
  })

  # Generate a summary of the dataset ----
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })

  # Show the first "n" observations ----
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })

}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
