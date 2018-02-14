devtools::load_all("../../dull") #library(dull)

# define UI ----
ui <- container(
  row(
    col(
      h2("Hello, dull!")
    )
  ),
  row(
    col(
      default = 12,
      md = 3,
      h6("Number of bins:"),
      rangeInput(
        id = "bins",
        min = 1,
        max = 50,
        default = 30,
        context = "primary"
      )
    ),
    col(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(
      x, 
      breaks = bins, 
      col = "#75AADB", 
      border = "white",
      xlab = "Waiting time to next eruption (in mins)",
      main = "Histogram of waiting times"
    )
  })
}

shinyApp(ui = ui, server = server)
