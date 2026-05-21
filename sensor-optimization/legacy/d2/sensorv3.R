  library(dplyr)
  library(ggplot2)
  
  setwd("~/Demeter2")
  source("functions.R")
  
  ###
  stopCluster(cl)
  
  FWHM <- read.csv("FWHM.csv")
  ranges <- read.csv("ranges.csv")
  
  FWHM_range <- nrow(FWHM)
  ranges_range <- nrow(FWHM) + nrow(ranges)
  ########################################
  camera <-
    read.csv("pi-camera-response-curves-master/Sony_IMX219_spectral_response.csv")
  
  #########################
  simsize <- 250
  setwd('./csv_archive')
  files <- list.files()
  conditions <- c('control', 'salt', 'highGlyco', 'lowGlyco')
  #todo
  #sun reflex conversion
  ####################################3
  i <- 1
  for (i in 1:length(conditions)) {
    #define file list
    current_condition <- files[grep(conditions[i], files)]
    white <- files[grep('white', files)]
    
    ######################################################################
    #White Section

    wfulldata <- dataformat(white)
    
  
    #Average all rwplicates
    wfulldata <- wfulldata %>%
      dplyr::group_by(wave) %>%
      dplyr::summarise(ave = mean(val))
    
    wfulldata <- as.data.frame(wfulldata)
    
    #######################################################################
  fulldata <- dataformat(current_condition)

  }
  
  #Sanity check
  #ggplot(fulldata, aes(x = wave, y = val, colour = con)) + geom_smooth()
  #ggplot(fulldata, aes(x = wave, y = val, colour = con)) + geom_line()
  
  
  ##########################################################################
  #Simulation section
  #this could be simpler but it works, make a wide dataset
  out <- split(fulldata , f = list(fulldata$con, fulldata$wave))
  #here we simulate a larger dataset with current data
  #Simulation function, make pdf of data then random pull from distribution

  #Simuate data
  s <- 1
  for (s in 1:length(out)) {
    tmp <- as.data.frame(out[s])
    ifelse(tmp[1, 3] == 'control', con <- 'control', con <- 'stress')
    
    sim <- simfun(tmp[, 2])
    sim_data <-
      data.frame(
        wave = rep_len(tmp[1, 1], length(sim)),
        val = sim,
        con = rep_len(con, length(sim)),
        rep = c(1:length(sim))
      )
    
    if (s == 1) {
      data_out <- sim_data
    }
    if (s != 1) {
      data_out <- rbind(data_out, sim_data)
    }
    
    pb$tick()    
    
  }
  fulldata <- data_out
  
  
  
  colnames(camera)[1] <- 'wave'
  len <- c(701:1023)
  cameraend <-
    data.frame(
      wave = len,
      red = (9945 / 161) - ((5 * len) / 161),
      green = (19001 / 322) - ((17 * len) / 322),
      blue = (5115 / 161) - ((5 * len) / 161)
    )
  
  camera <- rbind(camera, cameraend)
  
  
  full <- merge(fulldata, camera, by = 'wave')
  
  final <- NULL
  final$wave <- full$wave
  final$rep <- full$rep
  final$con <- full$con
  final$red <- full$red * full$val
  final$blue <- full$blue * full$val
  final$green <- full$green * full$val
  
  final <- as.data.frame(final)
  
  
  fulldata <- final
  
  
  
  ##########################################################################
  #Sanity check, raw data
  #r1 <- ggplot(final, aes(x = wave, y = red, colour = con)) + geom_smooth() + ggtitle("red")
  #r2 <- ggplot(final, aes(x = wave, y = red, colour = con)) + geom_line() + ggtitle("red")
  
  #b1 <- ggplot(final, aes(x = wave, y = blue, colour = con)) + geom_smooth() + ggtitle("blue")
  #b2 <- ggplot(final, aes(x = wave, y = blue, colour = con)) + geom_line() + ggtitle("blue")
  
  #g1 <- ggplot(final, aes(x = wave, y = green, colour = con)) + geom_smooth() + ggtitle("green")
  #g2 <- ggplot(final, aes(x = wave, y = green, colour = con)) + geom_line() + ggtitle("green")

  #library(gridExtra)
  
  #gridExtra::grid.arrange(r1, r2, b1, b2, g1, g2, nrow = 3)
  
  #clean up unneed datasets
  rm(data_out, out, sim_data, tmp, data)
  
  #####################################################################################
  #Fitness function
  library(caret)
  #function to convert dataset into what a filter would record
  # TODO set up H2O functions
  filter_ind <- function(filternumber, data) {
    if (filternumber > FWHM_range &&
        is.na(ranges$nm.min[filternumber - FWHM_range]) == F) {
      filterdata <- ranges[filternumber - FWHM_range, ]
      upperbound <- filterdata$nm.max
      lowerbound <- filterdata$nm.min
      
      #set filter to still be in data range
      if (upperbound > 1022) {
        upperbound <- 1022
      }
      if (lowerbound < 401) {
        lowerbound <- 401
      }
      
      if (lowerbound > upperbound) {
        upperbound <- 403
      }
      
      price <- filterdata$price
      
      out <- fulldata %>%
        dplyr::group_by(con, rep) %>%
        dplyr::filter(wave > lowerbound & wave < upperbound) %>%
        summarise(
          filter_avg_r = sum(red, na.rm = TRUE),
          filter_avg_b = sum(blue, na.rm = TRUE),
          filter_avg_g = sum(green, na.rm = TRUE)
        )
      out <- as.data.frame(out)
    }
    #todo blocking and FWHM
    if (filternumber < FWHM_range + 1) {
      filterdata <- FWHM[filternumber, ]
      FWHMdata <- filterdata$nm.FWHM
      CWL <- filterdata$nm.CWL
      price <- filterdata$price
      
      upperbound <- CWL + FWHMdata
      lowerbound <- FWHMdata - CWL
      
      #set filter to still be in data range
      if (upperbound > 1022) {
        upperbound <- 1022
      }
      if (lowerbound < 401) {
        lowerbound <- 401
      }
      
      if (lowerbound > upperbound) {
        upperbound <- 403
      }
      
      price <- filterdata$price
      
      out <- fulldata %>%
        dplyr::group_by(con, rep) %>%
        dplyr::filter(wave > lowerbound & wave < upperbound) %>%
        summarise(
          filter_avg_r = sum(red, na.rm = TRUE),
          filter_avg_b = sum(blue, na.rm = TRUE),
          filter_avg_g = sum(green, na.rm = TRUE)
        )
      out <- as.data.frame(out)
    }
    
    #blocking
    if (filternumber > FWHM_range &&
        is.na(ranges$nm.min[filternumber - FWHM_range]) == T) {
      filterdata <- ranges[filternumber - FWHM_range, ]
      price <- filterdata$price
      
      #lower work
      upperbound <- filterdata$block.min
      lowerbound <- 401
      
      #set filter to still be in data range
      if (upperbound > 1022) {
        upperbound <- 1022
      }
      if (lowerbound < 401) {
        lowerbound <- 401
      }
      
      if (lowerbound > upperbound) {
        upperbound <- 403
      }
      
      
      outlow <- fulldata %>%
        dplyr::group_by(con, rep) %>%
        dplyr::filter(wave > lowerbound & wave < upperbound) %>%
        summarise(
          filter_avg_r = sum(red, na.rm = TRUE),
          filter_avg_b = sum(blue, na.rm = TRUE),
          filter_avg_g = sum(green, na.rm = TRUE)
        )
      outlow <- as.data.frame(outlow)
      
      
      price <- filterdata$price
      
      #lower work
      upperbound <- 1022
      lowerbound <- filterdata$block.max
      
      #set filter to still be in data range
      if (upperbound > 1022) {
        upperbound <- 1022
      }
      if (lowerbound < 401) {
        lowerbound <- 401
      }
      
      if (lowerbound > upperbound) {
        upperbound <- 401
      }
      
      
      outhigh <- fulldata %>%
        dplyr::group_by(con, rep) %>%
        dplyr::filter(wave > lowerbound & wave < upperbound) %>%
        summarise(
          filter_avg_r = sum(red, na.rm = TRUE),
          filter_avg_b = sum(blue, na.rm = TRUE),
          filter_avg_g = sum(green, na.rm = TRUE)
        )
      outhigh <- as.data.frame(outhigh)
      
      
      
      
      colnames(outhigh) <- c('con', 'rep', 'highr', 'highb', 'highg')
      colnames(outlow) <- c('con', 'rep', 'lowr', 'lowb', 'lowg')
      
      outtmp <- merge(outhigh,
                      outlow,
                      by = c('con', 'rep'),
                      all = T)
      out <- data.frame(con = outtmp$con)
      out$rep <- outtmp$rep
      
      
      out$filter_avg_r <- sum(outtmp$highr, outtmp$lowr, na.rm = T)
      out$filter_avg_b <- sum(outtmp$highb, outtmp$lowb, na.rm = T)
      out$filter_avg_g <- sum(outtmp$highg, outtmp$lowg, na.rm = T)
      
      
    }
    
    out <- list("data" = out, "price" = price)
    
    return(out)
  }
  #Fitness function defined
  filternumber <- 2000
  filternumber2 <- 100
  filternumber3 <- 1230
  filters <- 3
  model <- 1
  
  #filtre is the fitness function
  filter <-
    function(filternumber,
             filternumber2,
             filternumber3,
             filters,
             model) {
      #set filter number and model number to whole number
      filters <- round(filters)
      model <- round(model)
      filternumber <- round(filternumber)
      filternumber2 <- round(filternumber2)
      filternumber3 <- round(filternumber3)
      
      price1 <- 0
      price2 <- 0
      
      out <- filter_ind(filternumber)
      price <- out$price
      out <- out$data
      if (filters == 2 || 3) {
        out1 <- filter_ind(filternumber2)
        price1 <- out1$price
        out1 <- out1$data
        
      }
      if (filters == 3) {
        out2 <- filter_ind(filternumber3)
        price2 <- out2$price
        out2 <- out2$data
      }
      
      
      if (filters == 2 ||
          3) {
        out3 <- merge(out, out1, by = c('con', 'rep'))
      }
      if (filters == 3) {
        out4 <- merge(out3, out2, by = c('con', 'rep'))
      }
      
      if (filters == 1) {
        data <- out
      }
      if (filters == 2) {
        data <- out3
      }
      if (filters == 3) {
        data <- out4
      }
      
      data$rep <- NULL
      
      #setup models
      control <- trainControl(method = "repeatedcv",
                              number = 10,
                              repeats = 5)
      modellist <-
        c("rf", 'glm', 'lm', 'adaboost', 'avNNet', 'svm', 'C5.0')
      
      print(modellist[model])
      
      err <- 0
      
      start <- proc.time()
      acc <- 0
      rf_default <-
        tryCatch(
          train(
            con ~ .,
            data = data,
            method = modellist[model],
            trControl = control,
            parallel = TRUE
          )
          ,
          error = function(e) {
            err <- 1
          }
        )
      
      end <- proc.time()
      
      time <- end - start
      
      #if there is an error then set fitness to 0
      #if there is no error then accuracy is recorded
      if (err == 0) {
        acc <- print(rf_default)
        
        acc <- as.data.frame(acc)
        acc <- acc$Accuracy
        acc <- as.numeric(levels(acc))
        acc <- max(acc)
        
        
        
        if (filters == 1) {
          fit <-
            acc - (0.000001 * as.numeric(time[3])) - (price) / 1025
        }
        
        
        if (filters == 2) {
          fit <-
            acc - 0.25 - (0.000001 * as.numeric(time[3])) - (price + price1) / 1925
        }
        
        
        if (filters == 3) {
          fit <-
            acc - 0.5 - (0.000001 * as.numeric(time[3])) - (0.001 * (price + price1 + price2))
        }
        
        
        
      }
      
      if (err == 1) {
        fit <- 1000
        err <- 0
      }
      cost <- (price + price1 + price2)
      print(paste(
        "fitness = ",
        round(pmax(fit, 0), 3),
        " cost = $",
        cost ,
        " time = ",
        round(as.numeric(time[3])) ,
        "sec",
        sep = ""
      ))
      
      
      return(pmax(fit, 0))
    }
  #Sanity check of function
  fitness <- filter(1560, 100, 980, 3, 7)
  ################################################################################
  #GA section
  library(GA)
  library(doParallel)
  cl <- makePSOCKcluster(8)
  registerDoParallel(cl)
  
  GA <- ga(
    type = "real-valued",
    fitness =  function(x)
      + filter(x[1], x[2], x[3], x[4], x[5]),
    min = c(1, 1, 1, 1, 1),
    max = c(2681, 2681, 2681, 3, 7),
    popSize = 100,
    maxiter = 25,
    run = 25,
    #parallel = cl,
    monitor = plot
  )
  summary(GA)
  plot(GA)
  stopCluster(cl)
