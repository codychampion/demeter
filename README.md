# TerraRef (see https://terraref.ncsa.illinois.edu/thredds/catalog.html)

1. downloadlist.R is a file that creates a text file that when copied into command line will download a random file from the data site, requires wget to be installed.

2. indSD.R will take a directory containing ind.nc files, extract data, calculate the sd over each variable. 
- 1. indSR.csv is the data obtained from this process.

3. ratiodef.txt contains formal definitions for variables for the ind files.

4. fullspectraextract.R creates an average of the spectra of plants in datasets.  Using chlorophyll peak of 665 nm to mask image (group using kmeans then forms a mask layer) and we only extract plant associated pixels.  Data is then normalized using the min, and max observed reflectance.

5. utlilty_functions.R are functions to convert the band/index term to wavelength and vice versa.
