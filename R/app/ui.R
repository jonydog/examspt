##
## User interface of the web app
##
ui <- fluidPage(
  
  headerPanel(testString),
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", "Number of observations:", min = 10, max = 500, value = 100)
    ),
    mainPanel(plotOutput("distPlot"))
  )
)