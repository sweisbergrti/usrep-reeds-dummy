print("")
print("Installing necessary packages")
print("")

list.of.packages <- c('dplyr','data.table')

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages,repos = "http://cran.rstudio.com/", dep = TRUE)

print("Finished installing packages")