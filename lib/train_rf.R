#########################################################
###           Train a randomForest model              ###
#########################################################

# 
if(!require("randomForest")){
  install.packages("randomForest")
}



rf_train = function(x_train, y_train, n_tree=NULL){
  library(randomForest)
  model_list = list()
  
  t = proc.time()
  
  if(is.null(n_tree)){
    n_tree = 200
  } else {
    n_tree <- n_tree
  }
  
  train_file = as.data.frame(cbind(x_train, y_train))

  ### the dimension of response arrat is * x 4 x 3, which requires 12 classifiers
  ### this part can be parallelized
  for (i in 1:12){
    ## calculate column and channel
    c1 = (i-1) %% 4 + 1
    c2 = (i-c1) %/% 4 + 1
    featMat = x_train[, , c2]
    labMat = y_train[, c1, c2]
    
    classifier = randomForest(y_train ~ ., data = train_file,
                              importance = TRUE,
                              ntree = n_tree)

    
    model_list[[i]] <- list(fit=classifier)
    
  }
  
  
  train_time = (proc.time()-t)[3]
  cat("Training time: ", train_time)
  return(model_list)
  
}