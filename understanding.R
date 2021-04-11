load(url('https://tbep-tech.github.io/ecometab-r-training/data/apadtd.RData'))
head(apadtd)

tz <- attr(apadtd$DateTimeStamp, which = 'tzone')
lat <- 29.6747
long <- -85.0583

apaeco <- WtRegDO::ecometab(apadtd, DO_var = "DO_nrm", tz = tz, lat = lat, long = long)
head(apaeco)

library(ggplot2)

## ggplot(data = apaeco)

## ggplot(data = apaeco, aes(x = Date, y = Pg))

ggplot(data = apaeco, aes(x = Date, y = Pg)) + 
  geom_point()

ggplot(data = apaeco, aes(x = Date, y = Pg)) + 
  geom_point() + 
  geom_line()

library(lubridate)
library(dplyr)

apasum <- mutate(apaeco, mo = month(Date))
head(apasum)

ggplot(apasum, aes(x = mo, y = Pg, group = mo)) + 
  geom_boxplot()

apasum <- group_by(apasum, mo)
apasum <- summarise(apasum, meanpg = mean(Pg, na.rm = T))

ggplot(apasum, aes(x = mo, y = meanpg)) + 
  geom_point() +
  geom_line()

## load(url('https://tbep-tech.github.io/ecometab-r-training/data/sapdtd.RData'))

# add a date column
apasum <- mutate(apadtd, Date = date(DateTimeStamp))

# group by date
apasum <- group_by(apasum, Date)

# summmarise average water temperature
apasum <- summarise(apasum, meantemp = mean(Temp, na.rm = T))

# join water quality with metabolism
apasum <- inner_join(apasum, apaeco, by = 'Date')

p <- ggplot(data = apasum, aes(x = meantemp, y = Pg)) + 
  geom_point()
p

## load(url('https://tbep-tech.github.io/ecometab-r-training/data/sapdtd.RData'))
## sapeco <- WtRegDO::ecometab(sapdtd, DO_var = 'DO_nrm', lat = 31.39, long = -81.28, tz = 'America/Jamaica')

apadbnut <- import_local(path = 'data', station_code = 'apadbnut')

apadbnut <- qaqc(apadbnut, qaqc_keep = c('0', '1', '2', '3', '4', '5'))
head(apadbnut)

apadbnut <- mutate(apadbnut, Date = date(datetimestamp))

apajoin <- inner_join(apaeco, apadbnut, by = 'Date')

ggplot(apajoin, aes(x = chla_n, y = Pg)) + 
  geom_point()

# floor nutrient dates
apadbnut <- mutate(apadbnut,
    dateflr = floor_date(Date, unit = 'month')
  )

# floor metabolism dates
apaeco <- mutate(apaeco, 
    dateflr = floor_date(Date, unit = 'month')
  )

# group by and summarise apadbnut
apadbnut <- group_by(apadbnut, dateflr)
apadbnut <- summarise(apadbnut, 
  chla_n = mean(chla_n, na.rm = T), 
  nh4f = mean(nh4f, na.rm = T)
  )

# group by and summarise metabolism
apaeco <- group_by(apaeco, dateflr)
apaeco <- summarise(apaeco, 
  Pg = mean(Pg, na.rm = T), 
  Rt = mean(Rt, na.rm = T), 
  NEM = mean(NEM, na.rm = T)
  )

# join
apajoin <- inner_join(apaeco, apadbnut, by = 'dateflr')

ggplot(apajoin, aes(x = chla_n, y = Pg)) + 
  geom_point()
