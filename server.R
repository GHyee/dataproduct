# server.R

library(quantmod)
source("helpers.R")

iphone <- data.frame(matrix(c(      "iPhone (First Gen)", "06/29/2007",
                                    "iPhone 3G", "07/11/2008",
                                    "iPhone 3GS", "06/19/2009",
                                    "iPhone 4", "06/24/2010",
                                    "iPhone 4S", "10/14/2011",
                                    "iPhone 5", "09/21/2012",
                                    "iPhone 5C/S", "09/20/2013",
                                    "iPhone 6/ 6 Plus", "09/19/2014"),ncol=2,byrow = T))
names(iphone)<-c("Product",       "Date")

shinyServer(function(input, output) {
  
  dataInput <- reactive({ 
    getSymbols("AAPL", src = "yahoo", 
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })
  
  finalInput <- reactive({
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })
  
  output$plot <- renderPlot({
    chartSeries(finalInput(), theme = chartTheme("black"), 
                type = "candlesticks", log.scale = input$log)
    index<-as.numeric(input$iModel)
    prodDate<-paste(as.Date(iphone$Date[index], format="%m/%d/%Y",tz=""))
    addLines(v=which(index(finalInput()) == prodDate),col="gold")
  })
 
  output$text1 <- renderText({ 
    index<-as.numeric(input$iModel)
    paste(iphone$Product[index], " was launched on ", iphone$Date[index])
  })
  
  modelInput <- renderText({
    paste("Product launched on",as.character.Date(iphone$Date[input$iModel]))
  })
  
  output$text2 <- renderText({ 
    index<-as.numeric(input$iModel)
    prodDate<-as.Date(iphone$Date[index], format="%m/%d/%Y",tz="")
    getSymbols("AAPL", from = prodDate-3, to = prodDate+3)
    ClosePrices <- do.call(merge, lapply("AAPL", function(x) Cl(get(x))))
    p1 <- coredata(ClosePrices)[1]
    p2 <- coredata(ClosePrices)[2]
    p3 <- coredata(ClosePrices)[3]
    diff1 = round((p2-p1)/(p1)*100,3)
    diff2 = round((p3-p2)/(p2)*100,3)
    paste("The Close Price before ",prodDate, "was ",p1,".",
    "The Close Price on ",prodDate, "was ",p2, " and the increase is ", diff1,"%.",
    "The Close Price after ",prodDate, "was ",p3, " and the increase is ", diff2,"%.")
    
  })
})
