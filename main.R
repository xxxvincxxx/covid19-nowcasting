library(tidyverse)
library(janitor)

## load data
id <- "1TLNATbUPRpAmMosvERvOJlDYirc4EHIv" # google file ID
df <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
