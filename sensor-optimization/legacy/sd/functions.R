
####Simulate data from a smaller dataset
simfun <- function(data) {
  pdf_of_data <- density(data)
  
  sim <- approx(cumsum(pdf_of_data$y) / sum(pdf_of_data$y),
                pdf_of_data$x,
                runif(simsize))$y
  sim[is.na(sim)] <- mean(sim, na.rm = TRUE)
  return(sim)
}



