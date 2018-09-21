# library(devtools)
# build(), install()

#the basis for these equations is from http://terraref.org/articles/lemnatec-scanalyzer-field-sensors/
# key data is that the camera has a 380-1000 nm @ 2/3 nm resolution
#potental issue is that 620 (1000-380) has 930 incriments, have 25 extra

#' \code{wavelengthtoindex} converts wavelength (nm) into an index number for the terraref dataset.
#'
#' @param wavelength A wavelenghth nm
#' @return an index
#' @export
#' @examples
#' wavelengthtoindex(450)
wavelengthtoindex <- function(wavelength){
  index <- (wavelength-380)/(2/3)
  index <- round(index)
  return(index)
}

#' \code{indextowavelength} converts an index into a wavelength for the terraref dataset.
#'
#' @param index A number
#' @return wavelenght (nm)
#' @export
#' @examples
#' indextowavelength(450)
indextowavelength <- function(index){
  wavelength <- (index*(2/3))+380
  wavelength <- round(wavelength)
  return(wavelength)
}



#' \code{clustersub} Function to use data from kmeans cluster to subset data
#'
#' @param x a vector from a raster
#' @param fit a kmeans model
#' @param cluster a specific kemans cluster
#' @export
#'
clustersub <- function(x, fit, cluster){
  x <- data.frame(x, cluster = fit$cluster)
  x <- subset(x, cluster == cluster)
  x <- x[,1]
  x <- mean(x)
  return(x)
}










spectraplot <- function(df, ){
library(tidyverse)
theme_set(theme_bw())

median_sd = function(x, n=1) {
  data_frame(y = median(x),
             sd = sd(x),
             ymin = y - n*sd,
             ymax = y + n*sd)
}

plot <- ggplot(df %>% gather(key, value, -ID), aes(ID, value)) +
  stat_summary(fun.data=median_sd, geom="errorbar", width=0.1) +
  stat_summary(fun.y=median, geom="line") +
  stat_summary(fun.y=median, geom="point") +
  scale_x_continuous(breaks=unique(df$ID))
return(plot)
}

