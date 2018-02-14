library(dull)
library(datasets)

# notes ----
# dull has broken out shiny's sliderInput into
# three distinct inputs,
#   - rangeInput
#   - intervalInput
#   - sliderInput
# all are used in the example

# define ui ----
ui <- container(
  h3("Sliders"),

  row(
    # column of inputs ----
    # width of 5 for medium or bigger windows and
    # full width otherwise
    col(
      default = 12,
      md = 5,
      
      # range input (integers) ----
      h6("Integer:"),
      rangeInput(
        id = "integer",
        min = 0,
        max = 1000,
        default = 500
      ),

      # range input (reals) ----
      h6("Decimal:"),
      rangeInput(
        id = "decimal",
        min = 0,
        max = 1,
        step = 0.1,
        default = 0.5
      ),

      # interval input ----
      h6("Interval:"),
      intervalInput(
        id = "interval",
        min = 1,
        max = 1000,
        default = c(200, 500)
      ),

      # slider input ----
      h6("Discrete:"),
      sliderInput(
        id = "discrete",
        choices = c(
          "disagree",
          "somewhat disagree",
          "neutral",
          "somewhat agree",
          "agree"
        )
      ),

      # custom format input ----
      h6("Custom format:"),
      rangeInput(
        id = "format",
        min = 0,
        max = 1000,
        step = 50,
        prefix = "$",
        suffix = ".00"
      )
      
    ),

    # column with output ----
    col(

      # table *thru*put ----
      tableThruput("values")
      
    )      
  )
)

# define server ----
server <- function(input, output) {

  # slider values reactive ----
  sliderVals <- reactive({
    data.frame(
      Name = c(
        "Integer", "Decimal", "Interval", "Discrete", "Custom format"
      ),
      Value = c(
        input$integer, 
        input$decimal,
        
        # !! interval input value ----
        # interval inputs return a list of two elements `from` and `to`
        paste(input$interval$from, input$interval$to),
        
        input$discrete,
        input$format
      ),
      stringsAsFactors = FALSE
    )
  })

  # render table ----
  output$values <- renderTable({
    sliderVals()
  })
}

shinyApp(ui, server)
