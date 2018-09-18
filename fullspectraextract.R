library(raster)
library(functions)

qual <- .6

files <- list.files(pattern = "*.nc")
finaldata <- data.frame()
i <- 1

for (i in 1:length(files)){
  first <- 0
  ii <- 1
  x <- raster(files[i], varname = "rfl_img", band = wavelengthtoindex(665))
  #there is a calibrarion card in the image, this removes it
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
  }
  
  for (ii in 1:955) {
    x <- raster(files[i], varname = "rfl_img", band = ii)
    x <- as.vector(x)
    
    #if no variation in data then all values will be NA after scalling
    if (length(x1) > 0) {
      x <- clustersub(x, fit, 1)
    }
    
    tmp <- data.frame(index = ii, intensity = x)
    
    if (first == 1 && quality > qual) {
      data <- rbind(data, tmp)
    }
    
    if (first == 0 && quality > qual) {
      data <- tmp
      first <- 1
    }
    print(paste(round((i/length(files))*100), "% of files and (", round((ii/995)*100), "%) of bands done", sep = ""))
    
  }
  
  colnames(data) <- c("index",paste("intense", i, sep = "."))
  
  ifelse(length(finaldata) == 0, finaldata <- data, finaldata <- merge(finaldata, data, by="index"))
  
}