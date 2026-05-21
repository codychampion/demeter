#framate data contained in a list of files 
dataformatwhite <- function(white){
  i <- 1
  #read white standard files and find
  for (i in 1:length(white)) {
    #read data and format into numeric data type and convert to wide format
    wdata <-
      read.csv(white[i], stringsAsFactors = FALSE)
    wdata <- wdata[-1]
    wdata[3] <- rep_len('white', nrow(wdata))
    wdata[4] <- rep_len(i, nrow(wdata))
    colnames(wdata) <- c('wave', 'val', 'con', 'rep')
    #Clean up insterment quirks and normalize to total light recoreded
    wdata <- tail(wdata, -163) #remove first 20 rows
    if (min(wdata$val) < 0) {
      wdata$val <- wdata$val + (-1 * min(wdata$val))
    }
    wdata$val <- wdata$val / max(wdata$val)
    #conditonal loop data storage
    if (i == 1) {
      wfulldata <- wdata
    }
    if (i != 1) {
      wfulldata <- rbind(wfulldata, wdata)
    }
  }
  
  #here we round wave lenght then combine the vals
  wfulldata$wave <- round(wfulldata$wave)
  
  wfulldata <- wfulldata %>%
    dplyr::group_by(wave, rep, con) %>%
    dplyr::summarise(val = mean(val))
  
  wfulldata <- as.data.frame(wfulldata)
  
  
  #Average all rwplicates
  wfulldata <- wfulldata %>%
    dplyr::group_by(wave) %>%
    dplyr::summarise(ave = mean(val))
  
  wfulldata <- as.data.frame(wfulldata)
  
  
  
  return(wfulldata)
  
}