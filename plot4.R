library(dplyr)

# IMPORTANT NOTE: the zip file containing the data should reside 
# inside the working directory

# read only a portion of the data to minimize memory consumption
data <- read.table(unz("exdata-data-household_power_consumption.zip", 
                       "household_power_consumption.txt"), 
                   nrows = 70000, # approximation
                   header = TRUE, 
                   sep = ";",
                   na.strings = "?")

# restrict dataset to only two days : 2007-02-01 and 2007-02-02
# note that dates are in this localized format: d/m/yyyy
data <- data %>% filter(Date == "1/2/2007" | Date == "2/2/2007")

# conversion of Date and Time vars to Date/Time classes using a new variable
data$myDate <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

# convert to english locale to display month names correctly
Sys.setlocale("LC_ALL", 'en_GB.UTF-8')

#
# graph 4 construction
#
# store the initial values of par() 
oldpar <- par(no.readonly = TRUE) 

# start plotting from scratch
graphics::plot.new() 

# graphic parameters
#   mfrow: multiple figure array (2 rows x 2 cols)
#   mar: figure margins (unit is text lines)
#   oma: outer margins (unit is text lines)
#   cex: character expansion
#   bg: background
par(mfrow = c(2, 2), mar = c(4, 4, 3, 3), oma = c(2, 2, 2, 0), cex = 0.65,
    bg="transparent")

# draw the graph
with(data, {
    # top left graph
    plot(myDate, Global_active_power, type = "n", xlab = "",
         ylab = "Global Active Power",
    )
    lines(myDate, Global_active_power)
    
    # top right graph
    plot(myDate, Voltage, type = "n", 
         xlab = "datetime", ylab = "Voltage",
    )
    lines(myDate, Voltage)
    
    # bottom left graph
    plot(myDate, Sub_metering_1, type = "n", xlab = "",
         ylab = "Energy sub metering",
    )
    lines(myDate, Sub_metering_1, col = "black")
    lines(myDate, Sub_metering_2, col = "red")
    lines(myDate, Sub_metering_3, col = "blue")
    
    legend("topright", bty = "n", cex=0.75, adj=0.1, lty = c(1,1), 
           col = c("black", "blue", "red"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
    # bottom right graph
    plot(myDate, Global_reactive_power, type = "n", 
         xlab = "datetime", ylab = "Global_reactive_power",
    )
    lines(myDate, Global_reactive_power)
})

# restore the initial values of par()
par(oldpar)

# copy plot to a PNG file
dev.copy(png, file = "plot4.png", width = 480, height=480)

# close the PNG device
dev.off()