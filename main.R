library(tidyverse)
library(janitor)

## load data from googledoc;
## the document comes from FKI covid19 data up to July 2020
## (I was still in Berlin back then, wondering around Tempelhof)
id <- "1TLNATbUPRpAmMosvERvOJlDYirc4EHIv" # google file ID
df <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
