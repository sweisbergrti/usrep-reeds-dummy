print("Starting calculation of fuelcostprep.R")

library(dplyr)

if(!exists("Args")) Args=commandArgs(TRUE)

setwd(paste0(Args[1],"inputs\\"))

test_flag = Args[2]
outdir = Args[3]
print(outdir)

print(test_flag)

test_df = read.csv(".\\test_inputs2.csv", header = T, stringsAsFactors = F)
test_df = test_df %>% filter(state %in% c('California','Arizona'), year == 2025)
test_df = test_df %>% mutate(value = test_flag)

write.csv(test_df, paste0(outdir,'test_outputs2.csv'), row.names = F)

print("fuelcostprep.R completed successfully")
