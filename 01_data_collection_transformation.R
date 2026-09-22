library(tidyverse)
library(readr)
library(readxl)

wd<-getwd()
setwd(wd)

# Load the master dataset

data<-read_csv("balanced_can_md.csv")


# collect the tcode and region level data : national,CAN

tcode<-read_excel("Table_can_md.xlsx") |> 
  select(Variable,Region,Codes) |> 
  filter(!is.na(Codes))

# Create a vector with the geographic level

region_vec<- c("CAN",tcode$Region)



# Logic: we only want country level data marked CAN or NA in the vector
if (ncol(data)==length(region_vec)){
  data_filtered<-data[,(region_vec=="CAN"|is.na(region_vec))]
  print(paste("Nb of variables ",ncol(data_filtered)))
} else{
  print("Columns don't match the region vector")
}

# Inspecting the data
summary(data_filtered)

# Missing values 
colSums(is.na(data_filtered))

# We got missing data on credits (total,houslod,mortgage,consumption,buisness) 
# Discontinuted due to a change of policy between Bank of Canada and StatCan who aggred on a single credit statistics 
# Now credits data are handled by StatCan

# We then remove those datas

can_data<-data_filtered |> 
  select(-CRED_T_discontinued,-CRED_HOUS_discontinued,-CRED_MORT_discontinued,-CRED_CONS_discontinued,-CRE_BUS_discontinued) |> 
  # We select a reasonable time-frame 1990-2026 M6  
  filter(Date %within% interval("1990-01-01","2026-06-01") )

# Save the data we will work on
saveRDS(can_data,"can_data.rds")
