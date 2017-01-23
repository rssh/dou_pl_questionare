
source("LanguageQuestionnare.R")
source("LanguageQuestionnare_2010.R")
source("LanguageQuestionnare_2011.R")
source("LanguageQuestionnare_from2012.R")
source("LanguageQuestionnare_from2015.R")
source("LanguageQuestionnare_from2016.R")
source("LanguageQuestionnare_from2017.R")
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
              "2017-01" = d2017_01
            )
          )

cat("FIRST LANGUAGE graph1\n")

svg("firstlanguage.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"FirstLanguage",top=12,toPlot=TRUE, 
                              when=c("2017-01"),
                              plot.col=rainbow(7, start=0.2, end=0.7),
                              plot.title="На каком языке вы написали свою первую программу ?",
                              las=2
                            )
dev.off()


cat("FIRST LANGUAGE graph2\n")

svg("firstlanguageHist.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"FirstLanguage",top=12,toPlot=TRUE, 
                             when=c("2012-05","2013-01","2014-01","2015-01","2016-01",
                                    "2017-01"),
                              plot.col=rainbow(6, start=0.2, end=0.9),
                              plot.title="На каком языке вы написали свою первую программу ?",
                              las=2
                            )
dev.off()

cat("NOW LANGUAGE graph\n")

svg("nowlanguage.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"NowLanguage",top=21,toPlot=TRUE, 
                             when=c("2017-01"), las=2, plot.col=c("blue"),
                             plot.title="На каком языке вы пишете для работы сейчас",
                             )
dev.off()

cat("NOW LANGUAGE graph1\n")

svg("nowlanguageInHistory.svg", width=680, height=360)
x <- languageColumnSummaries(sq,"NowLanguage",
                             when=c("2011-07","2012-05","2013-01","2014-01","2015-01","2016-01","2017-01"),
                             top=16,toPlot=TRUE, 
                             plot.col=rainbow(7,start=0.2,end=0.8),
                             plot.title="На каком языке вы пишете для работы сейчас",
                             las=2
)
dev.off()

#significantChanges(sq,"NowLanguage","2012-05","2013-01")

#significantChanges(sq,"NowLanguage","2011-07","2013-01")

cat("NEXT LANGUAGE \n")

svg("nextlanguage.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"NextLanguage",top=16,toPlot=TRUE, 
                             when=c("2012-05","2013-01","2014-01","2015-01","2016-01","2017-01"),
                             plot.col=rainbow(6,start=0.2,end=0.8),
                             plot.title="Если бы вы начинали сейчас коммерческий проект \n и у вас была бы свобода выбора",
                             las=2
                            )
dev.off()

cat("SATISFACTION \n")

svg("satisfaction.svg")
 x <- satisfactionIndex(getQuestionnaire(sq,"2017-01"), barrier=10)
 cr <- colorRampPalette(c('black','blue'))(length(x))
 dotchart(x[order(x)],col=cr)
dev.off()

cat("LEARN \n")

png("learnInNextYearPie.png", width=500, height=200)
 pie(table(d2017_01@data$Learn),main="Планируете ли вы в течении года изучить какой-то язык программирования?")
dev.off()

svg("learnlanguageNow.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"LearnLanguage",top=20,toPlot=TRUE,
                             when=c("2017-01"),
                             plot.col=c("blue"),
                             plot.title="Какие языки вы собираетесь изучать в следущем году ?",
                             las=2
                            )
dev.off()



svg("learnlanguagePie.svg", width=6.8, height=3.2)
x <- languageColumnPieChart(sq,"2017-01","LearnLanguage",title="Какие языки вы собираетесь изучать в следующем году ?",barrier=0.02,toPlot=TRUE)
dev.off()

cat("ADDITIONAL \n")

## png("additionallanguageNow.svg", width=680, height=320)
svg("additionallanguageNow.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"AdditionalLanguages",top=20,toPlot=TRUE,
                             when=c("2017-01"),
                             plot.col=c("blue"),
                             plot.title="Какие языки вы используете как дополнительные",
                             las=2
                            )
dev.off()


svg("additionallanguage.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"AdditionalLanguages",top=20,toPlot=TRUE, 
                             when=c("2011-07","2012-05","2013-01","2014-01","2015-01","2016-01","2017-01"),
                             plot.col=rainbow(7,start=0.2,end=0.8),
                             plot.title="Какие языки вы используете как дополнительные",
                             las=2
                            )
dev.off()

cat("PET(NOW) \n")

png("petporjectslanguageNow.png", width=680, height=320)
x <- languageColumnSummaries(sq,"PetProjectsLanguages",top=20,toPlot=TRUE,
                             when=c("2017-01"),
                             plot.col=c("blue"),
                             plot.title="Какие языки вы используете в своих проектах",
                             las=2
)
dev.off()

cat("PET\n")

##png("petporjectslanguage.png", width=680, height=320)
svg("petporjectslanguage.svg", width=6.8, height=3.2)
x <- languageColumnSummaries(sq,"PetProjectsLanguages",top=20,toPlot=TRUE,
                             when=c("2011-07","2012-05","2013-01","2014-01","2015-01","2016-01","2017-01"),
                             plot.col=rainbow(7,start=0.2,end=0.8),
                             plot.title="Какие языки вы используете в своих проектах",
                             las=2
)
dev.off()


#png("age.png", width=400, height=320)
#ageChart(sq,c("2012-05","2013-01","2014-01"),toPlot=TRUE)
#dev.off()


q1 <- getQuestionnaire(sq,"2010-12")
q2 <- getQuestionnaire(sq,"2011-07")
q3 <- getQuestionnaire(sq,"2012-05")
q4 <- getQuestionnaire(sq,"2013-01")
q5 <- getQuestionnaire(sq,"2014-01")
q6 <- getQuestionnaire(sq,"2015-01")
q7 <- getQuestionnaire(sq,"2016-01")
q8 <- getQuestionnaire(sq,"2017-01")


q <- q8

cat("EXP\n")

svg("experienceInProgramming.svg", width=6.8, height=3.4)
d <- experienceChart(sq,"ExperienceInProgramming",when=c("2010-12","2011-07","2012-05","2013-01","2014-01","2015-01","2016-01","2017-01"))
# в 2011 мы смешали -1 и 1, приведем сие к общемк знаменателю.
d[,"1"] <- d[,"<1"]+d[,"1"]
d <- d[,c("1","2","3","4","5","6","7","8","9","10+")]
barplot(d, beside=TRUE,col=rainbow(8, start=0.1, end=0.8), 
        legend=rownames(d), args.legend=list(x=60),
        main="Опыт работы программистом")
dev.off()
                      
#png("experienceInProgrammingByLanguage.png", width=680, height=320)
#t <- table(q@data$NowLanguage, q@data$ExperienceInProgramming)
#t1 <- as.table(t[c("Java","C#","PHP","JavaScript","C++","Python","Ruby","C"),])
#plot(t1, main="Соотношение между языком и опытом работы")
#dev.off()


en <- c("< 1", "1","2","3","4","5","6","7","8","9","10+")
t<-table(q@data$ExperienceInLanguage,q@data$ExperienceInProgramming)
  png(file="el.png")
  barplot(t,col=rainbow(11),legend=TRUE,args.legend=list(x=11,y=500))
  title("Опыт работы программистом/на выбранном языке")
  dev.off()

svg("experiencesMosaic.svg", width=6.8, height=3.2)
t<-table(q@data$ExperienceInProgramming,q@data$ExperienceInLanguage)
t1 <- t[,c("10+","9","8","7","6","5","4","3","2","1","<1")]
colnames(t1) <- c("10+","","","","","","","","","","<1")
plot(as.table(t1), col=colorRampPalette(c("blue","green"))(11), xlab="программистом", ylab="на выбранном языке", main="Опыт работы",las=1)
dev.off()

png("ageDistribution.png", width=680, height=320)
a <- summary(na.omit(as.factor(q@data$Age)))
a <- a/sum(a)
barplot(a)
title("Распределение возраста")
dev.off()

t <- table(q@data$NowLanguage,q@data$InUA)
t <- apply(t,2,function(x) { x/sum(x) })
t <- t[c("Java","C#","JavaScript","PHP", "Python", "C++", "Ruby", "Objective-C","Swift","C","Scala","Go"),c("Да","Нет")]
svg("languagesNowInUA.svg", width=6.8, height=3.2)
 barplot(t,beside=TRUE, col=rainbow(12, start=0, end=0.8),axes=FALSE, 
         names=c("в Украине", "не в Украине"), legend=rownames(t), 
         args.legen=list(y=0.3))
dev.off()

t <- table(q@data$InUA,q@data$ExperienceInProgramming)[c("Да","Нет"),]
t <- apply(t,1, function(x) { 100*x/sum(x) })
png("experienceInUA.png", width=680, height=320)
barplot(t,beside=TRUE, axes=TRUE,
         col=colorRampPalette(c("green","blue"))(48),
         names=c("в Украине", "не в Украине"),
         legend=rownames(t)
       )
dev.off()


t <- table(q@data$InUA,q@data$Age)[c("Да","Нет"),]
t <- apply(t,1, function(x) { x/sum(x) })
svg("ageInUA.svg", width=6.8, height=3.2)
barplot(t,beside=TRUE, axes=FALSE, 
         col=colorRampPalette(c("green","blue"))(48),
         names=c("в Украине", "не в Украине"),
         legend=rownames(q6@data$Age)
       )
dev.off()

ln <- languageColumnSummary(q@data$NowLanguage,top=22,barrier=5)
x <- subset(q@data,q@data$NowLanguage %in% names(ln))
xm <- sapply(names(ln),function(n) as.integer(summary(q@data$Age[q@data$NowLanguage==n])['Median']) )
x$NowLanguage <- factor(x$NowLanguage, levels=names(xm[order(xm)]))
svg("ageAll.svg", width=6.8, height=3.2)
par(cex.axis=0.8)
boxplot(Age ~ NowLanguage, data=x, las=2, outline=FALSE)
title('Возраст разработчиков в зависимости от языка');
par(cex.axis=1)
dev.off()

svg("experienceInProgrammingByLanguage.svg", width=6.8, height=3.2)
par(cex.axis=0.8)
boxplot(as.integer(ExperienceInProgramming)-1 ~ NowLanguage, data=x, las=2, outline=FALSE)
title("Опыт разработчика в зависимости от языка")
par(cex.axis=1)
dev.off()


ln <- languageColumnSummary(q@data$FirstLanguage,top=20,barrier=5)
x <- subset(q@data,q@data$FirstLanguage %in% names(ln))
xm <- sapply(names(ln),function(n) as.integer(summary(q@data$Age[q@data$FirstLanguage==n])['Median']) )
x$FirstLanguage <- factor(x$FirstLanguage, levels=names(xm[order(xm)]))
png("ageFirstLanguage.png", width=680, height=320)
par(cex.axis=0.8)
boxplot(Age ~ FirstLanguage, data=x, las=2, outline=FALSE)
title('Возраст разработчиков в зависимости от первого языка');
par(cex.axis=1)
dev.off()


