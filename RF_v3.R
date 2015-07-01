library(randomForest)
library(caret) # For confusion Matrix
library(parallel) #used to detect cores on the system
library(doSNOW) #parallel adapter for 'foreach'
library(foreach) #for parallelization
library(missForest) #For missing value imputation if needed

numcores_free=6 #Number of cores set free. Warning: Setting low value will slow down the system
registerDoSNOW(makeCluster(detectCores()-numcores_free, type="SOCK"))
set.seed(666)

setwd("/Users/deepesh.sharma/Project/tests/RFCode") #PLEASE SET the working directory

#Loading CSV: Replacing blanks with NA
training <- read.csv("Dataset3.csv",header=T, na.strings=c("","NA"))
summary(training)

#Data Cleaning Stage: (Comments added for steps taken)
sapply(training, function(x) sum(is.na(x))/nrow(training)) #Helps with identifying missing value cutoff to discard variables 
training.clean <- training[,colSums(is.na(training))<(.9*nrow(training))] #Discarding variables with 90% or more missing values

#Changing datetime to integer format
training.clean$cvtd_timestamp<-as.numeric(as.POSIXct(training.clean$cvtd_timestamp, format="%m/%d/%Y  %H:%M"))
summary(training.clean)

#Missing Value imputation using rfimpute
imputed <- missForest(training.clean,maxiter = 10, ntree = 10, verbose = TRUE)
training.imputed<-imputed$ximp
sapply(training.imputed, function(x) sum(is.na(x)))

#creating Train and Test dataset (70:30 ratio)
sampleSize <- floor(0.70 * nrow(training.imputed))
train_t <- sample(seq_len(nrow(training.imputed)), size = sampleSize)
train <- training.imputed[train_t, ]
test <- training.imputed[-train_t, ]

tuneRF(y=train$Class,x=subset(train, select=-Class), ntreeTry=50, stepFactor=2, improve=0.05,
       trace=TRUE, plot=TRUE, doBest=FALSE)

#Executing random forest in parallel as per config (numcores_free)
rf_model <- foreach(ntree=rep(200,detectCores()-numcores_free),.combine=combine, .multicombine=TRUE,
              .packages='randomForest') %dopar% {
                randomForest(train$Class~.,data=train,mtry=7, ntree=ntree,do.trace=TRUE,importance=TRUE)
              }

print(rf_model) #Printing Model stats
varImpPlot(rf_model) #Plotting relative Variable Importance measure

#Prediction on Test data
predicted_class_rf <- data.frame(predict(rf_model,test))

#Confusion Matrix printing the results on test data
confusionMatrix(factor(predicted_class_rf$predict.rf_model..test.),test$Class, dnn = c("Prediction", "Truth"))

