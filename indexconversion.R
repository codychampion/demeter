wavelengthtoindex(wavelength, direction){
  wavelength <- 1e+9*wavelength
  index <- (wavelength-0.0000004)/0.0000000006
  return(index)
}

indextowavelength(index){
  wavelength <- (index*6e-10)+4e7
  wavelength <- 1e+9*wavelength
  return(wavelength)
}