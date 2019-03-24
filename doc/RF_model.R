

if(!require("randomForest")){
  install.packages("randomForest")
}

rf_train = function(x_train, y_train, n_tree){
  library(randomForest)
  t = proc.time()
  
  train_file = as.data.frame(cbind(x_train, y_train))
  
  classifier = randomForest(y_train ~ ., data = train_file,
                            importance = TRUE,
                            ntree = n_tree)
  
  train_time = (proc.time()-t)[3]
  
  return(classifier)
}


rf_test = function(classifier, x_test){
  pred = predict(classifier, newdata=x_test)
  return(pred)
}