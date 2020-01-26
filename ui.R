#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Deviation from global average surface temperature 1961-1990"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h5("Select the year for the forecast"),
            sliderInput("YEAR",
                        "Prediction Year",
                        min = 1990,
                        max = 2090,
                        value = 2020,
                        step=1,sep="")
        ),

        # Show a plot of the global temperature deviation and the predicted value for a input year
        mainPanel(
            plotOutput("distPlot"),
            verbatimTextOutput("result", placeholder = TRUE)
        )
    ),
    hr(),
    print("Source: Met Office Hadley Centre, Climate Research Unit; HadCRUT.4.4.0.0 model; median of 100 calculated time series")
))
