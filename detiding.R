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
