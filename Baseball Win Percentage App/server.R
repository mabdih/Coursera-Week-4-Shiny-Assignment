#
# This is the server logic of a Shiny web application. 

library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({
        
        output$text <- renderText({ 
        "This shiny app uses the {Lahman} package's Teams data to estimate a team winning percentage as a function of run differential. Please use the above sliider to select various dates to visualize how the regresssion slope and intercept changes as a result. Thank you."
        })

        # generate bins based on input$bins from ui.R
        mteam <- read.csv("teams.csv")
        mteam <- mteam[mteam$yearID >= input$year[1] & mteam$yearID <= input$year[2],]
        mteam$RD <- with(mteam, R - RA)
        mteam$Wpct <- with (mteam, W / (W + L))
        linfit <- lm(Wpct ~ RD, data = mteam)

        # draw the plot
        ggplot(data=mteam, aes(x=RD, y=Wpct)) + 
            geom_point() + 
            geom_abline(slope = linfit$coefficients[2], intercept = linfit$coefficients[1]) +
            labs(title = "Plot of a Team's Run Differential vs Win Percentage", 
                 subtitle = paste0("Number of Observations: ", dim(mteam)[1],
                                  ", Slope: ", round(linfit$coefficients[1],5), 
                                  ", Intercept: ", round(linfit$coefficients[2],5))) +
            xlab("Run Differential") + ylab("Winning Percentage") +
            theme(plot.title = element_text(face="bold"))
        

    })

})
