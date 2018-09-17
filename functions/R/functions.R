# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

#the basis for these equations is from http://terraref.org/articles/lemnatec-scanalyzer-field-sensors/
# key data is that the camera has a 380-1000 nm @ 2/3 nm resolution
#potental issue is that 620 (1000-380) has 930 incriments, have 25 extra

#' convert wavelength (nm) into an index number for the terraref dataset.
#'
#' @param wavelength A number in nm
#'
#' @examples
#' wavelengthtoindex(450)
wavelengthtoindex <- function(wavelength){
  index <- (wavelength-380)/(2/3)
  index <- round(index)
  return(index)
}

#' convert an index into a wavelength for the terraref dataset.
#'
#' @param index A number
#'
#' @examples
#' indextowavelength(450)
indextowavelength <- function(index){
  wavelength <- (index*(2/3))+380
  wavelength <- round(wavelength)
  return(wavelength)
}



#' Function to use data from kmeans cluster to subset data
#'
#' @parm x a vector from a raster
#' @parm fit a kmeans model
#' @param cluster a specific kemans cluster
#'
clustersub <- function(x, fit, cluster=1){
  x <- data.frame(x, fit$cluster)
  x <- subset(x, fit.cluster == cluster)
  x <- x[,1]
  x <- mean(x)
  return(x)
}
