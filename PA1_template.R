library(lattice)
library(ggplot2)
library(dplyr)
library(xtable)

activity <- read.csv("./data/activity.csv", header = TRUE, sep = ',', na.strings = 'NA')
dim(activity)

#activity <- mutate(activity, date = as.Date(date, "%Y-%m-%d"))

dailySteps <- summarize(group_by(activity, date), steps = sum(steps, na.rm = TRUE))
xtable(dailySteps)
hist(dailySteps$steps, breaks=16, freq = TRUE, xlab = "Daily Steps",
        main("Histogram of total number of daily steps "))

hist(dailySteps$steps, breaks=20, main="Histogram of daily steps")

ggplot(dailySteps, aes(x=steps)) +
        geom_histogram(binwidth = 1000, aes(fill=..count..)) +
        ggtitle("Histogram of daily steps")

mean(dailySteps$steps)
median(dailySteps$steps)

dailyPattern <- summarize(group_by(activity, interval), steps = mean(steps, na.rm = TRUE))
maxInterval <- dailyPattern[which.max(dailyPattern$steps),][[1]]
plot(dailyPattern$interval, dailyPattern$steps, type = 'l', xaxt = 'n', 
     xlab = "Interval", ylab = "Steps")
axis(1, at = c(0,500,maxInterval, 1000, 1500, 2000))
abline(v=maxInterval, col = "dark red")

length(which(is.na(activity$steps)))

#activityNoNa <- mutate(group_by(activity, interval), intervalSteps = floor(mean(steps, na.rm = TRUE)))
#activityNoNa <- mutate(activityNoNa, steps = ifelse(is.na(steps), intervalSteps, steps))
intervalSteps <- summarize(group_by(activity, interval), intervalSteps = floor(mean(steps, na.rm = TRUE)))
activityNoNa <- mutate(activity, steps = ifelse(is.na(steps), intervalSteps$intervalSteps, steps))
dailyStepsNoNa <- summarize(group_by(activityNoNa, date), steps = sum(steps))
hist(dailyStepsNoNa$steps, breaks=20)
mean(dailyStepsNoNa$steps)
median(dailyStepsNoNa$steps)

Sys.setlocale("LC_TIME","C") #Get weekdays in English in RStudio
activityNoNa <- mutate(activityNoNa, day.of.week = as.factor(ifelse((weekdays(as.Date(activity$date))) %in% c("Saturday", "Sunday"), "weekend", "weekday")))
intervalStepsWeek <- summarize(group_by(activityNoNa, interval, day.of.week), intervalSteps = floor(mean(steps)))


qplot(interval, intervalSteps, 
      data = intervalStepsWeek,
      facets = day.of.week~.,
      col = day.of.week,
      geom = "line") 

par(mfrow = c(2,1))
with(intervalStepsWeek, plot(interval,intervalSteps, type= 'n'))
with(filter(intervalStepsWeek, day.of.week == "weekend"), points(interval, intervalSteps, col = "dark blue", type = 'l'))
with(intervalStepsWeek, plot(interval,intervalSteps, type= 'n'))
with(filter(intervalStepsWeek, day.of.week == "weekday"), points(interval, intervalSteps, col = "dark red", type = 'l'))

xyplot(intervalSteps ~ interval | day.of.week, data=intervalStepsWeek, type = "l", col ="dark blue", layout = c(1,2))

