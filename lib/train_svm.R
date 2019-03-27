#load("../output/feature_train.RData")



svm_train <- function(feat_train, label_train){
  
  library(e1071)
  
  model_list <- list()

  ### the dimension of response arrat is * x 4 x 3, which requires 12 classifiers
  ### this part can be parallelized
  for (i in 1:12){
    ## calculate column and channel
    
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- feat_train[, , c2]
    labMat <- label_train[, c1, c2]
    
    fit_svm <- svm(x=featMat, y=labMat, cost = 0.01, gamma = 1, kernel = "radial")
    model_list[[i]] <- list(fit = fit_svm)
  }

  return(model_list)
}

svm_test  <- function(model_list, test_x){
  predArr <- array(NA, c(dim(test_x)[1], 4, 3))
  
  for (i in 1:12){
    fit_train <- model_list[[i]]
    ### calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- test_x[, , c2]
    ### make predictions
    predArr[, c1, c2] <- predict(fit_train$fit, newdata=featMat, 
                                 n.trees=fit_train$iter, type="response")
  }
  return(as.numeric(predArr))
}



