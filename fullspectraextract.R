library(raster)

files <- list.files(pattern="*.nc")


i <- 1
for(i in length(files)){

  ii <- 1
  for(ii in 1:955){
  x <- raster(files[1], varname = "rfl_img", band=ii)

  }

}