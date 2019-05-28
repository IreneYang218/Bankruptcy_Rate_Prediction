library(tseries)
library(forecast)
library(dplyr)

setwd("/Users/jacquessham/Documents/MSDS/MSAN604/FinalProject")
train <- read.csv("train.csv")
train_tr <- train[1:288,]
train_vr <- train[289:336,]
test <- read.csv("test.csv")


train_ts <- ts(train_tr$Bankruptcy, start=c(1987,1), frequency = 12)
valid_ts <- ts(train_vr$Bankruptcy, start=c(2011,1), frequency = 12)

## Explore training set and valid result
# First look at the "additive" model
model_hw_add <- HoltWinters(x = train_ts, seasonal = "additive")
plot(model_hw_add, main="Holt-Winters Model for Bankruptcy Rate", xlab="Year",
     ylab="Percentage Point")
legend("bottomright", legend = c("Observed", "Predicted"), lty = 1, col = c("black", "red"), cex = 0.5)

model_hw_add_ets <- ets(train_ts, alpha=0.4204725, beta=0.001687927, gamma=0.3169342, model="AAA")

model_hw_add_pred <- forecast(model_hw_add, h=48, level=0.95)
plot(model_hw_add_pred)
points(valid_ts, type='l', col="red")
# Calculate RMSE
sqrt(mean((valid_ts - model_hw_add_pred$mean[1:48])**2))


# Then look at the "multiplicative
model_hw_mult <- HoltWinters(x = train_ts, seasonal = "multiplicative")
plot(model_hw_mult)
model_hw_mult_pred <- forecast(model_hw_mult, h=48, level=0.95)
plot(model_hw_mult_pred, ylim = c(0,15))
points(valid_ts, type='l', col="red")
sqrt(mean((valid_ts - model_hw_mult_pred$mean[1:48])**2))


## Now forecast between 2009 and 2017
# Do the "additive" model first
model_hw_add_pred_2017 <- forecast(model_hw_add, h=48+36, level=0.95)
plot(model_hw_add_pred_2017)
points(valid_ts, type='l', col="red")
# Then do "multiplicative" model
model_hw_mult_pred_2017 <- forecast(model_hw_mult, h=48+36, level=0.95)
plot(model_hw_mult_pred_2017)
points(valid_ts, type='l', col="red")
