# 1. Reading Data
install.packages(R.utils)
library(R.utils)
gunzip("C:/Users/14802/Desktop/Minsub/Master/ANA515/WK6/StormEvents_details-ftp_v1.0_d1992_c20220425.csv.gz", remove=FALSE)

stormEvent <- read.csv(file = 'C:/Users/14802/Desktop/Minsub/Master/ANA515/WK6/StormEvents_details-ftp_v1.0_d1992_c20220425.csv')

# 2. Limit Data
limitStormEvent <- subset(stormEvent, select = c("BEGIN_YEARMONTH","BEGIN_DATE_TIME", "END_DATE_TIME", "EPISODE_ID", "EVENT_ID", "STATE", "STATE_FIPS", "CZ_NAME", "CZ_TYPE", "CZ_FIPS", "EVENT_TYPE", "SOURCE", "BEGIN_LAT", "BEGIN_LON", "END_LAT", "END_LON"))

# 3. Arrange Data
limitStormEvent <- limitStormEvent[with(limitStormEvent,order(BEGIN_YEARMONTH)),]

# 4.Change Title Case
library(stringr)
limitStormEvent$STATE = str_to_title(limitStormEvent$STATE)
limitStormEvent$CZ_NAME = str_to_title(limitStormEvent$CZ_NAME)


# 5.Limit to C
limitStormEvent_CZ <- limitStormEvent[ which(limitStormEvent$CZ_TYPE =='C'),]
limitStormEvent_CZ = subset(limitStormEvent_CZ, select = -c(CZ_TYPE) )


# 6.Pad
limitStormEvent_CZ$STATE_FIPS = str_pad(limitStormEvent_CZ$STATE_FIPS, width=3, side="left", pad="0")
limitStormEvent_CZ$CZ_FIPS = str_pad(limitStormEvent_CZ$CZ_FIPS, width=3, side="left", pad="0")
library(tidyr)
limitStormEvent_CZ = unite(limitStormEvent_CZ,col='fips'
                                , c('STATE_FIPS', 'CZ_FIPS') , sep = "", remove = TRUE)

# 7.to lower case
limitStormEvent_CZ <- rename_all(limitStormEvent_CZ, tolower)

# 8.state_dataframe
state_dataframe <- data.frame(state=state.name, region=state.region, area=state.area)

# 9.Merge
Newset_beforeMerge<- data.frame(table(limitStormEvent_CZ$state))
mergedTable <- merge(x=Newset_beforeMerge,y=state_dataframe,by.x="Var1", by.y="state")

# 10.Plot
library(ggplot2)
storm_plot <- ggplot(mergedTable, aes(x = area, y = Freq)) +
  geom_point(aes(color = region)) +
  labs(x = "Land area (square miles)",
       y = "# of storm events in 1992")
storm_plot

