#source("train_svm.R")
#source("test_svm.R")
cv_svm <- function(x_train, y_train, k){
  
  t=proc.time()
  
  
  n <- dim(y_train)[1]
  n_fold = floor(n/k)
  fold_index = sample(rep(1:k, c(rep(n_fold, k-1), n-(k-1)*n_fold)))  
  
  cv_error <- c()
 
  
  # k-fold cross validation
  for(i in 1:k){
    train_x = x_train[fold_index!=i,,]
    train_y = y_train[fold_index!=i,,]
    test_x = x_train[fold_index==i,,]
    test_y = y_train[fold_index==i,,]
    
    model_list = svm_train(train_x, train_y)
    pred = svm_test(model_list, test_x)
    
    cv_error = c(mean((pred - test_y)^2),cv_error)
  
  }
  train_time = (proc.time()-t)[3]
  cat("\nTraining time: ", train_time)
  
  return(c(mean(cv_error),sd(cv_error)))
}

#x_train<-dat_train$feature[1:2000,,]
#x_train<-dat_train$label[1:2000,,]
cv_svm(x_train, y_train, k = 5)#Training time:  8.951[1] 0.003682596



















