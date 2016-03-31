library(ggplot2)
library(forecast)
library(quantmod)


# Max data from finam.ru
max.range <- (5 * 365)

# Getting the data
getenergydata <- function(energy) {
    getSymbols(energy, from=Sys.Date() - max.range, to=Sys.Date())
    ClosePrices <- do.call(merge, lapply(energy, function(x) Ad(get(x))))
    
    energy_data <- as.data.frame(ClosePrices)
    energy_data <-
        cbind(date = as.Date(rownames(energy_data)), energy_data)
    rownames(energy_data) <- c(1:nrow(energy_data))
    return(energy_data)
}

#Tickers
energy_futures <- c(
    'United States Oil (USO)'         = 'USO',
    'United States Natural Gas (UNG)' = 'UNG',
    'United States Gasoline (UGA)'    = 'UGA', 
    'SPDR Gold Shares (GLD)'          = 'GLD', 
    'iShares Silver Trust (SLV)'      = 'SLV', 
    'iiPath Bloomberg Copper (JJC)'   = 'JJC'
)

#energy.df <- getenergydata(energy_futures)

smooth_method <- c('loess', 'lm')

# Arima forecast plot code based on:
# http://librestats.com/2012/06/11/autoplot-graphical-methods-with-ggplot2/

arimaForecastPlot <- function(forecast, start, ylabel, ...) {
    # data wrangling
    time <- attr(forecast$x, 'tsp')
    time <- seq(time[1], attr(forecast$mean, 'tsp')[2], by = 1 / time[3])
    lenx <- length(forecast$x)
    lenmn <- length(forecast$mean)
    time2 <- seq(from = start, to = start + lenx + lenmn , by = '1 day')
    
    df <- data.frame(
        time = as.Date(time + start),
        x = c(forecast$x, forecast$mean),
        forecast = c(rep(NA, lenx), forecast$mean),
        low1 = c(rep(NA, lenx), forecast$lower[, 1]),
        upp1 = c(rep(NA, lenx), forecast$upper[, 1]),
        low2 = c(rep(NA, lenx), forecast$lower[, 2]),
        upp2 = c(rep(NA, lenx), forecast$upper[, 2])
    )
    
    p <- ggplot(df, aes(time, x), ...) +
        geom_ribbon(aes(ymin = low2, ymax = upp2), fill = 'yellow') +
        geom_ribbon(aes(ymin = low1, ymax = upp1), fill = 'orange') +
        geom_line() +
        geom_line(
            data = df[!is.na(df$forecast),],
            aes(time, forecast),
            color = 'blue',
            na.rm = TRUE
        ) +
        ggtitle(paste('Forecasts from', forecast$method)) +
        xlab('') +
        ylab(ylabel)
    return(p)
}

