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

#
# graph 1 construction
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
par(mar = c(4, 4, 2, 1), oma = c(3, 2, 2, 0), cex = 0.7, bg="transparent")

# draw the graph
hist(data$Global_active_power, col = "red", 
     main = "Global Active Power", xlab = "Global Active Power (kilowatts)",
     bty = "n", # Remove the box around the plot
     )

# restore the initial values of par()
par(oldpar)

# copy plot to a PNG file
dev.copy(png, file = "plot1.png", width = 480, height=480)

# close the PNG device
dev.off()