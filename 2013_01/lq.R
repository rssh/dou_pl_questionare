
source("LanguageQuestionnare.R")
source("SetOfLanguageQuestionnaries.R")

sq <- new("SetOfLanguageQuestionnaries",
            questionaries = list(
              "2010-12" = new("LanguageQuestionnare",when=as.Date("2010-12-01"), 
                                                             data=read.csv("../2010_12/questionnaire1.csv")),
              "2011-07" = new("LanguageQuestionnare",when=as.Date("2011-07-01"), 
                                                             data=read.csv("../2011_07/questionnaire2.csv")),
              "2012-05" = new("LanguageQuestionnare",when=as.Date("2012-05-01"), 
                                                             data=read.csv("../2012_05/questionnaire3.csv")),
              "2013-01" = new("LanguageQuestionnare",when=as.Date("2013-01-01"), 
                                                             data=read.csv("questionnaire4.csv"))
            )
          )

png("firstlanguage.png", width=680, height=320)
x <- languageColumnSummaries(sq,"FirstLanguage",top=12,toPlot=TRUE, 
                              plot.col=rainbow(4, start=0.2, end=0.6),
                              plot.title="На каком языке вы написали свою первую программу ?",
                              las=2
                            )
dev.off()


png("firstlanguage.png", width=680, height=320)
x <- languageColumnSummaries(sq,"FirstLanguage",top=12,toPlot=TRUE, 
                              plot.col=rainbow(4, start=0.2, end=0.6),
                              plot.title="На каком языке вы написали свою первую программу ?",
                              las=2
                            )
dev.off()


png("nowlanguage.png", width=680, height=320)
x <- languageColumnSummaries(sq,"NowLanguage",top=21,toPlot=TRUE, 
                             when=c("2013-01"), las=2, plot.col=c("blue"),
                             plot.title="На каком языке вы пишете для работы сейчас",
                             )
dev.off()


png("nowlanguage1.png", width=680, height=320)
x <- languageColumnSummaries(sq,"NowLanguage",
                             when=c("2011-07","2012-05","2013-01"),
                             top=15,toPlot=TRUE, 
                             plot.col=rainbow(3,start=0.3,end=0.6),
                             plot.title="На каком языке вы пишете для работы сейчас",
                             las=2
                            )
dev.off()

#significantChanges(sq,"NowLanguage","2012-05","2013-01")

#significantChanges(sq,"NowLanguage","2011-07","2013-01")

png("nextlanguage2.png", width=680, height=320)
x <- languageColumnSummaries(sq,"NextLanguage",top=15,toPlot=TRUE, 
                             when=c("2011-07","2012-05","2013-01"),
                             plot.col=rainbow(3,start=0.3,end=0.6),
                             plot.title="Если бы вы начинали сейчас коммерческий проект \n и у вас была бы свобода выбора",
                             las=2
                            )
dev.off()

x <- satisfactionIndex(getQuestionnaire(sq,"2013-01"), barrier=5)
cr <- colorRampPalette(c('black','blue'))(length(x))
