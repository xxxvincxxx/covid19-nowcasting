library(tidyverse)
library(janitor)

## load data from googledoc;
## the document comes from FKI covid19 data up to July 2020
## (I was still in Berlin back then, wondering around Tempelhof)

id <- "1TLNATbUPRpAmMosvERvOJlDYirc4EHIv" # google file ID
df <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))

## replace empty values with NA 
df[df==''] <- NA

## check the data and use janitor to fix the names
df %>%
  janitor::clean_names() %>%
  mutate(delay = reporting_date - symptom_start_date)

