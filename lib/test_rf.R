#########################################################
###           Test a randomForest model              ###
#########################################################


rf_test  <- function(model_list, test_x){
  library(randomForest)
  
  predArr <- array(NA, c(dim(test_x)[1], 4, 3))
  for (i in 1:12){
    fit_train <- model_list[[i]]
    ### calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- test_x[, , c2]
    ### make predictions
    predArr[, c1, c2] <- predict(fit_train$fit, newdata=featMat, 
                                 type="response")
  }
  return(as.numeric(predArr))
}
