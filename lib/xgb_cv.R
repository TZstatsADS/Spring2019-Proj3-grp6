
best.param = list()
best.err = Inf

xgb.parameters<-function(feat_train, label_train,k){
  for (i in 1:12){
    ## calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- feat_train[, , c2]
    labMat <- label_train[, c1, c2]
  }
  
  cv.err <- list()
  library(xgboost)
  dtrain <- xgb.DMatrix(data=as.matrix(featMat),label=labMat)
  
  test.err <- array(NA,c(12,1))
  test.sd <- array(NA,c(12,1))
  train.err <- array(NA,c(12,1))
  train.sd <- array(NA,c(12,1))
  bst.params <- list()
  
  
  max_depth = c(6,7,8)
  eta.s= c(0.6,0.7,0.8,0.9)
  
  for (j in 1:4) {
    for (i in 1:3){
      cv.err[[3*j-3+i]] <- xgb.cv(data=dtrain,
                                  objective = "reg:linear",
                                  metrics ="rmse",
                                  eta = eta.s[j],
                                  depth = max_depth[i],
                                  nthread=6, 
                                  nfold=k,
                                  nrounds=10,
                                  verbose = T)
      
      test.err[3*j-3+i,] <- min(cv.err[[3*j-3+i]]$evaluation_log$test_rmse_mean)
      test.sd[3*j-3+i,] <- min(cv.err[[3*j-3+i]]$evaluation_log$test_rmse_std)
      train.err[3*j-3+i,] <- min(cv.err[[3*j-3+i]]$evaluation_log$train_rmse_mean)
      train.sd[3*j-3+i,] <- min(cv.err[[3*j-3+i]]$evaluation_log$train_rmse_std)
      bst.params <- cv.err[[3*j-3+i]]$params
    }			
  }
  
  err.mat <- cbind(train.err,train.sd,test.err,test.sd)
  colnames(err.mat) <- c("cv_train_err", "train_sd", "test_err", "test_sd")
  
  return(list(best.param = bst.params,err.mat = err.mat))
}

