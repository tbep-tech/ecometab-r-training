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
