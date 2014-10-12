## make sure the packages are installed, install if necessary
pkg <- c("")
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length (new.pkg)) {
  install.packages (new.pkg)
}

#load libraries (if necessary)

#slurp in the data
datafile <- "household_power_consumption.txt"
df <- read.table (datafile, sep=";", header=TRUE, stringsAsFactors=FALSE)
# before we cast the date and time lets first combine them and cast the whole thing
df$DateTime <- paste(df$Date, df$Time, sep=' ')
# reformat the data and time cols, not sure yet if I want/need to combine them
df$Date <- as.Date(df$Date, "%d/%m/%Y")
df$Time <- as.POSIXlt(df$Time, format="%H:%M:%S")
df$DateTime <- as.POSIXct(df$DateTime, format="%d/%m/%Y %H:%M:%S")

# now we can subset the data and work with a smaller data frame
twodays <- subset (df, Date >= "2007-02-01" & Date <= "2007-02-02")

# convert the rest of the cols to reals
# have to do this hard way, no time for an elegant solution
for (i in 3:9) {
  twodays[,i] <- as.double(twodays[,i])
}

# generate the plot 
# set up the png file to the plot
outname <- "plot3.png"
png(outname, width=480, height=480)


# put plotting function here
with (twodays, plot (DateTime, Sub_metering_1, main='', type='n', ylab='Energy sub metering', xlab=''))
with (twodays, lines (DateTime, Sub_metering_1, col='black'))
with (twodays, lines (DateTime, Sub_metering_2, col='red'))
with (twodays, lines (DateTime, Sub_metering_3, col='blue'))
legend("topright", col=c("black","red","blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd=1)

#close the device
dev.off()


