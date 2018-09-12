library(raster)
library(ncdf4)

#min qul
final <- NULL

qual <- .7

files <- list.files(pattern="*.nc")

#get variable names
ncin <- nc_open(files[1])
vars <- names(ncin$var)


#extract variables
i <- 1
for(i in 1:length(vars)){
  first <- 0
  print(vars[i])
  ii <- 1
  for(ii in 1:length(files)){
    
    #extract variable data
    x <- raster(files[ii], varname = vars[i])
    x <- as.vector(x)
    
    #get time code
    timecode <- sub(".*mac_", "", files[ii])
    timecode <- sub("_ind.*", "", timecode)
    
    #convert to UNIX timem stamp
    timecode <- as.POSIXct(timecode,format="%Y-%m-%d__%H-%M-%S")
    
    
    #kmeans cluster setup, scaleing may be used, need to read more lit
    x <- scale(x)
    x <- na.omit(x)
    
    #if no variation in data then all values will be NA after scalling
    if(length(x) > 0){
      
      # K-Means Cluster Analysis
      fit <- kmeans(x, 2)
      
      quality <- fit$betweenss/(fit$tot.withinss+fit$betweenss)
      #we assume that first cluster is largest (should check source code)
      x <- data.frame(x, fit$cluster)
      x <- subset(x, fit.cluster == 1)
      x <- x[,1]
      x <- mean(x)
      
      
      tmp <- data.frame(time = timecode, var = x)
      
      if(first == 1 && quality > qual){
        data <- rbind(data, tmp)
      }
      
      if(first == 0 && quality > qual){
        data <- tmp
        first <- 1
      }
      
      
      #If kmeans seperted the data then find sd
      if(ii == length(files) && length(unique(as.numeric(data$time)))/length(file) > 0.5){
        sd <- sd(data$var, na.rm=TRUE)
        sd <- data.frame(var = vars[i], sd = sd)
        if(length(final) == 0){final <- sd}
        if(length(final) > 0){final <- rbind(final, sd)}
      }
      
    }
  }
  
}



final <- final[complete.cases(final),]
final <- droplevels(final)
final <- final[order(final$sd),]
row.names(final) <- c()
final


