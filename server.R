
source('helpers.R')

#Download last 4 years of data
energy.df <- getenergydata(energy_futures)

start.date <- head(energy.df$date, 1)
end.date <- tail(energy.df$date, 1)

# Forecast interval parameter
forecast.days <- 365

shinyServer(function(input, output) {
    
   # Energy Prices plot using ggplot2 
    output$prices.plot <- renderPlot({
        tag <- paste(input$energy_id, 'Adjusted', sep = '.')
        ggplot(data = energy.df , aes_string('date', tag)) +
            geom_line() +
            stat_smooth(
                method = input$method, formula = y ~ x, size = 1
            ) +
            xlab('')
        
    })
    # Forecasted data with auto.arima plot 
    output$prediction.plot <- renderPlot({
        tag <- paste(input$energy_id, 'Adjusted', sep = '.')
        selected.energy <- ts(zoo(energy.df[tag],
                                 order.by = energy.df$date))
        arima.fit <- auto.arima(selected.energy,
                                approximation = FALSE,
                                trace = FALSE)
        pred <- forecast(arima.fit, h = forecast.days)
        arimaForecastPlot(pred, start = start.date, ylabel = tag)
        
    })
    
    # Data first differences plot
    output$diff.plot <- renderPlot({
        tag <- paste(input$energy_id, 'Adjusted', sep = '.')
        selected.energy <- ts(zoo(energy.df[tag],
                                  order.by = energy.df$date))
        ifelse(
            input$chcklog,
            selected.diff <- diff(log10(selected.energy)),
            selected.diff <-  diff(selected.energy)
        )
        
        diff.df <- data.frame(date = energy.df[2:nrow(energy.df),'date'],
        price = selected.diff)
        
        ggplot(data = diff.df , aes_string('date', tag)) +
            geom_line() +
            xlab('')
        
    })
    
   # ARIMA results from auto.arima
    output$text.arima <- renderPrint({
        tag <- paste(input$energy_id, 'Adjusted', sep = '.')
        selected.energy <- ts(zoo(energy.df[tag],
                                  order.by = energy.df$date))
        arima.fit <- auto.arima(selected.energy,
                                approximation = FALSE,
                                trace = FALSE)
        summary(arima.fit)
    })
    
    #Date information
    output$text.sd <- renderText({
        paste0("Start Date: ",
               start.date <- head(energy.df$date, 1))
    })
        output$text.ed <- renderText({
        paste0("End Date: ",
               end.date <- tail(energy.df$date, 1))
    })
    
    #Show table with real prices
        output$energy.table <- renderDataTable(
            energy.df[, grepl(paste0(paste(input$energy_id, 'Adjusted', sep = '.'), '|date'), names(energy.df))]
            , options = list(pageLength = 10)
        )
    
        #Residuals plot
    output$residuals.plot <- renderPlot({
        tag <- paste(input$energy_id, 'Adjusted', sep = '.')
        selected.energy <- ts(zoo(energy.df[tag],
                                  order.by = energy.df$date))
        arima.fit <- auto.arima(selected.energy,
                                approximation = FALSE,
                                trace = FALSE)
        par(mfrow = c(1, 2))
        acf(ts(arima.fit$residuals), na.action = na.pass, main = 'ACF Residuals')
        pacf(ts(arima.fit$residuals), na.action = na.pass, main ='PACF Residuals')
    })
    
    #Compute price forecasts
    forecast.table <- reactive({
        tag <- paste(input$energy_id, 'Adjusted', sep = '.')
        selected.energy <- ts(zoo(energy.df[tag],
                                  order.by = energy.df$date))
        arima.fit <- auto.arima(selected.energy,
                                approximation = FALSE,
                                trace = FALSE)
        pred <- forecast(arima.fit, h = forecast.days)
        pred <- as.data.frame(pred)
        pred <- cbind(date = 0, pred[-1])
        pred$date <-
            seq(from = end.date + 1,
                to = end.date + forecast.days,
                by = "1 day")
        return(pred)
        })
    
    #Show price forecasts
    output$table.arima <- renderDataTable({
        forecast.table()
    }, options = list(pageLength = 10))
})