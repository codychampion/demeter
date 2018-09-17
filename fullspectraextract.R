library(raster)
qual <- .6

files <- list.files(pattern = "*.nc")

i <- 1
for (i in length(files)){
  first <- 0
  ii <- 1
  for (ii in 1:955) {
    x <- raster(files[1], varname = "rfl_img", band = ii)
    #e <- extent(202.8447, 204.4113, 7.312396, 7.84031)
    #x <- crop(x, e)
    x <- as.vector(x)
    #kmeans cluster setup, scaleing may be used, need to read more lit
    x1 <- scale(x)
    # <- na.omit(x1)
    x1 <- ifelse(is.na(x1), mean(x1, na.rm = TRUE), x1)
    x1 <- na.omit(x1)
    
    #if no variation in data then all values will be NA after scalling
    if (length(x1) > 0) {
      # K-Means Cluster Analysis
      fit <- kmeans(x1, 2)
      
      quality <- fit$betweenss / (fit$tot.withinss + fit$betweenss)
      #we assume that first cluster is largest (should check source code)
      x <- data.frame(x, fit$cluster)
      x <- subset(x, fit.cluster == 1)
      x <- x[, 1]
      x <- mean(x)
    }
    
    tmp <- data.frame(index = ii, intensity = x)
    
    if (first == 1 && quality > qual) {
      data <- rbind(data, tmp)
    }
    
    if (first == 0 && quality > qual) {
      data <- tmp
      first <- 1
    }
    
  }
}