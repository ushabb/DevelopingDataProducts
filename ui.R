library(shiny)
library(rsconnect)
library(shinyapps)

# Defining the UI for this application
shinyUI(pageWithSidebar(
        
        # Application title
        headerPanel("Developing Data Products - Course Project"),
        
        # Sidebar with controls to select different inputs
        
        sidebarPanel(
                #select the variable to plot against mpg
                # and to specify whether outliers should be included
                
                h3("Exploratory Data Analysis"),
                selectInput(
                       
                        
                        "variable", "Please select the variable for plots",
                            list("Number of cylinders" = "cyl", 
                                 "Transmission" = "am",
                                 "Rear axle ratio" = "drat",
                                 "Weight (1000 lbs)" = "wt",
                                 "V/S" = "vs",
                                 "1/4 mile time" = "qsec",
                                 "Number of carburetors" = "carb",
                                 "Displacement (cu.in.)" = "disp",
                                 "Gross horsepower" = "hp",
                                 "Number of forward gears" = "gear")),
                                 
                checkboxInput("outliers", "Show outliers", FALSE),
                
                h3("Prediction"),
                #Weight input
                numericInput("Weight","Please enter the Weight variable",value=3,min=1.000,max=6.000),
                br(),
                #Transmission type
                radioButtons("Trans","Please select the Transmission Type",list("Automatic" = 0,"Manual" = 1),"0"),
                #qsec input
                sliderInput("Qsec", "Please select the qsec (1/4 mile time) value", value = 15, min = 10, max = 25,animate=T),
                
                actionButton("actionButton","Predict!",align = "center")
              
        ),
        
        # All the main panel contents
        mainPanel(
                tabsetPanel(
                        tabPanel("Help", 
                                 h2("Exploiting mtcars Dataset to build a dataproduct"),
                                 p(strong("Introduction")),
                                 p("This application has 5 tab which can be used as follows:"),
                                 p(strong("1. Help tab")),
                                 p(strong("2. Summary :"),"A simple summary of the dataset - No inputs required."),
                                 p(strong("3. Plots:"),"Simple box plots of mpg vs variables. Input variable under",strong("Exploratory Data Analysis"),"is required. Outliers if any can be indicated by checking the box",strong("Show outliers") ),
                                 p(strong("4. Prediction:"),"Multivariate Regression Model - Three inputs under",strong("Prediction"),"are required") ,
                                 p("Exploiting the project on mtcars data set submitted as a write up in",strong("Regression Models Course"), "to build a dataproduct"),
                                 p(strong("Executive Summary:")),
                                 p("It is an analysis to answer some questions using regression and exploratory data analyses for Motor Trend, a magazine about the automobile industry. Looking at a"
                                   ,"data set of a collection of cars, they are interested in exploring the relationship between a set of variables and"
                                   ,"miles per gallon- mpg which is the outcome. They are particularly interested in the following two questions:"),
                                 p("1.Is an automatic or manual transmission better for MPG”"),
                                 p("2.Quantify the MPG difference between automatic and manual transmissions"),
                                  p(" From the eexploratory analysis it is clear that there can be two considerations here - A linear model of
                                   ‘mpg vs all variables’ and an optimized model of ‘mpg vs am + (qsec+ wt)’ accounting for confounders. This is
                                   sustantaiated by model fitting and anova.
                                   With the aid of residual plots(testimony to the fact that there are other significant regressors along with
                                   ‘am’"),
        
                                 p(strong("5. Residual Plots and Diagnostics"), "No inputs required")
                                 
                                 ),  
                        tabPanel("Summary", 
                                 h2("Summary of",strong("mtcars"),"dataset"),
                                 verbatimTextOutput("summary")), 
                        tabPanel("mpgPlot", 
                                 h3("Plotting chosen variables against mpg"),
                                 h2(textOutput("caption")),
                                 plotOutput("mpgPlot")), 
                        tabPanel("Prediction",
                                 
                                 h2("Input values are"),
                                 h3(span("Weight (1000 lbs)",style = "color:blue")),
                                 verbatimTextOutput("owti"),
                                 h3(span("1/4 mile time",style = "color:blue")),
                                 verbatimTextOutput("oqi"),
                                 h3(span("Transmission",style = "color:blue")),
                                 verbatimTextOutput("oami"),
                                 
                                 h2("The predictions are: An",span(" MPG value",style = "color:green")," with its",span(" Lower Bound",style="color:green"),"and",
                                   span("Upper Bound",style="color:green"),":"),
                                 
                                 h2(strong(code(textOutput("myp"))))
                        ),
                        tabPanel("Diagnostic Plots" ,
                        h2("Residual Plots and Diagnostics"),
                        #plotOutput("Diagplot"))
                        imageOutput("Diagplot"))
                        
                        )
        )
        
        
))