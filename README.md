#Getting and Cleaning Data - Week 3

## Subsetting and sorting

####Selecting rows

```
X[c(1,3)]
```

Selecting columns (and rows)

```
X[,1]

colnames(X)<-c("v1","v2","v3")
X$v1
x$v1[c(1,3)]
```

Applying logic on row values (or = alt+shift+L)

```
X[ (X$v1 <= 3 & X$v3 > 11) ,]
X[ (X$v1 <= 3 | X$v3 > 11) ,]
```

By default NA values are TRUE in logical test. If you want to exclude them use ```which```

```
X[ (X$v2 > 8) ,] # NA are appearing
X[ which(X$v2 > 8) ,] # NA are excluded
```
---
#### Ordering and sorting
Sorting : ```sort(X$v1,decreasing=TRUE,na.last=TRUE)```

Ordering (inside a data frame) : ```X[order(X$v1,X$v2),]```

Ordering with plyr

```
library(plyr)
arrange(X,v1)
arrange(X,desc(v1))
```
---
#### Adding rows

First syntax:

```
X$NewColumn <- rnorm(5)
colnames(X)<-c(colnames(X)[1:3],"v4")
```

Second syntax:

```
Y <- cbind(X,rnorm(5))
```

## Summarizing Data
#### Summaries
Usual suspects:

```
head(DF)
summary(DF)
str(DF)

quantile(X$v1,na.rm=TRUE,probs=c(0.5,0.75,0.9))
```

List and count distinct values

```
table(X$v1)
table(X$v1,X$v2)
```
---
#### Checking things

Check for missing values

```
sum(is.na(X$v2))
any(is.na(X$v2)) # are some true?
all(X$v3 > 0) # are all true?
```

Summing columns and rows (totals)

```
colSums(X$v1)
colSums(is.na(X))

all(colSums(is.na(X))==0)
```

Finding specific values

```
table(restData$zipCode %in% c("21212","21213"))
restData[restData$zipCode %in% c("21212","21213"),]
```

---
#### "Pivot Tables"

Cross tabs:

```
xt <- xtabs(Measure ~ Axis1 + Axis2, data = DF) 
```
**NB** : ~ = alt+n

If you don't precise axis (```~ .```), it'll act on them in order: Axis1, Axis2, Page1, Page2... You still have to precise the measure

```
xt <- xtabs(Freq ~ . , data = DF)
```

Flat tables (some sort of Pivot Table):

```
ftable(xt)
```

---
#### "Size on disk of a data set"

Size on disk

```
object.size(DF)
print(object.size(DF),units="Mb")
```

## Creating new variables

Sequences

```
s <- seq(1,10,by=2,length=8)
seq(along = vectorX)
```

Subsetting and adding the new value to the original set

```
restData$nearMe <- restData$neighborhood %in% c("Roland Park", "Homeland")

restData$zipWrong <- ifelse(restData$zipCode < 0, TRUE, FALSE)
```

Creating categorical variables

```
restData$zipGroups <- cut(restData$zipCode, breaks=quantile(restData$zipCode))
```

Easier way to do categories cut

```
library(Hmisc)
restData$zipGroups <- cut2(restData$zipCode,g=4)
```
## Reshaping Data
A good form is:

* Each variable forms a column
* Each observation forms a row
* Each table/file stores data about only one kind of observation


```
library(reshape2)
```

Unpivoting data : Melting (dataset, fields, measures to be pivoted)

```
carMelt <- melt(mtcars, id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
```

Casting data frames (group by)

```
cylData<- dcast(carMelt, cyl ~ variable,mean)
```

Averaging values

```
InsectSprays:

  count spray
1    10     A
2     7     A

tapply(InsectSprays$count,InsectSprays$spray,sum)
```

Averaging by splitting

```
unlist(
	lapply(
		split(InsectSprays$count,InsectSprays$spray)
		,sum)
	)

# OR

sapply(
	split(InsectSprays$count,InsectSprays$spray)
	,sum
)
```

Averaging and Grouping using the plyr package


```
library(plyr)

ddply(InsectSprays,.(spray),summarize,sum=sum(count))

```

## Merging Data (join)

Use the **merge()** command, important parameters : x, y, by, by.x, by.y, all

```
mergedData = merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE)
```

Use the plyr package, faster but less full featured. Default is left join.

```
library(plyr)

arrange(join(df1,df2),id)

arrange(join(df1,df2,df3),id)
```
