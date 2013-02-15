
source("LanguageQuestionnare.R")
source("LanguageQuestionnare_from2012.R")
source("SetOfLanguageQuestionnaries.R")

if (!exists("data.readed") || is.null(data.readed)) {
  d2010_12 <- new("LanguageQuestionnare", when=as.Date("2010-12-01"),
                        data = read.csv("../2010_12/questionnaire1.csv"))
  d2011_07 <- new("LanguageQuestionnare",when=as.Date("2011-07-01"),
                        data = read.csv("../2011_07/questionnaire2.csv"))
  d2012_05 <- new("LanguageQuestionnare",when=as.Date("2012-05-01"), 
                        data=read.csv("../2012_05/questionnaire3.csv"))
  d2013_01 <- new("LanguageQuestionnare_from2012",when=as.Date("2013-01-01"), 
                        data=read.csv("questionnaire4.csv"))
  data.readed <- TRUE
}


sq <- new("SetOfLanguageQuestionnaries",
            questionaries = list(
              "2010-12" = d2010_12,
              "2011-07" = d2011_07,
              "2012-05" = d2012_05,
              "2013-01" = d2013_01
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

x <- satisfactionIndex(getQuestionnaire(sq,"2013-01"), barrier=10)
cr <- colorRampPalette(c('black','blue'))(length(x))

png("satisfaction.png")
dotchart(x[order(x)],col=cr)
dev.off()

