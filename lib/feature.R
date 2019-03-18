#############################################################
### Construct features and responses for training images###
#############################################################

### Authors: Chengliang Tang/Tian Zheng
### Project 3

feature <- function(LR_dir, HR_dir, n_points=1000){
  
  ### Construct process features for training images (LR/HR pairs)
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + number of points sampled from each LR image
  ### Output: an .RData file contains processed features and responses for the images
  
  ### load libraries
  library("EBImage")
  n_files <- length(list.files(LR_dir))
  
  ### store feature and responses
  featMat <- array(NA, c(n_files * n_points, 8, 3))
  labMat <- array(NA, c(n_files * n_points, 4, 3))
  
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    ### step 1. sample n_points from imgLR
   
    srow <- sample(dim(imgLR)[1], n_points, replace = T)
    scol <- sample(dim(imgLR)[2], n_points, replace = T)

    ### step 2. for each sampled point in imgLR, do below, and repeat above for three channels
    for(j in 1:3){ 
        ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
        ###           tips: padding zeros for boundary points

      total <- cbind(0, imgLR[,,j], 0)
      total <- rbind(0, total, 0)
      central <- total[cbind(srow +1, scol+1)]
      featMat[(i-1)*n_points + 1:n_points, 1, j] <- total[cbind(srow, scol)]-central
      featMat[(i-1)*n_points + 1:n_points, 2, j] <- total[cbind(srow, scol + 1)]-central
      featMat[(i-1)*n_points + 1:n_points, 3, j] <- total[cbind(srow, scol+2)]-central
      featMat[(i-1)*n_points + 1:n_points, 4, j] <- total[cbind(srow +1, scol+2)]-central
      featMat[(i-1)*n_points + 1:n_points, 5, j] <- total[cbind(srow +2, scol+2)]-central
      featMat[(i-1)*n_points + 1:n_points, 6, j] <- total[cbind(srow+2, scol+1)]-central
      featMat[(i-1)*n_points + 1:n_points, 7, j] <- total[cbind(srow+2, scol)]-central
      featMat[(i-1)*n_points + 1:n_points, 8, j] <- total[cbind(srow+1, scol)]-central
    
        ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat      
      channels <- imgHR[,,j]
      labMat[(i-1)*n_points + 1:n_points, 1, j] <- channels[cbind(srow*2-1, scol*2 -1)]-central
      labMat[(i-1)*n_points + 1:n_points, 2, j] <- channels[cbind(srow*2-1, scol*2)]-central
      labMat[(i-1)*n_points + 1:n_points, 3, j] <- channels[cbind(srow*2, scol*2)]-central
      labMat[(i-1)*n_points + 1:n_points, 4, j] <- channels[cbind(srow*2, scol*2 -1)]-central
      
      
    }
  
  }
  return(list(feature = featMat, label = labMat))
}



