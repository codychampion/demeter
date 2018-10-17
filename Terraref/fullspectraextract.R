library(raster)
wavelengthtoindex <- function(wavelength){
  index <- (wavelength-380)/(2/3)
  index <- round(index)
  return(index)
}

indextowavelength <- function(index){
  wavelength <- (index*(2/3))+380
  wavelength <- round(wavelength)
  return(wavelength)
}



library(dplyr)

qual <- .3


files <- list.files(pattern = "*.nc")
#files <- read.table("filelistfull.csv", quote="\"", comment.char="")
#files[] <- lapply(files, as.character)
finaldata <- data.frame()
i <- 1
data <- NULL

for (i in 1:length(files)) {
 # download.file(files$V1[i], destfile = paste("./", i, "data.nc", sep = "."))
  first <- 0
  ii <- 1
  
  
  maskA <- raster(files[i], band = wavelengthtoindex(950))
  maskB <- raster(files[i], band = wavelengthtoindex(840))
  maskC <- raster(files[i], band = wavelengthtoindex(900))
  
  
  xA <- as.vector(maskA)
  xB <- as.vector(maskB)
  xC <- as.vector(maskC)
  
  combo <- data.frame(xA, xB, xC)
  
  x1 <- rowMeans(combo)
  
  #if no variation in data then all values will be NA after scalling
  if (length(x1) > 0) {
    # K-Means Cluster Analysis
    fit <- kmeans(x1, 2)
    
  }
  
  for (ii in 1:955) {
    x <- raster(files[i], varname = "rfl_img", band = ii)
    #e <- extent(202.8447, 204.4113, 7.312396, 7.84031)
    #x <- crop(x, e)
    x <- as.vector(x)
    
    #if no variation in data then all values will be NA after scalling
    if (length(x1) > 0) {
      x <- data.frame(x, cluster = fit$cluster)
      x <- subset(x, cluster == 1)
      x <- x[,1]
      x <- mean(x)
    }
    
    tmp <- data.frame(index = ii, intensity = x)
    
    if (first == 1) {
      data <- rbind(data, tmp)
    }
    
    if (first == 0) {
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

write.csv(finaldata, file="avgwave.csv")


library(tidyverse)
library(cowplot)
theme_set(theme_cowplot())

mean_sem = function(x, n=1) {
  data_frame(y = mean(x),
             sem =  sqrt(var(x)/length(x)),
             ymin = y - sem,
             ymax = y + sem)
}

ggplot() + geom_point(data = finaldata %>% gather(key, value, -index), aes(index, value)) +
  xlab("nm")+
  #stat_summary(fun.y=mean, geom="point") +
  scale_x_continuous(breaks=c(400, 500, 600, 700, 750, 800, 850, 900, 1000))






remove_outliers <- function(x) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
  caps <- quantile(x, probs=c(.10, .90), na.rm = T)
  x[x < (qnt[1] - H)]  (qnt[2] + H)] <- caps[2]
  x
}

ii <- 1
for(ii in 1:nrow(finaldata)){
  test <- remove_outliers(as.numeric(finaldata[ii,-1]))
  cleaned <- c(as.numeric(finaldata[ii,1]), test)
  ifelse(ii == 1, finalclean <- cleaned, finalclean <- rbind(finalclean, cleaned))
  print(ii)
}

finalclean <- as.data.frame(finalclean)
colnames(finalclean) <- colnames(finaldata)



ggplot() + geom_point(data = finalclean %>% gather(key, value, -index), aes(index, value)) +
  xlab("nm")+
  #stat_summary(fun.y=mean, geom="point") +
  scale_x_continuous(breaks=c(400, 500, 600, 700, 750, 800, 850, 900, 1000))







ggplot(finalclean %>% gather(key, value, -index), aes(index, value)) +
  stat_summary(fun.data=mean_sem, geom="errorbar", width=0.1) +
  stat_summary(fun.y='mean', geom="line") +
  xlab("nm")+
  #stat_summary(fun.y=mean, geom="point") +
  scale_x_continuous(breaks=c(400, 500, 600, 700, 750, 800, 850, 900, 1000))


length(files)

