setwd('C:/Users/cchampio/Dropbox/demeter')



condition <- 'salt'
area <- 'leaf'
date <- Sys.time()
filename <- paste(condition, area, date, sep = '.')


#read data in
x <- readClipboard()
#remove first row, extranious data
x <- x[-1]

#convert to data frame
foo <- data.frame(do.call('rbind', strsplit(as.character(x),'\t',fixed=TRUE)))

#convert to numeric data type and rename coulmns
asNumeric <- function(x) as.numeric(as.character(x))
factorsNumeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)],   
                                                   
                                                   asNumeric))

f <- factorsNumeric(foo)
colnames(f) <- c('wave', 'value')


###################csv archive
setwd('./csv_archive')
meta <- data.frame(filename, date, condition, area)
write.csv(meta, "metadata.csv", append = TRUE)
filename <- gsub(" ", "", filename, fixed = T)
filename <- gsub(":", "_", filename, fixed = T)

write.csv(f, paste(filename, '.csv', sep = ''))


##sql database




################
#reflectance calulation
#pams to use, 1-5 boxcar, 40ms to 1 sec, 10 scanes to average, normalize to max vaules

#data <- 100
#background <- 1
#ref <- 100
#(((data-background)/(ref-background)))*100





