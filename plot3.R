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
# graph 3 construction
#
# store the initial values of par() 
oldpar <- par(no.readonly = TRUE) 

# start plotting from scratch
graphics::plot.new() 

# graphic parameters
#   mar: figure margins (unit is text lines)
#   oma: outer margins (unit is text lines)
#   cex: character expansion
#   bg: background
par(mar = c(4, 4, 1, 1), oma = c(2, 1, 2, 0), cex = 0.75, bg="transparent")

# draw the graph
with(data, {
    plot(myDate, Sub_metering_1, type = "n", xlab = "",
         ylab = "Energy sub metering",
         )
    lines(myDate, Sub_metering_1, col = "black")
    lines(myDate, Sub_metering_2, col = "red")
    lines(myDate, Sub_metering_3, col = "blue")
})

# add the legend
legend("topright", lty = c(1,1), col = c("black", "blue", "red"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# restore the initial values of par()
par(oldpar)

# copy plot to a PNG file
dev.copy(png, file = "plot3.png", width = 480, height=480)

# close the PNG device
dev.off()