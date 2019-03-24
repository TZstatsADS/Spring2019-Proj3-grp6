########################
### Cross Validation ###
########################

### Author: Weixuan Wu
### Project 3

source("../doc/RF_model.R")
cv_rf <- function(X_train, y_train, k, num_tree){
  ### Perform cross validation on Random Forest model
  
  ### Input: 
  ###     X_train, y_train: training data
  ###     k: k for k-fold cross validation
  ###     num_tree: number of trees
  
  n = dim(y_train)[1]

  # n_fold: the number of samples in each fold
  n_fold = floor(n/k)
  # rep(a,b,c): repeat a for b times, but with the constraint of the length c.
  # sample(c(1 for 150000 times, 2 for 150000 times, ..., 10 for 150000 times))
  fold_index = sample(rep(1:k, c(rep(n_fold, k-1), n-(k-1)*n_fold)))  
  
  cv_error <- rep(NA, k)
  PSNR <- rep(NA, k)
  
  # k-fold cross validation
  for(i in 1:k){
    training_x = x_train[fold_index!=i,,]
    training_y = y_train[fold_index!=i,,]
    validation_x = x_train[fold_index==i,,]
    validation_y = y_train[fold_index==i,,]
    
    classifier = rf_train(training_x, training_y, n_tree = ntree)
    pred = rf_test(classifier, validation_x)

    cv_error[i] = mean((pred - validation_y)^2)
    PSNR[i] = -10*log10(mean((pred - validation_y)^2))
  }
  
  MSE_output <- c(mean(cv_error),sd(cv_error))
  PSNR <- c(mean(PSNR),sd(PSNR))
  return(c(MSE_output,PSNR))
}
