library(WtRegDO)
head(SAPDC)

library(SWMPr)
library(dplyr)

# step 1
apadbwq <- import_local('data', 'apadbwq')

# step 2
apaebmet <- import_local(path = 'data', station_code = 'apaebmet')

# step 3
keeps <- c('0', '1', '2', '3', '4', '5')
apadbwq <- qaqc(apadbwq, qaqc_keep = keeps)
apaebmet <- qaqc(apaebmet, qaqc_keeep = keeps)

# step 4
apa <- comb(apadbwq, apaebmet, timestep = 60)

# step 5
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

# step 6
apa <- na.omit(apa)

tz <- attr(apa$DateTimeStamp, which = 'tzone')
lat <- 29.6747
long <- -85.0583

apaeco <- WtRegDO::ecometab(apa, DO_var = "DO_obs", tz = tz ,lat = lat, long = long)
head(apaeco)

plot(apaeco)

plot(apaeco, by = 'days')

library(WtRegDO)
dts <- as.Date(c('2012-02-01','2012-02-08')) 

data(metab_obs)
p <- plot(metab_obs, by = 'days') + facet_zoom(x = Date >= as.numeric(dts[1]) & Date <= as.numeric(dts[2]), zoom.size = 1)
p

meteval(apaeco)

## apadtd <- wtreg(apa, tz = tz, lat = lat, long = long)

apadtdeco <- WtRegDO::ecometab(apadtd, DO_var = "DO_nrm", tz = tz ,lat = lat, long = long)

plot(apadtdeco, by = 'days')
meteval(apadtdeco)
