# load SWMPr
library(SWMPr)

# import data
apadbwq <- import_local(path = 'data', station_code = 'apadbwq')

# characteristics of the dataset
head(apadbwq)
dim(apadbwq)
range(apadbwq$datetimestamp)

# keep only observations that passed qaqc chekcs
apadbwq <- qaqc(apadbwq, qaqc_keep = '0')

# check the results
head(apadbwq)
dim(apadbwq)
range(apadbwq$datetimestamp)

# import weather data, clean it up
apaebmet <- import_local(path = 'data', station_code = 'apaebmet')
apaebmet <- qaqc(apaebmet, qaqc_keep = '0')

# check the results
head(apaebmet)
dim(apaebmet)
range(apaebmet$datetimestamp)

# combine water quality and weather data
apa <- comb(apadbwq, apaebmet, timestep = 15, method = 'union')

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

apa[which(is.na(apa$Tide))[1:5], ]

# number of rows before
nrow(apa)

# omit missing rows
apa <- na.omit(apa)

# number of rows after
nrow(apa)
