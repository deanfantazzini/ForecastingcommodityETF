
library(shiny)
library(shinythemes)


source('helpers.R')

shinyUI(fluidPage(
    theme = shinytheme('united'),
    
    titlePanel('Forecasting commodity Exchange-Traded Funds (ETF) prices'),
    sidebarLayout(
        sidebarPanel(
            selectInput('energy_id', 'Commodity price:', choices = energy_futures),
            wellPanel(
                helpText(textOutput('text.sd')),
                helpText(textOutput('text.ed'))
            ),
            width = 3
        ),
        mainPanel(
            tabsetPanel(
            tabPanel('Prices Plot',
                     radioButtons('method', 'Method:', smooth_method),
                     plotOutput('prices.plot')
            ),
            tabPanel('Prices table', dataTableOutput('energy.table')),
            tabPanel('Price forecast plot', plotOutput('prediction.plot')),
            tabPanel('Price forecast table', dataTableOutput('table.arima')),
            tabPanel('Best ARIMA model', verbatimTextOutput('text.arima')),
            tabPanel('First differences plot',
                     checkboxInput('chcklog', 'log10', value = TRUE),
                     plotOutput('diff.plot')
                     ),
            tabPanel('Autocorrelations residuals', plotOutput('residuals.plot')), 
            tabPanel('Help page', includeMarkdown('helppage.Rmd'))
        )
        )
    )
))
