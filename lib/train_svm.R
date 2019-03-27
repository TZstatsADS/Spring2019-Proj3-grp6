
##train a svm model
##Author: Yuqiao Li
##proj3

#load("../output/feature_train.RData")
#feat_train <- dat_train$feature
#label_train <- dat_train$label
#svm_train(feat_train, label_train)

svm_train <- function(feat_train, label_train){
  
  if(!require("e1071")){
    install.packages("e1071")
  }

  t=proc.time()
  model_list <- list()
  
  para<-list()
  par.list = list(cost = c(0.1,1,10,50),
                  gamma = c(0.01,0.1,1,10))
  k = tune.control(cross = 5)
  ### the dimension of response arrat is * x 4 x 3, which requires 12 classifiers
  ### this part can be parallelized
  for (i in 1:12){
    ## calculate column and channel
    
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- feat_train[, , c2]
    labMat <- label_train[, c1, c2]
    #Find the best parameters
    tune_result <- tune(svm,featMat, labMat,kernel = "radial", 
                            scale = FALSE, ranges = par.list, tunecontrol = k)
    #fit model with best parameters
    fit_svm <- svm(featMat, labMat, kernel = "radial", 
                   cost = tune_result$best.parameters[[1]],
                   gamma = tune_result$best.parameters[[2]], scale = F)
    
    model_list[[i]] <- list(fit = fit_svm)
    print(i)
    print((proc.time()-t)[3])
  }
  all_train_time = (proc.time()-t)[3]
  cat("\nAll training time: ", all_train_time)
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



