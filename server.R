#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

Year_All <- c(1975:2090)
Year <- c(1975:2018)
Temperature_Deviation_All <- rep(NA, 116)
Temperature_Deviation <- c(-0.149,0.241,0.047,-0.062,0.057,0.0920,0.1400,0.0110,0.1940,-0.0140,-0.0300,0.0450,0.1920,0.1980,0.1180,0.2960,0.2540,0.1050,0.1480,0.2080,0.3250,0.1830,0.3900,
                           0.5390,0.3060,0.2940,0.4410,0.4960,0.5050,0.4470,0.5450,0.5060,0.4910,0.3950,0.5060,0.5600,0.4250,0.4700,0.5140,0.5790,0.7630,0.7970,0.6770,0.5970)
dt_climate <- data.frame(Year,Temperature_Deviation)
fit_all = lm(Temperature_Deviation~Year, data=dt_climate)
dt_climate$predlm = predict(fit_all)

iCount <- length(Temperature_Deviation_All)
for (i in 1:iCount) 
{
  Temperature_Deviation_All[i] <- Temperature_Deviation[i]
}
Predict_All <- rep(NA, 116)
for (i in 1:iCount) 
{
  Predict_All[i] <- fit_all$coefficients[2]*Year_All[i]+fit_all$coefficients[1]
}
dt_climateAll <- data.frame(Year_All,Temperature_Deviation_All,Predict_All) 
  
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({
      
      NSUB<- input$YEAR-1972;
      
      Year_SUB <- Year_All[c(1:NSUB)]
      Temperature_SUB <- Temperature_Deviation_All[c(1:NSUB)]
      Predict_SUB <- Predict_All[c(1:NSUB)]
      dt_climateSub <- data.frame(Year_SUB,Temperature_SUB,Predict_SUB) 
      
       g <- ggplot(dt_climateSub, aes(Year_SUB, Temperature_SUB)) + geom_line(color='blue') 
       g <- g + ggtitle("Gobal Temperature Deviation [C°]") + xlab("Year") + ylab("Deviation [°C]") 
       g <- g + geom_line(color='red', aes(y = Predict_SUB), size = 1) + theme_bw()
       g <- g + geom_vline(xintercept=input$YEAR)
       g

    })
    
    output$result <- renderText({
       newYear <- input$YEAR
       val <- fit_all$coefficients[2]*input$YEAR+fit_all$coefficients[1]
       text <- paste("Global Temperature deviation for year", newYear, ":",val,"°C")
       text
    })
    
    output$dok <- renderText({
      txt <- paste("Select the year in the slider to get the prediction value for this year. \r\nThe plot will be increased to this year.")
      txt
    })

})
 




