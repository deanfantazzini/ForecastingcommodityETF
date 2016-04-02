# Forecasting commodity Exchange-Traded Funds (ETF) prices

## Developing Data Products: Course project

* Author:  Enrique Pérez Herrero  
* Date: April 1st, 2016  

## Idea

This App downloads the last five years of prices for a selected group of commodity Exchange-Traded Funds (ETF) prices and forecasts the prices for the next year using the auto.arima function from the forecast R package. 

## Shiny App url:
* [App url](https://deanfantazzini.shinyapps.io/Forecasting_commodity_ETF/) 
* [GitHub url](https://github.com/deanfantazzini/ForecastingcommodityETF)
* [R presentation](http://rpubs.com/deanfantazzini/ForecastingcommodityETF)


P.S. If the Shiny app is blocked due to the strict time constraints of the Shinyapps free subscription, you can easily access it by using github and R, jus typing these few lines of code

```r
# Install these packages in R if needed
# install.packages(c("shiny", "shinythemes", "forecast", "quantmod", "ggplot2")) 
library(shiny)
library(shinythemes)
library(forecast)
library(ggplot2)
library(quantmod)
runGitHub("ForecastingcommodityETF", "deanfantazzini") 
```


