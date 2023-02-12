
source("LanguageQuestionnare.R")
source("LanguageQuestionnare_2010.R")
source("LanguageQuestionnare_2011.R")
source("LanguageQuestionnare_from2012.R")
source("LanguageQuestionnare_from2015.R")
source("LanguageQuestionnare_from2016.R")
source("LanguageQuestionnare_from2017.R")
source("LanguageQuestionnare_from2019.R")
source("LanguageQuestionnare_2021.R")
source("LanguageQuestionnare_2022.R")
source("SetOfLanguageQuestionnaries.R")

if (!exists("data.readed") || is.null(data.readed)) {
  cat("DATA.READ start\n")
  d2010_12 <- new("LanguageQuestionnare_2010", when=as.Date("2010-12-01"),
                        data = read.csv("../2010_12/questionnaire1_cleaned.csv", stringsAsFactor = FALSE))
  d2011_07 <- new("LanguageQuestionnare_2011",when=as.Date("2011-07-01"),
                        data = read.csv("../2011_07/questionnaire2_cleaned.csv", stringsAsFactor = FALSE))
  d2012_05 <- new("LanguageQuestionnare_from2012",when=as.Date("2012-05-01"), 
                        data=read.csv("../2012_05/questionnaire3_cleaned.csv", stringsAsFactor = FALSE))
  d2013_01 <- new("LanguageQuestionnare_from2012",when=as.Date("2013-01-01"), 
                        data=read.csv("../2013_01/questionnaire4_cleaned.csv", stringsAsFactor = FALSE))
  d2014_01 <- new("LanguageQuestionnare_from2012",when=as.Date("2014-01-01"), 
                        data=read.csv("../2014_01/questionnaire5_cleaned.csv", stringsAsFactor = FALSE))
  d2015_01 <- new("LanguageQuestionnare_from2015",when=as.Date("2015-01-01"), 
                        data=read.csv("../2015_01/questionnaire6_cleaned.csv", stringsAsFactor = FALSE))
  d2016_01 <- new("LanguageQuestionnare_from2016",when=as.Date("2016-01-01"), 
                        data=read.csv("../2016_01/questionnaire7_cleaned.csv", stringsAsFactor = FALSE))
  d2017_01 <- new("LanguageQuestionnare_from2017",when=as.Date("2017-01-01"), 
                        data=read.csv("../2017_01/questionnaire8_cleaned.csv", stringsAsFactor = FALSE))
  d2018_01 <- new("LanguageQuestionnare_from2017",when=as.Date("2018-01-01"), 
                        data=read.csv("../2018_01/q9.csv", stringsAsFactor = FALSE))
  d2019_01 <- new("LanguageQuestionnare_from2019",when=as.Date("2019-01-01"), 
                        data=read.csv("../2019_01/q10.csv", stringsAsFactor = FALSE))
  d2020_01 <- new("LanguageQuestionnare_from2019",when=as.Date("2020-01-01"), 
                        data=read.csv("../2020_01/q11.csv", stringsAsFactor = FALSE))
  d2021_01 <- new("LanguageQuestionnare_2021",when=as.Date("2021-01-01"), 
                        data=read.csv("../2021_01/q12.csv", stringsAsFactor = FALSE))
  d2022_01 <- new("LanguageQuestionnare_2022", when=as.Date("2022-01-01"),
                        data=read.csv("../2022_01/lang-2022-data.csv", sep = ';'))
  d2023_01 <- new("LanguageQuestionnare_2022", when=as.Date("2023-01-01"),
                        data=read.csv("../2023_01/lang-rating-2023.csv", sep = ';'))
  data.readed <- TRUE
}

cat("DATA.READED\n")

sq <- new("SetOfLanguageQuestionnaries",
            questionaries = list(
              "2010-12" = d2010_12,
              "2011-07" = d2011_07,
              "2012-05" = d2012_05,
              "2013-01" = d2013_01,
              "2014-01" = d2014_01,
              "2015-01" = d2015_01,
              "2016-01" = d2016_01,
              "2017-01" = d2017_01,
              "2018-01" = d2018_01,
              "2019-01" = d2019_01,
              "2020-01" = d2020_01,
              "2021-01" = d2021_01,
              "2022-01" = d2022_01
            )
          )

cat("FIRST LANGUAGE graph1\n")

svg("firstlanguage.svg", width=6.8, height=3.8)
x <- languageColumnSummaries(sq,"FirstLanguage",top=12,toPlot=TRUE, 
                             when=c("2022-01"),
                             plot.col=rainbow(7, start=0.2, end=0.7),
                             plot.title="На каком языке вы написали свою первую программу ?",
                             las=2
)
dev.off()


cat("FIRST LANGUAGE graph2\n")

svg("firstlanguageHist.svg", width=6.8, height=3.8)
x <- languageColumnSummaries(sq,"FirstLanguage",top=12,toPlot=TRUE, 
                             when=c("2012-05","2013-01","2014-01","2015-01","2016-01",
                                    "2017-01","2018-01","2019-01","2020-01","2021-01",
                                    "2022-01"),
                              plot.col=rainbow(11, start=0.2, end=0.9),
                              plot.title="На каком языке вы написали свою первую программу ?",
                              las=2
                            )
dev.off()


cat("NOW LANGUAGE graph\n")

drawNowLanguage <- function() {
  languageColumnSummaries(sq,"NowLanguage",top=21,toPlot=TRUE, 
                          when=c("2022-01"), las=2, plot.col=c("blue"),
                          plot.title="What programming languages you use now for work?",
  )
}

svg("nowlanguage.svg", width=6.8, height=3.2)
x <- drawNowLanguage()
dev.off()
write.csv(x,file="../2022_01/NowLanguage.csv")



cat("NOW LANGUAGE graph1\n")

drawNowLanguageHistory <- function() {
# 2011-08 decluded
   languageColumnSummaries(sq,"NowLanguage",
                             when=c("2012-05","2013-01","2014-01","2015-01","2016-01","2017-01","2018-01","2019-01","2020-01","2021-01"),
                             top=20,toPlot=TRUE, 
                             plot.col=rainbow(10,start=0.2,end=0.8),
                             plot.title="What programming languages you use now for work?",
                             las=2
)
}

png("nowlanguageInHistory.png", width=1020, height=570)
x <- drawNowLanguageHistory()
dev.off()
write.csv(x,file="../2022_01/NowLanguageHistory.csv")


svg("nowlanguageInHistory.svg", width=6.8, height=3.8)
x <- drawNowLanguageHistory()
dev.off()


png("nowLanguageBackend.png", width=1020, height=570)
x <- languageColumnSummaries(sq, 'NowLanguage', 
       when=c("2022-01"), top=15, toPlot=TRUE, 
       local.filter=function(x){ filter(x@data, Area=='BackEnd') })
dev.off()
write.csv(x,file="../2022_01/NowLanguageBackend.csv")

png("nowLanguageBackendHistory.png", width=1020, height=570)
x <- languageColumnSummaries(sq, 'NowLanguage', 
       when=c("2021-01","2022-01"), top=15, toPlot=TRUE, 
       local.filter=function(x){ filter(x@data, Area=='BackEnd') })
dev.off()
write.csv(x,file="../2022_01/NowLanguageBackendHistory.csv")


png("nowLanguageGameDev.png", width=1020, height=570)
x <- languageColumnSummaries(sq, 'NowLanguage', 
       when=c("2021-01","2022-01"), top=10, toPlot=TRUE, 
       local.filter=function(x){ filter(x@data, Area=='GameDev') })
dev.off()
write.csv(x,file="../2022_01/NowLanguageGameDevHistory.csv")


# Areas
png("Area.png", width=1020, height=570)
x <- languageColumnSummaries(sq, 'Area', 
       when=c("2022-01"), top=9, toPlot=TRUE)
dev.off()
write.csv(x,file="../2022_01/Area.csv")



significant <- significantChanges(sq,"NowLanguage","2022-01","2021-01")
write.csv(significant,file="../2022_01/Significant.csv")

significant2 <- significantChanges(sq,"NowLanguage","2022-01","2020-01")
write.csv(significant,file="../2022_01/Significant2.csv")


#significantChanges(sq,"NowLanguage","2011-07","2013-01")

cat("NOW LANGUAGES 2 \n")

drawNowLanguages2 <- function() {
  languageColumnSummaries(sq,"NowLanguages2",top=20,toPlot=TRUE, 
                          when=c("2021-01"),
                          plot.title="Одна з основних мов програмування",
                          las=2
  )
}


cat("NEXT LANGUAGE \n")

drawNextLanguage <- function() {
  languageColumnSummaries(sq,"NextLanguage",top=20,toPlot=TRUE, 
                          when=c("2022-01"),
                          plot.title="Якщо б ви зараз починали коммерційний проект \n і обирали мову програмування",
                          las=2
  )
}


drawNextLanguageHistory <- function() {
  languageColumnSummaries(sq,"NextLanguage",top=16,toPlot=TRUE, 
                          when=c("2013-01","2014-01","2015-01","2016-01","2017-01","2018-01", "2019-01", "2020-01", "2021-01","2022-01"),
                          plot.col=rainbow(10,start=0.2,end=0.9),
                          plot.title="Якщо б ви зараз починали коммерційний проект \n і обирали мову програмування",
                          las=2
  )
}

png("../2022_01/nextlanguage.png", width=1020, height=570)
par(mar=c(7,5,4,5))
x <- drawNextLanguage() 
dev.off()
write.csv(x,file="../2022_01/NextLanguage.csv")





#svg("nextlanguagehistory.svg", width=6.8, height=3.8)
#%x <- drawNextLanguageHistory() 
#dev.off()


png("../2022_01/nextlanguagehistory.png", width=1020, height=570)
x <- drawNextLanguageHistory() 
dev.off()
write.csv(x,file="../2021_01/NextLanguageHistory.csv")



cat("SATISFACTION \n")

svg("satisfaction.svg")
 x <- satisfactionIndex(getQuestionnaire(sq,"2022-01"), barrier=10)
 cr <- colorRampPalette(c('black','blue'))(length(x))
 dotchart(x[order(x)],col=cr)
dev.off()
write.csv(x[order(x)],file="../2022_01/Satisfaction.csv")


png("../2022_01/satisfaction.png")
x <- satisfactionIndex(getQuestionnaire(sq,"2022-01"), barrier=10)
cr <- colorRampPalette(c('black','blue'))(length(x))
dotchart(x[order(x)],col=cr)
dev.off()


cat("LEARN \n")

                          
png("learnInNextYearPie.png", width=500, height=500)
 x <- languageColumnSummaries(sq, 'LearnLanguage', top=12,
                            when=c("2022-01"), toPlot=TRUE,  
                            local.filter=function(x){ x@data })
 #x <- x[x!=""]
 #x <- table(x)
 pie(x,main="Чи плануєте ви наступного року вивчити нову мову програмування?")
dev.off()
write.csv(x,file="../2022_01/LearnLanguage.csv")


#svg("learnlanguageHistory.svg", width=6.8, height=3.2)
#x <- languageColumnSummaries(sq,"LearnLanguage",top=20,toPlot=TRUE,
#                             when=c("2018-01","2019-01","2020-01","2021-01"),
#                             plot.col=rainbow(4,start=0.2),
#                             plot.title="What languages you plan to learn in the next year?",
#                             las=2
#                            )
#dev.off()

png("learnlanguageHistory.png", width=680, height=320)
x <- languageColumnSummaries(sq,"LearnLanguage",top=20,toPlot=TRUE,
                             when=c("2018-01","2019-01","2020-01","2021-01","2022-01"),
                             plot.col=rainbow(4,start=0.2),
                             plot.title="What languages you plan to learn in the next year?",
                             las=2
)
dev.off()
write.csv(x,file="../2022_01/LearnLanguageHistory.csv")


#x <- summary(as.factor(d2022_01@data$LearnWay))
x <- table(grepl(".*допомогою професійних викладачів.*", d2022_01@data$LearnWay))
x <- x/sum(x)

svg("learnlanguagePie.svg", width=8.0, height=5.0)
x <- languageColumnPieChart(sq,"2021-01","LearnLanguage",title="Які мови ви збираєтесь вивчити у наступному році?",barrier=0.02,toPlot=TRUE)
dev.off()


png("learnlanguagePie.png", width=800, height=500)
x <- languageColumnPieChart(sq,"2021-01","LearnLanguage",title="Які мови ви збираєтесь вивчити у наступному році",barrier=0.02,toPlot=TRUE,noUnknown=TRUE)
dev.off()
#write.csv(x,file="../2021_01/LearnLanguage.csv")


cat("ADDITIONAL \n")

png("additionallanguageNow.png", width=680, height=320)
#svg("additionallanguageNow.svg", width=6.8, height=4.2)
x <- languageColumnSummaries(sq,"AdditionalLanguages",top=20,toPlot=TRUE,
                             when=c("2022-01"),
                             plot.col=c("blue"),
                             plot.title="What additional languages you use for work?",
                             las=2
                            )
dev.off()
write.csv(x,file="../2022_01/AdditionalLanguages.csv")


svg("additionallanguage.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"AdditionalLanguages",top=20,toPlot=TRUE, 
                             #when=c("2011-07","2012-05","2013-01","2014-01","2015-01","2016-01","2017-01","2018-01","2019-01"),
                             when=c("2017-01","2018-01","2019-01","2020-01","2021-01","2022-01"),
                             plot.col=rainbow(5,start=0.2,end=0.8),
                             plot.title="Какие языки вы используете как дополнительные",
                             las=2
)
dev.off()
write.csv(x,file="../2021_01/AdditionalLanguagesHistory.csv")


cat("PET(NOW) \n")

png("petporjectslanguageNow.png", width=680, height=320)
x <- languageColumnSummaries(sq,"PetProjectsLanguages",top=20,toPlot=TRUE,
                             when=c("2021-01"),
                             plot.col=c("blue"),
                             plot.title="Мови у проектах з відкритим кодом",
                             las=2
)
dev.off()
write.csv(x,file="../2021_01/PetProjectLanguages.csv")

cat("PET\n")

png("petporjectslanguage.png", width=680, height=320)
#svg("petporjectslanguage.svg", width=6.8, height=3.8)
x <- languageColumnSummaries(sq,"PetProjectsLanguages",top=20,toPlot=TRUE,
                             when=c("2013-01","2014-01","2015-01","2016-01","2017-01",
                                    "2018-01","2019-01","2020-01","2021-01","2022-01"),
                             plot.col=rainbow(10,start=0.2,end=0.9),
                             plot.title="What languages you use in pet-projects?",
                             las=2
)
dev.off()
write.csv(x,file="../2021_01/PetProjectLanguagesHistory.csv")

#png("age.png", width=400, height=320)
#ageChart(sq,c("2012-05","2013-01","2014-01","2015-01","2017-01","2018-01","2019-01","2010-01"),toPlot=TRUE)
#dev.off()


q1 <- getQuestionnaire(sq,"2010-12")
q2 <- getQuestionnaire(sq,"2011-07")
q3 <- getQuestionnaire(sq,"2012-05")
q4 <- getQuestionnaire(sq,"2013-01")
q5 <- getQuestionnaire(sq,"2014-01")
q6 <- getQuestionnaire(sq,"2015-01")
q7 <- getQuestionnaire(sq,"2016-01")
q8 <- getQuestionnaire(sq,"2017-01")
q9 <- getQuestionnaire(sq,"2018-01")
q10 <- getQuestionnaire(sq,"2019-01")
q11 <- getQuestionnaire(sq,"2020-01")
q12 <- getQuestionnaire(sq,"2021-01")
q13 <- getQuestionnaire(sq,"2022-01")

q <- q13



cat("EXP\n")

#svg("experienceInProgramming.svg", width=6.8, height=4.4)
png("experienceInProgrammingHistory.png", width=680, height=440)
d <- experienceChart(sq,"ExperienceInProgramming",
  when=c("2014-01","2015-01","2016-01","2017-01","2018-01","2019-01","2020-01","2021-01","2022-01"),
  rel=FALSE)
d <- d[,c("<1","1","2","3","4","5","6","7","8","9","10+")]
barplot(d, beside=TRUE,col=rainbow(9, start=0.1, end=0.9), 
        legend=rownames(d), args.legend=list(x=80),
        main="Досвід роботи по спеціальності")
dev.off()
write.csv(d,file="../2022_01/ExperienceInProgrammingHistory.csv")


png("experienceInProgramming.png", width=680, height=440)
d <- experienceChart(sq,"ExperienceInProgramming",
  when=c("2022-01"),
  rel=TRUE)
d <- d[,c("<1","1","2","3","4","5","6","7","8","9","10+")]
barplot(d, beside=TRUE,col=rainbow(9, start=0.1, end=0.9), 
        legend=rownames(d), args.legend=list(x=80),
        main="Досвід роботи по спеціальності")
dev.off()
write.csv(d,file="../2022_01/ExperienceInProgrammingHistory.csv")

                      
png("experienceInProgrammingByLanguage.png", width=680, height=320)
t <- table(q@data$NowLanguage, q@data$ExperienceInProgramming)
t1 <- as.table(t[c("Java","C#","PHP","JavaScript", "TypeScript", "Kotlin", "Swift", "Scala", "C++","Python","C", "Go", "R"),])
plot(t1, main="Соотношение между языком и опытом работы")
dev.off()
write.csv(t1,file="../2022_01/ExperienceInProgrammingByLanguage.csv")


en <- c("< 1", "1","2","3","4","5","6","7","8","9","10+")
t<-table(q@data$ExperienceInLanguageYears,q@data$ExperienceInProgrammingYears)
  png(file="el.png")
  barplot(t,col=rainbow(11),legend=TRUE,args.legend=list(x=11,y=500))
  title("Досвід роботи програмістом/на обраній мові")
dev.off()
write.csv(t,file="../2021_01/ExperienceInProgrammingByLanguage.csv")


#svg("experiencesMosaic.svg", width=6.8, height=3.2)
#png("experiencesMosaic.png", width=1040, height=570)
#epy <- q@data$ExperienceInProgrammingYears[q@data$ExperienceInProgrammingYears < 25]
#ely <- q@data$ExperienceInLanguageYears[q@data$ExperienceInProgrammingYears < 25]
#t<-table(as.integer(epy),as.integer(ely))
#plot(as.table(t), col=colorRampPalette(c("green","red"))(25), 
#     xlab="in programming", ylab="in current language", main="Experience",
#     las=1)
#dev.off()
#write.csv(t,file="../2021_01/ExperienceMosaic.csv")



png("ageDistribution.png", width=680, height=320)
a <- summary(na.omit(as.factor(q@data$Age)))
#a <- a[names(a)!='23.5'] 
#a <- a[names(a)!='27.5'] 
a <- a/sum(a)
barplot(a)
title("Age distribution")
dev.off()
write.csv(a,file="../2022_01/AgeDistribution.csv")


png("experienceDistribution.png", width=680, height=320)
a <- summary(na.omit(as.factor(as.integer(q@data$ExperienceInProgrammingYears))))

a <- a/sum(a)
barplot(a)
title("Experience distribution")
dev.off()
write.csv(a,file="../2021_01/ExperienceDistribution.csv")


t0 <- table(q@data$NowLanguage,q@data$InUA)
t0 <- apply(t0,2,function(x) { x/sum(x) })
t0 <- t0[c("Java","JavaScript","C#","PHP", "Python", "C++", "Ruby", "Swift","C","Go","TypeScript","Scala"),]
t0 <- t0[,c("Да","Нет")]


t1 <- table(q@data$NowLanguage,q@data$InUA)
t1 <- apply(t1,2,function(x) { x/sum(x) })
t1 <- t1[c("JavaScript","Java","C#", "Python","PHP", "TypeScript","C++", "Ruby", "Swift","C","Go","Scala"),]
t1 <- t1[,c("Так","Ні")]


#svg("languagesNowInUA.svg", width=8.2, height=4.3)
png("languagesNowInUA.png", width=840, height=430)
 barplot(t1,beside=TRUE, col=rainbow(12, start=0, end=0.8),axes=FALSE, 
         names=c("in UA", "! in UA"), legend=rownames(t1), 
         args.legen=list(y=0.20))
dev.off()
write.csv(t1,file="../2021_01/LanguageByCountry.csv")

names(full)[44] <- 'inUA'
t2 <- table(full$Area,full$inUA)
t2 <- apply(t2,2,function(x) { x/sum(x) })
t2 <- t2[c("Бекенд програмування","Веб-фронтенд","Десктоп-розробка","Мобільна розробка","Обробка масивів даних"),]
t2 <- t2[,c("Так","Ні")]

png("areasInUA.png", width=840, height=430)
barplot(t2,beside=TRUE, col=rainbow(5, start=0, end=0.8),axes=FALSE, 
        names=c("in UA", "! in UA"), legend=rownames(t2), 
        args.legen=list(y=0.50))
dev.off()


write.csv(t2,file="../2022_01/AreaByCountry.csv")


t <- table(q@data$InUA[q@data$InUA!=""],q@data$ExperienceInProgrammingYears[q@data$InUA!=""])
t <- apply(t,1, function(x) { 100*x/sum(x) })
png("experienceInUA.png", width=680, height=320)
barplot(t,beside=TRUE, axes=TRUE,
         col=colorRampPalette(c("green","blue"))(48),
         names=c("в Украине", "не в Украине"),
         legend=rownames(t)
       )
dev.off()


t <- table(q@data$InUA,q@data$Age)[c("Так","Ні"),]
t <- apply(t,1, function(x) { x/sum(x) })
#svg("ageInUA.svg", width=6.8, height=3.2)
png("ageInUA.png", width=680, height=320)
barplot(t,beside=TRUE, axes=FALSE, 
         col=colorRampPalette(c("green","blue"))(48),
         names=c("в Україні", "не в Україні"),
         legend=rownames(q@data$Age)
       )
dev.off()
write.csv(t,file="../2021_01/AgeByCountry.csv")


ln <- languageColumnSummary(q@data$NowLanguage,top=22,barrier=5)
x <- subset(q@data,q@data$NowLanguage %in% names(ln))
xm <- sapply(names(ln),function(n) as.integer(summary(q@data$Age[q@data$NowLanguage==n])['Median']) )
x$NowLanguage <- factor(x$NowLanguage, levels=names(xm[order(xm)]))
#png("ageAll.svg", width=6.8, height=3.2)
png("ageAll.png", width=680, height=320)
par(cex.axis=0.8)
r <- boxplot(Age ~ NowLanguage, data=x, las=2, outline=FALSE)
title('Age by programming language.');
par(cex.axis=1)
dev.off()
s <- r$stats
colnames(s) <- r$names
rownames(s) <- c("lower whisker","lower hinge","median","upper hinge","upper whisker")
write.csv(s,file="../2022_01/AgeByLanguage.csv")


xm <- sapply(names(ln),function(n) as.integer(summary(q@data$ExperienceInLanguage[q@data$NowLanguage==n])['Median']) )
x$NowLanguage <- factor(x$NowLanguage, levels=names(xm[order(xm)]))
#svg("experienceInProgrammingByLanguage.svg", width=6.8, height=3.2)
png("experienceInProgrammingByLanguage.png", width=680, height=320)
par(cex.axis=0.8)
r <- boxplot(ExperienceInProgramming ~ NowLanguage, data=x, las=2, outline=FALSE)
title("Experience by programming language")
par(cex.axis=1)
dev.off()
s <- r$stats
colnames(s) <- r$names
rownames(s) <- c("lower whisker","lower hinge","median","upper hinge","upper whisker")
write.csv(s,file="../2021_01/ExperienceByLanguage.csv")




x <- subset(q@data,q@data$FirstLanguage %in% names(ln))
xm <- sapply(names(ln),function(n) as.integer(summary(q@data$Age[q@data$FirstLanguage==n])['Median']) )
x$FirstLanguage <- factor(x$FirstLanguage, levels=names(xm[order(xm)]))
png("ageFirstLanguage.png", width=680, height=320)
par(cex.axis=0.8)
boxplot(Age ~ FirstLanguage, data=x, las=2, outline=FALSE)
title('Возраст разработчиков в зависимости от первого языка');
par(cex.axis=1)
dev.off()

png("firstLanguageOfNovice.png", width=680, height=320)
#svg("firstLanguageOfNovice.svg", width=6.9, height=3.2)
x <- languageColumnSummaries(sq,
        "FirstLanguage",
        toPlot=TRUE, 
        top=10, 
        when=c("2015-01","2016-01","2017-01","2018-01","2019-01","2020-01","2021-01","2022-01"), 
        filter=function(q){ 
          subset(q@data,q@data$ExperienceInProgramming=='<1') 
          }, 
        plot.col=rainbow(8,start=0.2,end=0.8),
        plot.title="First language of developers with experience < year",
        las=2)
dev.off()
write.csv(x,file="../2022_01/FirstLanguageOfNovice.csv")

 

full = full2021


javaOnly <- full[full[4]=='Java',]
jvmVersions = summary(as.factor(javaOnly[,18]))
jvmVersions <- jvmVersions/sum(jvmVersions)
write.csv(jvmVersions,file="../2021_01/java_jvmVersions.csv")

javaIDE <- summary(as.factor(javaOnly[,19]))
javaIDE <- javaIDE[javaIDE > 1]
javaIDE <- javaIDE/sum(javaIDE)
write.csv(javaIDE,file="../2021_01/java_IDE.csv")

names(javaOnly)[13] <- "WebFramework"
wf <- lapply(filter(javaOnly, WebFramework != "")[13], function(x) { unlist(strsplit(x,";")) })
wf1 <- lapply(wf, as.factor)
wfSum <- summary(wf1$WebFramework)
wfSum <- wfSum[order(wfSum, decreasing = TRUE)]
wfSum <- wfSum/sum(wfSum)
write.csv(wfSum,file="../2021_01/java_WebFrameworks.csv")

names(javaOnly)[14] <- "Frameworks"
wf <- lapply(filter(javaOnly, Frameworks != "")[14], function(x) { unlist(strsplit(x,",")) })
wf <- lapply(wf, function(x) { str_to_title(str_trim(x)) })
wf1 <- lapply(wf, as.factor)
wfSum <- summary(wf1$Frameworks)
wfSum <- wfSum[order(wfSum, decreasing = TRUE)]
wfSum <- wfSum/sum(wfSum)
write.csv(wfSum,file="../2021_01/java_Frameworks.csv")

knownFrameworksColumn <- function(dataSet, lang, columnName, columnIndex, barrier) {  
  wf <- lapply(filter(dataSet, sym(columnName) != "")[columnIndex], function(x) { unlist(strsplit(x,";")) })
  wf <- lapply(wf, function(x) { str_to_title(str_trim(x)) })
  wf1 <- lapply(wf, as.factor)
  wfSum <- summary(wf1[[columnName]])
  wfSum <- wfSum[order(wfSum, decreasing = TRUE)]
  wfSum <- wfSum/sum(wfSum)
}

names(javaOnly)[15] <- "DistributedFrameworks"
wSum <- knownFrameworksColumn(javaOnly,"java","DistributedFrameworks", 15, 1)
write.csv(wfSum,file="../2021_01/java_DistributedFrameworks.csv")


frameworkColumn <- function (dataSet,lang, columnName, columnIndex, barrier) {
  names(dataSet)[columnIndex] <- columnName
  wf <- lapply(filter(dataSet,  sym(columnName) != "")[columnIndex], 
               function(x) { unlist(strsplit(x,",")) })
  wf <- lapply(wf, function(x) { str_to_title(str_trim(x)) })
  wf1 <- lapply(wf, as.factor)
  wfSum <- summary(wf1[[columnName]])
  wfSum <- wfSum[order(wfSum, decreasing = TRUE)]
  wfSumFully <- wfSum
  print(wfSumFully)
  wfSum <- wfSum[ wfSum > barrier ]
  wfSum <- wfSum/sum(wfSumFully)
  fname <- paste("../2021_01/",lang,"_",columnName,".csv", sep="")
  wfSum
}


wfSum <- frameworkColumn(javaOnly, "java", "Libs", 17, 1)
write.csv(wfSum,file='../2021_01/java_Libs.csv')

jsOnly <- full[full[4]=='JavaScript',]
names(jsOnly)[5] <- 'JsKnownFrontend'
wfSum <- knownFrameworksColumn(jsOnly,"js","JsKnownFrontend", 5, 1)

x <- knownFrameworksColumn(jsOnly,'js','JsKnownFrontend', 5, 1)
write.csv(x,"../2021_01/js_KnownFrontend.csv")

names(jsOnly)[6]  <- 'JsFreeFrontend'
x <- frameworkColumn(jsOnly, "js", "JsFreeFrontend", 6, 1)
write.csv(x,"../2021_01/js_FreeFrontend.csv")

names(jsOnly)[7] <- 'JsKnownBackend'
x <- knownFrameworksColumn(jsOnly,"js","JsKnownBackend", 7, 1)
write.csv(x,"../2021_01/js_KnownBackend.csv")

names(jsOnly)[8]  <- 'JsFreeBackend'
x <- frameworkColumn(jsOnly, "js", "JsFreeBackend", 8, 1)
write.csv(x,"../2021_01/js_FreeBackend.csv")

names(jsOnly)[9] <- 'JsKnownMobile'
x <- knownFrameworksColumn(jsOnly,"js","JsKnownMobile", 9, 1)
write.csv(x,"../2021_01/js_KnownMobile.csv")

names(jsOnly)[10]  <- 'JsFreeMobile'
x <- frameworkColumn(jsOnly, "js", "JsFreeMobile", 10, 1)
write.csv(x,"../2021_01/js_FreeMobile.csv")

names(jsOnly)[11]  <- 'JsFreeOther'
x <- frameworkColumn(jsOnly, "js", "JsFreeOther", 11, 1)
write.csv(x,"../2021_01/js_FreeOther.csv")

names(jsOnly)[12]  <- 'JsIDE'
x <- frameworkColumn(jsOnly, "js", "JsIDE", 12, 1)
write.csv(x,"../2021_01/js_IDE.csv")

names(full)[20] <- 'FreeLibs'
names(full)[39] <- "Area"
names(full)[4] <- "NowLanguage"

# x <- languageColumnSummary(as.factor(filter( full, Area == 'Мобільна розробка' )[,4]),10,2)
x <- summary(as.factor(filter( full, Area == 'Мобільна розробка' & NowLanguage != '' )[,4]),9)
x <- x/sum(x)
write.csv(x,"../2021_01/lang_mobile.csv")

png("mobile-lang-pie.png", width=800, height=500)
pie(x)
dev.off()

png("mobile-lang-bar.png", width=800, height=500)
barplot(x, las=2)
dev.off()


areaLanguagePie <- function(data,title) {
}

x <- summary(as.factor(filter( full, Area == 'Бекенд програмування' & NowLanguage != '' )[,4]),20)
x <- x/sum(x)
write.csv(x,"../2021_01/lang_backend.csv")

png("backend-lang-bar.png", width=800, height=500)
barplot(x, las=2)
dev.off()

x <- summary(as.factor(filter( full, Area == 'Веб-фронтенд' & NowLanguage != '' )[,4]),10)
x <- x/sum(x)
write.csv(x,"../2021_01/lang_frontend.csv")

png("frontend-lang-bar.png", width=800, height=500)
barplot(x, las=2)
dev.off()

x <- summary(as.factor(filter( full, Area == 'Веб-фронтенд' & NowLanguage != '' )[,4]),3)
x <- x/sum(x)
write.csv(x,"../2021_01/lang_frontend3.csv")

y <-  summary(as.factor(unlist(lapply(
        filter( full, Area == 'Веб-фронтенд' & NowLanguage == '' )[[32]],
        function(w) { unlist(str_split(w,';')) }
      ))))


x <- summary(as.factor(filter( full, Area == 'Обробка масивів даних' & NowLanguage != '' )[,4]),14)
x <- x/sum(x)
write.csv(x,"../2021_01/lang_data.csv")

png("data-lang-bar.png", width=800, height=500)
barplot(x, las=2)
dev.off()

x <- summary(as.factor(filter( full, Area == 'Десктоп-розробка' & NowLanguage != '' )[,4]),14)
x <- x/sum(x)
write.csv(x,"../2021_01/lang_desktop.csv")

x <- summary(as.factor(filter( full, Area == 'Системне програмування' & NowLanguage != '' )[,4]),12)
x <- x/sum(x)
write.csv(x,"../2021_01/lang_system.csv")
barplot(x,las=2)

x <- summary(as.factor(filter( full, Area == 'GameDev' & NowLanguage != '' )[,4]),10)
x <- x/sum(x)
write.csv(x,"../2021_01/lang_gamedev.csv")
barplot(x,las=2)


areas <- summary(as.factor(filter(full,Area!="")[,'Area']), 13)
write.csv(areas,"../2021_01/areas.csv")

png("areas-pie.png", width=800, height=500)
pie(areas)
dev.off()


x <- summary(as.factor(filter( full, Area == 'QA' & NowLanguage != '' )[,4]),10)
x <- x[order(x,decreasing = TRUE)]
x <- x/sum(x)
write.csv(x,"../2021_01/lang_qa_automation.csv")
barplot(x,las=2)

x <- summary(as.factor(filter( full, Area == 'Full Stack' & NowLanguage != '' )[,4]),10)
x <- x[order(x,decreasing = TRUE)]
x <- x/sum(x)
write.csv(x,"../2021_01/lang_fullstack.csv")
barplot(x,las=2)

x <- summary(as.factor(filter( full, Area == 'IoT' & NowLanguage != '' )[,4]),10)
x <- x[order(x,decreasing = TRUE)]
x <- x/sum(x)
write.csv(x,"../2021_01/lang_iot.csv")
barplot(x,las=2)


csOnly <- full[full[4]=='C#',]
x <- frameworkColumn(csOnly, "cs", "FreeLibs", 20, 3)
write.csv(x,"../2021_01/cs_libs.csv")

scalaOnly <- full[full[4]=='Scala',]
x <- frameworkColumn(scalaOnly, "scala", "FreeLibs", 20, 1)
write.csv(x,"../2021_01/scala_libs.csv")

pyOnly <- full[full[4]=='Python',]
names(pyOnly)[22] <- 'PyKnownWeb'
#x <- frameworkColumn(pyOnly, "py", "FreeLibs", 20, 3)
x <- knownFrameworksColumn(pyOnly,"py","PyKnownWeb", 22, 1)
write.csv(x,"../2021_01/py_KnownWeb.csv")

names(pyOnly)[23] <- 'PyFreeLibsWeb'
x <- frameworkColumn(pyOnly, "py", "PyFreeLibsWeb", 23, 2)
write.csv(x,"../2021_01/py_FreeLibsWeb.csv")

names(pyOnly)[24] <- 'PyKnownData'
#x <- frameworkColumn(pyOnly, "py", "FreeLibs", 20, 3)
x <- knownFrameworksColumn(pyOnly,"py","PyKnownData", 24, 1)
write.csv(x,"../2021_01/py_KnownData.csv")

names(pyOnly)[25] <- 'mypy'
x <- summary(as.factor(filter(pyOnly, mypy != '')[,25]))
x <- x/sum(x)
write.csv(x,"../2021_01/py_mypy.csv")


names(pyOnly)[26] <- 'pyOther'
x <- frameworkColumn(pyOnly, "py", "PyFreeLibs", 26, 2)
write.csv(x,"../2021_01/py_FreeLibs.csv")

names(pyOnly)[27] <- 'PyIDE'

phpOnly <- full[full[4]=='PHP',]
names(phpOnly)[28] <- 'PhpKnownFrameworks'
x <- knownFrameworksColumn(phpOnly,"php","PhpKnownFrameworks", 28, 1)
write.csv(x,"../2021_01/php_KnownFrameworks.csv")

names(phpOnly)[29] <- 'PhpFreeLibs'
x <- frameworkColumn(phpOnly, "php", "PhpFreeLibs", 29, 2)
write.csv(x,"../2021_01/php_FreeLibs.csv")

cppOnly <- full[full[4]=='C++',]
x <- frameworkColumn(cppOnly, "cpp", "FreeLibs", 20, 2)
write.csv(x,"../2021_01/cpp_FreeLibs.csv")

swiftOnly <- full[full[4]=='Swift',]
x <- frameworkColumn(swiftOnly, "swift", "FreeLibs", 20, 2)
write.csv(x,"../2021_01/swift_FreeLibs.csv")

rubyOnly <- full[full[4]=='Ruby',]
x <- frameworkColumn(rubyOnly, "Ruby", "FreeLibs", 20, 2)
write.csv(x,"../2021_01/ruby_FreeLibs.csv")

kotlinOnly <- full[full[4]=='Kotlin',]
x <- frameworkColumn(kotlinOnly, "Kotlin", "FreeLibs", 20, 2)

goOnly <- full[full[4]=='Go',]
x <- frameworkColumn(goOnly, "Go", "FreeLibs", 20, 2)

cOnly <- full[full[4]=='C',]
x <- frameworkColumn(cOnly, "C", "FreeLibs", 20, 2)






























