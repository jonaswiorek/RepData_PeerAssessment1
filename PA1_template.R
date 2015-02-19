library(ggplot2)
library(dplyr)

activity <- read.csv("./data/activity.csv", header = TRUE, sep = ',', na.strings = 'NA')
dim(activity)

dailySteps <- summarize(group_by(activity, date), steps = sum(steps, na.rm = TRUE))
hist(dailySteps$steps, breaks=20)
mean(dailySteps$steps)
median(dailySteps$steps)

dailyPattern <- summarize(group_by(activity, interval), steps = sum(steps, na.rm = TRUE))
maxInterval <- dailyPattern[which.max(dailyPattern$steps),][[1]]
plot(dailyPattern$interval, dailyPattern$steps, type = 'l', xaxt = 'n')
axis(1, at = c(0,500,maxInterval, 1000, 1500, 2000))
abline(v=maxInterval, col = "dark red")

length(which(is.na(activity$steps)))

activityNoNa <- mutate(group_by(activity, interval), intervalSteps = mean(steps, na.rm = TRUE))
activityNoNa <- mutate(activityNoNa, stepsNoNa = ifelse(is.na(steps), intervalSteps, steps))
dailyStepsNoNa <- summarize(group_by(activityNoNa, date), steps = sum(stepsNoNa))
hist(dailyStepsNoNa$steps, breaks=20)
mean(dailyStepsNoNa$steps)
median(dailyStepsNoNa$steps)

