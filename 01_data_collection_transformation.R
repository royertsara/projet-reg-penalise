library(tidyverse)
library(readr)
library(readxl)

wd<-getwd()
setwd(wd)

# Load the master dataset

data<-read_csv("balanced_can_md.csv")
view(data)

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
