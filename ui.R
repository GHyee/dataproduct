library(shiny)

shinyUI(fluidPage(
  titlePanel("Coursera Data Product Shiny App Project"),
  br(),
  helpText("This code is modified from the stockVis app as seen in Shiny Tutorial 6."),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select a Date Range for Apple (SYM: AAPL) 
               Information will be collected from Yahoo Finance."
               ),
      dateRangeInput("dates", 
        "Date range",
        start = "2007-01-01", 
        end = as.character(Sys.Date())),
      br(),
      
      checkboxInput("log", "Plot y axis on log scale", 
        value = FALSE),
      
      checkboxInput("adjust", 
        "Adjust prices for inflation", value = FALSE),
      
      selectInput("iModel", label = "Choose a model of iPhones:",
                  choices = c("iPhone (First Gen)"=1, "iPhone 3G"=2,
                              "iPhone 3GS"=3, "iPhone 4"=4,"iPhone 4S"=5, 
                              "iPhone 5"=6, "iPhone 5C/S"=7, "iPhone 6/ 6 Plus"=8),
                  selected = 8),
      br(),
      helpText("Date of product launch:"),
      textOutput("modelInput"),
      textOutput("text1"),
      p( "Product Launch date is quoted from", span("http://en.wikipedia.org/wiki/Timeline_of_Apple_Inc._products", style = "color:blue"))
    ),
    
    mainPanel(plotOutput("plot"),
              textOutput("text2"))
  )
))
