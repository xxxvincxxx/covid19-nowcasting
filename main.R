library(tidyverse)
library(janitor)
library(lubridate)

## load data from googledoc;
## the document comes from FKI covid19 data up to July 2020
## (I was still in Berlin back then, wondering around Tempelhof)

#####################################
## It doesn't work for some reason!##
#####################################

# id <- "1TLNATbUPRpAmMosvERvOJlDYirc4EHIv" # google file ID
# df <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
# 
# ## replace empty values with NA 
# df[df==''] <- NA
# 
# ## convert dates format into cast date
# df <- df %>%
#   mutate(Reporting_Date = as.Date(Reporting_Date)) %>%
#   mutate(Symptom_Start_Date = as.Date(Symptom_Start_Date)) %>%
#   # clean names to lower case 
#   # calculate delay as the difference between reporting_date and symptom_start_date
#   mutate(delay = Reporting_Date - Symptom_Start_Date) %>%
#   clean_names()

#############

## Import DF 
df <- read_delim("data/RKI_COVID19_Simplified_2020-07-29.csv", delim = ",") %>%
  janitor::clean_names() %>%
  mutate(delay = reporting_date - symptom_start_date) %>%
  # filter positive cases 
  filter(cases > 0) -> df

#######
## 1 ##
#######

##  Distribution of cases over time
##  Number of daily cases by Symtom_Start_Date for June and July 2020. 
##  You will see that the number of cases by Symtom_Start_Date drops at the end of July, 
##  because some cases get reported later and these late cases are not yet reported for
##  the last Symtom_Start_Dates.
  
## -> basically replicate this: https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Situationsberichte/2020-07-31-en.pdf?__blob=publicationFile

## symptom_start_date plot:
df %>%
  mutate(delay = as.numeric(delay)) %>%
  filter(delay < 14) %>%
  filter(symptom_start_date >= '2020-06-01') %>%
  group_by(symptom_start_date) %>%
  summarise(cases = sum(cases)) %>%
  ggplot(aes(symptom_start_date, cases)) + geom_line() + stat_smooth(method = loess) +
  # expand graph limits on the y axis
  expand_limits(y = c(0, 900))

## In the new sample (aka 2020-06-01/2020-07-28), how many 
## unreported cases there are?

df %>%
  filter(reporting_date >= '2020-07-01') -> df_res


df_res %>%
  tabyl(delay)

df_res %>%
  mutate(sym_reported = ifelse(is.na(symptom_start_date)==T,"no","yes")) %>%
  tabyl(sym_reported) %>%
  adorn_pct_formatting()

hist(as.numeric(df$delay))

## Replicate the graph from RKI

df_res %>%
  group_by(symptom_start_date) %>%
  summarise(cases_symp = sum(cases))










