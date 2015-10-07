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
# graph 2 construction
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
par(mar = c(4, 4, 2, 1), oma = c(2, 1, 2, 1), cex = 0.7, bg="transparent")

# draw the graph
with(data, {
    plot(myDate, Global_active_power, type = "n", xlab = "",
         ylab = "Global Active Power (kilowatts)",
)
    lines(myDate, Global_active_power)
})

# restore the initial values of par()
par(oldpar)

# copy plot to a PNG file
dev.copy(png, file = "plot2.png", width = 480, height=480)

# close the PNG device
dev.off()