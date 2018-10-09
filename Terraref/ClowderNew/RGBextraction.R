library(raster)

setwd("data")
files <- list.files(pattern=".tif$")

#create a mask layer using the green channel
mask <- raster(files[1], band = 2)
x <- as.vector(mask)
fit <- kmeans(x, 2)
threshold <- fit$centers[1]
mask[mask < threshold] <- NA
plot(mask)

#apply mask 
img1 <- raster(files[1], band = 1)
img3 <- raster(files[1], band = 3)
stack <- stack(img1, img3, mask)
processed <- mask(stack, sum(stack, fun=sum))

plotRGB(processed, r=1, g=3, b=2)

green <- mean(x)
red <- mean(as.vector(img1))
blue <- mean(as.vector(img3))