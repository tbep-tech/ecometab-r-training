# load SWMPr
library(SWMPr)

# import data
apadbwq <- import_local(path = 'data', station_code = 'apadbwq')

# characteristics of the dataset
head(apadbwq)
dim(apadbwq)
range(apadbwq$datetimestamp)

# keep only observations that passed qaqc chekcs
apadbwq <- qaqc(apadbwq, qaqc_keep = c('0', '1', '2', '3', '4', '5'))

# check the results
head(apadbwq)
dim(apadbwq)
range(apadbwq$datetimestamp)

# import weather data, clean it up
apaebmet <- import_local(path = 'data', station_code = 'apaebmet')
apaebmet <- qaqc(apaebmet, qaqc_keep = c('0', '1', '2', '3', '4', '5'))

# check the results
head(apaebmet)
dim(apaebmet)
range(apaebmet$datetimestamp)

# combine water quality and weather data
apa <- comb(apadbwq, apaebmet, timestep = 60, method = 'union')

# check the results
head(apa)
dim(apa)
range(apa$datetimestamp)

# load WtRegDO
library(WtRegDO)

# view first six rows of SAPDC
head(SAPDC)

# View the structure of SAPDC
str(SAPDC)

# view first six rows of apa
head(apa)

# view the structure of apa
str(apa)

# load dplyr
library(dplyr)

# select and rename columns
apa <- select(apa,
  DateTimeStamp = datetimestamp, 
  Temp = temp, 
  Sal = sal, 
  DO_obs = do_mgl,
  ATemp = atemp, 
  BP = bp, 
  WSpd = wspd, 
  Tide = depth
)

# show first six rows
head(apa)

# view structure
str(apa)

names(apa) == names(SAPDC)

apa[which(is.na(apa$Tide))[1:5], ]

# number of rows before
nrow(apa)

# omit missing rows
apa <- na.omit(apa)

# number of rows after
nrow(apa)

knitr::include_graphics('figure/tidecorex.png')

# get time zone
tz <- attr(apa$DateTimeStamp, which = 'tzone')
lat <- 29.6747
long <- 85.0583

evalcor(apa, tz = tz, lat = lat, long = long)

dtd <- wtreg(apa, tz = tz, lat = lat, long = long)

head(dtd)

library(plotly)

plot_ly(dtd, x = ~DateTimeStamp, y = ~DO_obs, name = 'Observed DO', type = 'scatter', mode = 'lines') %>% 
  add_trace(y = ~DO_nrm, name = 'Detided DO', mode = 'lines') %>% 
  layout(xaxis = list(title = NULL), yaxis = list(title = "DO (mg/L)"))
