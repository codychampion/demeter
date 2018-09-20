library(raster)
library(functions)

qual <- .6

files <- list.files(pattern = "*.nc")
finaldata <- data.frame()
i <- 1

for (i in 1:length(files)) {
  first <- 0
  ii <- 1
  x <-
    raster(files[i], varname = "rfl_img", band = wavelengthtoindex(665))
  #there is a calibrarion card in the image, this removes it
  #e <- extent(202.8447, 204.4113, 7.312396, 7.84031)
  #x <- crop(x, e)
  #kmeans cluster setup, scaleing may be used, need to read more lit
  x1 <- scale(as.vector(x))
  #if a missing vaule is generaten replace with mean of dataset
  x1 <- ifelse(is.na(x1), mean(x1, na.rm = TRUE), x1)
  
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
    
    if (ii == 955) {
      data$intensity <-
        (data$intensity  - min(data$intensity)) / (max(data$intensity) - min(data$intensity))
    }
    
    print(paste(
      round((i / length(files)) * 100),
      "% of files and (",
      round((ii / 995) * 100),
      "%) of bands done",
      sep = ""
    ))
    
  }
  
  colnames(data) <- c("index", paste("intense", i, sep = "."))
  
  ifelse(
    length(finaldata) == 0,
    finaldata <- data,
    finaldata <- merge(finaldata, data, by = "index")
  )
  
}

finaldata$index <- indextowavelength(finaldata$index)
finaldata <- finaldata[ , colSums(is.na(finaldata)) == 0]



library(tidyverse)
library(cowplot)
theme_set(theme_cowplot())

mean_sem = function(x, n=1) {
  data_frame(y = mean(x),
             sem =  sqrt(var(x)/length(x)),
             ymin = y - sem,
             ymax = y + sem)
}

ggplot(finaldata %>% gather(key, value, -index), aes(index, value)) +
  stat_summary(fun.data=mean_sem, geom="errorbar", width=0.1) +
  stat_summary(fun.y=mean, geom="line") +
  #stat_summary(fun.y=mean, geom="point") +
  scale_x_continuous(breaks=c(400, 500, 600, 700, 750, 800, 850, 900, 1000))


length(files)


