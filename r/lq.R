
source("LanguageQuestionnare.R")
source("LanguageQuestionnare_2010.R")
source("LanguageQuestionnare_2011.R")
source("LanguageQuestionnare_from2012.R")
source("LanguageQuestionnare_from2015.R")
source("SetOfLanguageQuestionnaries.R")

if (!exists("data.readed") || is.null(data.readed)) {
  d2010_12 <- new("LanguageQuestionnare_2010", when=as.Date("2010-12-01"),
                        data = read.csv("../2010_12/questionnaire1.csv", stringsAsFactor = FALSE))
  d2011_07 <- new("LanguageQuestionnare_2011",when=as.Date("2011-07-01"),
                        data = read.csv("../2011_07/questionnaire2.csv", stringsAsFactor = FALSE))
  d2012_05 <- new("LanguageQuestionnare_from2012",when=as.Date("2012-05-01"), 
                        data=read.csv("../2012_05/questionnaire3.csv", stringsAsFactor = FALSE))
  d2013_01 <- new("LanguageQuestionnare_from2012",when=as.Date("2013-01-01"), 
                        data=read.csv("../2013_01/questionnaire4.csv", stringsAsFactor = FALSE))
  d2014_01 <- new("LanguageQuestionnare_from2012",when=as.Date("2014-01-01"), 
                        data=read.csv("../2014_01/questionnaire5.csv", stringsAsFactor = FALSE))
  d2015_01 <- new("LanguageQuestionnare_from2015",when=as.Date("2015-01-01"), 
                        data=read.csv("../2015_01/questionnaire6.csv", stringsAsFactor = FALSE))
  data.readed <- TRUE
}


sq <- new("SetOfLanguageQuestionnaries",
            questionaries = list(
              "2010-12" = d2010_12,
              "2011-07" = d2011_07,
              "2012-05" = d2012_05,
              "2013-01" = d2013_01,
              "2014-01" = d2014_01,
              "2015-01" = d2015_01
            )
          )

png("firstlanguage.png", width=680, height=320)
x <- languageColumnSummaries(sq,"FirstLanguage",top=12,toPlot=TRUE, 
                              plot.col=rainbow(5, start=0.2, end=0.6),
                              plot.title='На каком языке вы написали свою первую программу ?',
                              las=2
                            )
dev.off()


png("firstlanguage.png", width=680, height=320)
x <- languageColumnSummaries(sq,"FirstLanguage",top=12,toPlot=TRUE, 
                              plot.col=rainbow(6, start=0.2, end=0.6),
                              plot.title="На каком языке вы написали свою первую программу ?",
                              las=2
                            )
dev.off()


png("nowlanguage.png", width=680, height=320)
x <- languageColumnSummaries(sq,"NowLanguage",top=21,toPlot=TRUE, 
                             when=c("2015-01"), las=2, plot.col=c("blue"),
                             plot.title="На каком языке вы пишете для работы сейчас",
                             )
dev.off()


png("nowlanguage1.png", width=680, height=360)
x <- languageColumnSummaries(sq,"NowLanguage",
                             when=c("2011-07","2012-05","2013-01","2014-01","2015-01"),
                             top=15,toPlot=TRUE, 
                             plot.col=rainbow(5,start=0.2,end=0.8),
                             plot.title="На каком языке вы пишете для работы сейчас",
                             las=2
                            )
dev.off()

#significantChanges(sq,"NowLanguage","2012-05","2013-01")

#significantChanges(sq,"NowLanguage","2011-07","2013-01")

png("nextlanguage2.png", width=680, height=320)
x <- languageColumnSummaries(sq,"NextLanguage",top=16,toPlot=TRUE, 
                             when=c("2011-07","2012-05","2013-01","2014-01","2015-01"),
                             plot.col=rainbow(5,start=0.2,end=0.6),
                             plot.title="Если бы вы начинали сейчас коммерческий проект \n и у вас была бы свобода выбора",
                             las=2
                            )
dev.off()

x <- satisfactionIndex(getQuestionnaire(sq,"2015-01"), barrier=10)
cr <- colorRampPalette(c('black','blue'))(length(x))

png("satisfaction.png")
dotchart(x[order(x)],col=cr)
dev.off()

png("additionallanguageNow.png", width=680, height=320)
x <- languageColumnSummaries(sq,"AdditionalLanguages",top=20,toPlot=TRUE,
                             when=c("2015-01"),
                             plot.col=c("blue"),
                             plot.title="Какие языки вы используете как дополнительные",
                             las=2
                            )
dev.off()


png("additionallanguage.png", width=680, height=320)
x <- languageColumnSummaries(sq,"AdditionalLanguages",top=20,toPlot=TRUE, 
                             when=c("2011-07","2012-05","2013-01","2014-01","2015-01"),
                             plot.col=rainbow(5,start=0.2,end=0.6),
                             plot.title="Какие языки вы используете как дополнительные",
                             las=2
                            )
dev.off()

png("petporjectslanguage.png", width=680, height=320)
x <- languageColumnSummaries(sq,"PetProjectsLanguages",top=20,toPlot=TRUE, 
                             when=c("2011-07","2012-05","2013-01","2014-01","2015-01"),
                             plot.col=rainbow(5,start=0.2,end=0.6),
                             plot.title="Какие языки вы используете для своих pet-проектов",
                             las=2
                            )
dev.off()


#png("age.png", width=400, height=320)
#ageChart(sq,c("2012-05","2013-01","2014-01"),toPlot=TRUE)
#dev.off()


#q1 <- getQuestionnaire(sq,"2010-12")
#q2 <- getQuestionnaire(sq,"2011-07")
#q3 <- getQuestionnaire(sq,"2012-05")
#q4 <- getQuestionnaire(sq,"2013-01")
#q5 <- getQuestionnaire(sq,"2014-01")
q6 <- getQuestionnaire(sq,"2015-01")


png("experienceInProgramming.png", width=680, height=320)
d <- experienceChart(sq,"ExperienceInProgramming",when=c("2010-12","2011-07","2012-05","2013-01","2014-01","2015-01"))
# в 2011 мы смешади 
# в 2011 мы смешали -1 и 1, приведем сие к общемк знаменателю.
d[,"1"] <- d[,"<1"]+d[,"1"]
d <- d[,c("1","2","3","4","5","6","7","8","9","10+")]
barplot(d, beside=TRUE,col=rainbow(6, start=0.1, end=0.6), 
        legend=rownames(d), args.legend=list(x=60),
        main="Опыт работы программистом")
dev.off()
                      
png("experienceInProgrammingByLanguage.png", width=680, height=320)
t <- table(q6@data$NowLanguage, q6@data$ExperienceInProgramming)
t1 <- as.table(t[c("Java","C#","PHP","JavaScript","C++","Python","Ruby","C"),])
plot(t1, main="Соотношение между языком и опытом работы")
dev.off()


en <- c("< 1", "1","2","3","4","5","6","7","8","9","10+")
t<-table(q6@data$ExperienceInLanguage,q6@data$ExperienceInProgramming)
  png(file="el.png")
  barplot(t,col=rainbow(11),legend=TRUE,args.legend=list(x=11,y=500))
  title("Опыт работы программистом/на выбранном языке")
  dev.off()

png("experiencesMosaic.png", width=680, height=320)
t<-table(q6@data$ExperienceInProgramming,q6@data$ExperienceInLanguage)
t1 <- t[,c("10+","9","8","7","6","5","4","3","2","1","<1")]
colnames(t1) <- c("10+","","","","","","","","","","<1")
plot(as.table(t1), col=colorRampPalette(c("blue","green"))(11), xlab="программистом", ylab="на выбранном языке", main="Опыт работы",las=1)
dev.off()


t <- table(q6@data$NowLanguage,q6@data$InUA)
t <- apply(t,2,function(x) { x/sum(x) })
t <- t[c("Java","C#","PHP", "JavaScript", "Python", "C++", "Ruby", "Objective-C","C","PL-SQL"),c("Да","Нет")]
png("languagesNowInUA.png", width=680, height=320)
 barplot(t,beside=TRUE, col=rainbow(10),axes=FALSE, 
         names=c("в Украине", "не в Украине"), legend=rownames(t), 
         args.legen=list(y=0.25))
dev.off()

t <- table(q6@data$InUA,q6@data$ExperienceInProgramming)[c("Да","Нет"),]
t <- apply(t,1, function(x) { 100*x/sum(x) })
png("experienceInUA.png", width=680, height=320)
barplot(t,beside=TRUE, axes=TRUE,
         col=colorRampPalette(c("green","blue"))(48),
         names=c("в Украине", "не в Украине"),
         legend=rownames(t)
       )
dev.off()


t <- table(q6@data$InUA,q6@data$Age)[c("Да","Нет"),]
t <- apply(t,1, function(x) { x/sum(x) })
png("ageInUA.png", width=680, height=320)
barplot(t,beside=TRUE, axes=FALSE, 
         col=colorRampPalette(c("green","blue"))(48),
         names=c("в Украине", "не в Украине"),
         legend=rownames(q6@data$Age)
       )
dev.off()

ln <- languageColumnSummary(q6@data$NowLanguage,top=22,barrier=5)
x <- subset(q6@data,q6@data$NowLanguage %in% names(ln))
xm <- sapply(names(ln),function(n) as.integer(summary(q6@data$Age[q6@data$NowLanguage==n])['Median']) )
x$NowLanguage <- factor(x$NowLanguage, levels=names(xm[order(xm)]))
png("ageAll.png", width=680, height=320)
par(cex.axis=0.8)
boxplot(Age ~ NowLanguage, data=x, las=2, outline=FALSE)
title('Возраст разработчиков в зависимости от языка');
par(cex.axis=1)
dev.off()


ln <- languageColumnSummary(q6@data$FirstLanguage,top=20,barrier=5)
x <- subset(q6@data,q6@data$FirstLanguage %in% names(ln))
xm <- sapply(names(ln),function(n) as.integer(summary(q6@data$Age[q6@data$FirstLanguage==n])['Median']) )
x$FirstLanguage <- factor(x$FirstLanguage, levels=names(xm[order(xm)]))
png("ageFirstLanguage.png", width=680, height=320)
par(cex.axis=0.8)
boxplot(Age ~ FirstLanguage, data=x, las=2, outline=FALSE)
title('Возраст разработчиков в зависимости от первого языка');
par(cex.axis=1)
dev.off()
