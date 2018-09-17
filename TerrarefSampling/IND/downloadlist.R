library(RCurl)
library(stringr)
library(dplyr)

url <- "https://terraref.ncsa.illinois.edu/thredds/catalog.html"
page <- getURL(url)


#Extractout files
ex <- str_extract_all(page, ".*dataset=*(.*?) *_ind.nc.*")


files <- data.frame(ex)
colnames(files) <- "file"

files$time <- substr(files$file, 42, 64)
files$file <- gsub(".*dataset=|'><tt>vnir.*", "", files$file)

files$date <- as.POSIXct(files$time,format="%Y-%m-%d")


selection <- files %>%
                group_by(date) %>%
                sample_n(1)

selection <- as.data.frame(selection)


i <- 1

for(i in 1:nrow(selection)){
comm <- noquote(paste(
  "wget --no-check-certificate --content-disposition --directory-prefix=D:/INDSpectra https://terraref.ncsa.illinois.edu/thredds/fileServer/uamac_hs_vnir/",
  selection$file[i],
  "&",
  sep = ""
))
  ifelse(i == 1, bash <- data.frame(comm = comm), bash <- rbind(bash, comm))
  }


write.table(bash, "downloadlist.txt", row.names = F, col.names = F, quote = F)





