library(shiny)
library(datasets)

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application
mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))





mtcars_ <- mtcars
mtcars_$cyl <- as.factor(mtcars_$cyl)
mtcars_$vs <- as.factor(mtcars_$vs)
mtcars_$am <- as.factor(mtcars_$am)
mtcars_$gear <- as.factor(mtcars_$gear)



# mtcars structure after tranformation 
str(mtcars)

# fitting linear model
LinearModel <- lm(mpg ~. ,  data=mtcars_)

# Choose a model by AIC in a Stepwise Algorithm
OptimizedModel <- step(LinearModel,direction="both")

# generate model summary
summary(OptimizedModel)




# Define server logic required to show various functionalities
shinyServer(function(input, output, session) {
        
        # Generate a simple
        output$summary <- renderPrint({
                str(mtcars_)
        })
        
        
      #Plots of mpg vs variables
        formulaText <- reactive({
                paste("mpg ~", input$variable)
        })
        
       
        output$caption <- renderText({
                formulaText()
        })
        
        # Generate a plot of the requested variable against mpg and only 
        # include outliers if requested
        output$mpgPlot <- renderPlot({
                boxplot(as.formula(formulaText()), 
                        data = mpgData,
                        outline = input$outliers,
                        col="yellow",
                        xlab="Miles/(US) gallon",
                        ylab="variable")
        })
        
        
        output$myTrans <- renderText({ input$Trans })
        
        output$owti = renderPrint({input$Weight})
        output$oqi = renderPrint({input$Qsec})
        output$oami = renderPrint({input$Trans})
        
        #Prediction
        output$myp <- renderText({ 
                input$actionButton
                isolate({
                       newdata = data.frame(wt=we(),qsec=input$Qsec, am=input$Trans)
                        wti <- newdata$wt
                        qi <- newdata$qsec
                        ami <- newdata$am
                        myp  <- predict(OptimizedModel,newdata , interval = "predict")
 
                })
        })
        
        
        # Generating diagnostic plots
       # output$Diagplot <- renderPlot({
                
                # optional 4 graphs/page
               # par(mfrow=c(2, 2))
                
               # plot(OptimizedModel, pch = 2, col = 'dark green', line = 8)
                
       # })
        
        output$Diagplot <- renderImage({
                # A temp file to save the output.
                # This file will be removed later by renderImage
                outfile <- tempfile(fileext='.png')
                
                # Generate the PNG
                png(outfile, width=1600, height=800)
                par(mfrow=c(2, 2))
                
                plot(OptimizedModel, pch = 2, col = 'dark green')
                dev.off()
                
                # Return a list containing the filename
                list(src = outfile,
                     contentType = 'image/png',
                     width = 1200,
                     height = 800,
                     alt = "This is alternate text")
        }, deleteFile = TRUE)
        
        
        we <- reactive({
                w <- as.numeric(input$Weight)
        })
        
       
        
})