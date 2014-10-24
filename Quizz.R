
#Question 1 

#Step 2 : 
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv",destfile="Q1.csv",method="curl")

X  <- read.csv(file="Q1.csv", header = TRUE, sep = ",")

#Step 1 : Create a logical vector that identifies the households on greater than 10 acres (ACR=3) who sold more than $10,000 worth of agriculture products (AGS=6)
#Assign that logical vector to the variable agricultureLogical. 
agricultureLogical <- (X$ACR==3 & X$AGS==6)

#Step 2 : Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE. which(agricultureLogical) 
which(agricultureLogical)


#Question 2

install.packages("jpeg")
library(jpeg)

download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg",destfile="jeff.jpg",method="curl")
img <- readJPEG(source="jeff.jpg", native=TRUE)

quantile(img,na.rm=TRUE,probs=c(0.3,0.8))


#Question 3

download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",destfile="FGDP.csv",method="curl")
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",destfile="FED.csv",method="curl")


FGDP  <- read.csv(file="FGDP.csv", header = FALSE, sep = ",", skip=5)
FED  <- read.csv(file="FED.csv", header = TRUE, sep = ",")

FGDP <- FGDP[(FGDP$V1!="" & FGDP$V2!=""),]
#Steps
# Match the data based on the country shortcode. 
# How many of the IDs match? Sort the data frame in descending order by GDP rank (so United States is last).  189
# What is the 13th country in the resulting data frame? St. Kitts and Nevis

mergedData = merge(FGDP,FED,by.x="V1",by.y="CountryCode",all=FALSE)
summary(mergedData$V1)

DF <- data.frame(mergedData[,c("V1","V5","Short.Name")])
DF$NN <- as.numeric(gsub(",","",DF$V5))

head(DF[order(DF$NN),],13)

#Question 4
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
DF <- data.frame(mergedData[,c("V2","Income.Group")])
DF$NN <- as.numeric(gsub(",","",DF$V2))

tapply(DF$NN,DF$"Income.Group",mean)

#Question 5
#Cut the GDP ranking into 5 separate quantile groups. 
#Make a table versus Income.Group. How many countries are Lower middle income but among the 38 nations with highest GDP?
DF <- data.frame(mergedData[,c("V2","Income.Group")])
DF$NN <- as.numeric(gsub(",","",DF$V2))

QQ <- quantile(DF$NN,probs = c(0,0.2,0.4,0.6,0.8,1))
ind <- cut(DF$NN, QQ, include.lowest = TRUE) 

AA <- split(DF$NN,ind)
DF[(DF$NN %in% AA[[1]] & DF$"Income.Group" == "Lower middle income"),]

