########################
### Super-resolution ###
########################

### Author: Chengliang Tang
### Project 3

superResolution <- function(LR_dir, HR_dir, modelList){
  
  ### Construct high-resolution images from low-resolution images with trained predictor
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + a list for predictors
  
  ### load libraries
  library("EBImage")
  n_files <- length(list.files(LR_dir))
  
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img", "_", sprintf("%04d", i), ".jpg"))
    pathHR <- paste0(HR_dir,  "img", "_", sprintf("%04d", i), ".jpg")
    featMat <- array(NA, c(dim(imgLR)[1] * dim(imgLR)[2], 8, 3))
    
    # Total Dimensions
    img_col <- ncol(imgLR)
    img_row <- nrow(imgLR)

    #srow <- rep(1:dim(imgLR)[1],dim(imgLR)[2])+1
    #scol <- rep(dim(imgLR)[1],dim(imgLR)[2])+1
    
    srow <- (1 :(dim(imgLR)[1] * dim(imgLR)[2]) - 1) %% img_row + 1
    scol <- (1 :(dim(imgLR)[1] * dim(imgLR)[2]) - 1) %/% img_row + 1
 
    
    ### step 1. for each pixel and each channel in imgLR:
    ###           save (the neighbor 8 pixels - central pixel) in featMat
    ###           tips: padding zeros for boundary points
    
    
    
    # for(j in 1:3){ 
    #   ### step 1.2. save (the neighbor 8 pixels - central pixel) in featMat
    #   ###           tips: padding zeros for boundary points
    #   
    #   total <- cbind(0, imgLR[,,j], 0)
    #   total <- rbind(0, total, 0)
    #   central <- total[cbind(srow +1, scol+1)]
    #   featMat[(i-1)*n_points + 1:n_points, 1, j] <- total[cbind(srow, scol)]-central
    #   featMat[(i-1)*n_points + 1:n_points, 2, j] <- total[cbind(srow, scol + 1)]-central
    #   featMat[(i-1)*n_points + 1:n_points, 3, j] <- total[cbind(srow, scol+2)]-central
    #   featMat[(i-1)*n_points + 1:n_points, 4, j] <- total[cbind(srow +1, scol+2)]-central
    #   featMat[(i-1)*n_points + 1:n_points, 5, j] <- total[cbind(srow +2, scol+2)]-central
    #   featMat[(i-1)*n_points + 1:n_points, 6, j] <- total[cbind(srow+2, scol+1)]-central
    #   featMat[(i-1)*n_points + 1:n_points, 7, j] <- total[cbind(srow+2, scol)]-central
    #   featMat[(i-1)*n_points + 1:n_points, 8, j] <- total[cbind(srow+1, scol)]-central
    # }
    
    
    for (j in c(1:3)) {
      # supplementary image matrix
      help_imgLR <- cbind(0, imgLR[, , j], 0)
      help_imgLR <- rbind(0, help_imgLR, 0)
      center <- help_imgLR[cbind(srow+1, scol+1)]
      
      ### featM 
      featMat[,  1, j] <- help_imgLR[cbind(srow,scol)] - center
      featMat[,  2, j] <- help_imgLR[cbind(srow,scol + 1)] - center
      featMat[,  3, j] <- help_imgLR[cbind(srow,scol + 2)] - center
      featMat[,  4, j] <- help_imgLR[cbind(srow + 1,scol)] - center
      featMat[,  5, j] <- help_imgLR[cbind(srow + 1,scol + 2)] - center
      featMat[,  6, j] <- help_imgLR[cbind(srow + 2,scol)] - center
      featMat[,  7, j] <- help_imgLR[cbind(srow + 2,scol + 1)] - center
      featMat[,  8, j] <- help_imgLR[cbind(srow + 2,scol + 2)] - center
    }
    
    ### step 2. apply the modelList over featMat
    predMat <- test(modelList, featMat)
    
    ### step 3. recover high-resolution from predMat and save in HR_dir
    
    pred_A <- array(predMat, dim = c(img_col*img_row, 4, 3))
    LRMat <- as.numeric(rep(imgLR), 4)
    LRMat <- array(LRMat, dim = c(img_col*img_row, 3, 4))
    LRMat <- aperm(LRMat, c(1,3,2))
    HRMat <- LRMat + pred_A
    
    imgHR <- array(dim = c(img_row*2, img_col*2, 3))
    imgHR[seq(1,img_row*2,2),seq(1,img_col*2,2),] <- HRMat[,1,]
    imgHR[seq(1,img_row*2,2),seq(2,img_col*2,2),] <- HRMat[,2,]
    imgHR[seq(2,img_row*2,2),seq(1,img_col*2,2),] <- HRMat[,3,]
    imgHR[seq(2,img_row*2,2),seq(2,img_col*2,2),] <- HRMat[,4,]
    
    imgHR <- Image(imageData(imgHR), colormode = Color)
    writeImage(imgHR, paste0(HR_dir, "img", "_", sprintf("%04d", i), ".jpg"))
    
    
    
  }
}