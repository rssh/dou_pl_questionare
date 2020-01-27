

#
# Set of language questionaries: encapsulate few questionaries, which can be loaded at once for
# showing data from few sequential questionaries on common graphic.
#

setClass("SetOfLanguageQuestionnaries",
         representation(
           # list of questionaries.
           questionaries="list"
         )
        )


setGeneric("languageColumnSummaries", function(object, columnName, top=100, barrier=2, 
                                                 when=NULL, main=NULL, toPlot=FALSE,
                                                 plot.col = NULL, plot.title=NULL, 
                                                 filter = NULL,
                                                 ...) { standardGerneric("languageColumnSummaries") }  
          )
                                                 

setMethod(f="languageColumnSummaries",
          definition=function(object,columnName, top, barrier, when, main, toPlot, plot.col, filter, ... ) {
             if (is.null(when)) {
                 when <- names(object@questionaries)
             }
             if (is.null(main)) {
                 main <- when[length(when)]
             }
             if (is.null(filter)) {
                 filter <- function(obj) { obj@data }
             }
             data <- sapply(when,function(x) { 
                        q <- getQuestionnaire(object,x)
                        languageColumn(q,columnName,barrier=barrier,filter=filter)
                     })
             commonNames <- NULL
             allNames <- NULL
             for(l in data) {
               nl <- names(l)
               if (is.null(commonNames)) {
                  commonNames <- nl
               } else {
                  commonNames <- intersect(commonNames,nl)
                  diffNames <- nl[!(nl %in% commonNames)]
                  allNames <- union(allNames,nl)
                  cat("skipped names :",diffNames,"\n")
               }
             }
             # now - set all diffNames to 0
             for(k in names(data)) {
                 newNames <- setdiff(allNames, names(data[[k]]))
                 data[[k]][newNames] <- 0
             }
             if (length(when) > 1) {
               mainOrder <- data[[main]][allNames]
               allNames <- allNames[order(mainOrder,decreasing=TRUE)]
               data <- lapply(data, function(data) { 
                          data[allNames]/sum(data[allNames]) 
                       })
               data <- t(rbind(sapply(names(data),function(n){ data[[n]] } )))
             } else {
               data <- t(data/sum(data))
               allNames <- colnames(data)
             }
             cat("allNames=",allNames,"\n");
             if (length(allNames) > top) {
               allNames <- allNames[1:top]
               data <- data[,allNames]
             }
             if (toPlot) {
               barplot(data,beside=TRUE,cex.axis=0.8, cex=0.8, col=plot.col, ...)
               if (!is.null(rownames(data))) {
                 legend("topright",rownames(data), fill=plot.col)    # TOD
               }
               if (!is.null(plot.title)) {
                   title(plot.title)
               }
             }
             data
          }
         )

setGeneric("getQuestionnaire", function(object, name) { standardGeneric("getQuestionnaire") } )

setMethod(f="getQuestionnaire", definition = function(object, name) { object@questionaries[[name]] } )

#
# check - what changes between summaries of characteristics are statistically significant.
#
#// изменения статистически значимы, если результаты данного опроса и предыдущего не могут быть
#// разными группами в одной гауссовской популяции c обычным доверительным интервалом (0.95%).
#
setGeneric("significantChanges", function(object, columnName, 
                                          q1, q2,
                                          p=0.95 ) {
                                             standardGeneric("significantChanges")
                                 })


setMethod(f="significantChanges", definition = function(object, columnName,
                                                        q1, q2,
                                                        p = 0.95) { 
 x <- languageColumnSummaries(object, columnName, when=c(q1,q2), toPlot=FALSE, barrier=5)
 names <- colnames(x)
 l1 <- languageColumn(getQuestionnaire(sq,q1),columnName, barrier=5)
 l2 <- languageColumn(getQuestionnaire(sq,q2),columnName, barrier=5)
 nl1 <- sum(l1)
 nl2 <- sum(l2)
 pv <- cbind(names)
 for(n in names) {
   v1 <- if (is.na(l1[n])) 0 else l1[n]
   v2 <- if (is.na(l2[n])) 0 else l2[n]
   pv[n] <- prop.test(c(v1,v2),c(nl1,nl2))$p.value
 }
 pv <- pv[as.numeric(pv)<1-p & !is.na(as.numeric(pv))]
 print(pv)
 pv
} )

setGeneric("experienceChart", function(object, name, when=c("2013-01","2014-01"), toPlot=FALSE, ...) { standardGeneric("experienceChart") } )

setMethod(f="experienceChart",
          definition=function(object,name, when, toPlot, ... ) {
             d <- sapply(when,function(x) { 
                        q <- getQuestionnaire(object,x)
                        summary(na.omit(q@data[[name]]))
                     })
             if (length(when) > 1) {
               d <- t(apply(d, 2, function(x) { x*100/sum(x) }))
             } else {
               d <- t(d*100/sum(d))
             }
             if (toPlot) {
               barplot(d,beside=TRUE,cex.axis=0.8, cex=0.8, ...)
               if (!is.null(rownames(d))) {
                 legend("topright",rownames(data), fill=plot.col)    # TOD
               }
               #if (!is.null(plot.title)) {
               #    title(plot.title)
               #}
             }
             d
          }
         )


setGeneric("finalTable", function(object) { standardGeneric("finalTable") } )

setMethod(f="finalTable", 
          signature="SetOfLanguageQuestionnaries",
          definition=function(object) {
            dates <- names(object@questionaries)
            if (length(dates) < 2) {
                stop("finalTable must be applied when we have at least two questionaries")
            }
            qLast <- getQuestionnaire(object,dates[length(dates)])
            qPrev <- getQuestionnaire(object,dates[length(dates)-1])
            sNowLast <- languageColumn(qLast,"NowLanguage")
            names <- names(sNowLast)
            sNowPrev <- languageColumn(qPrev,"NowLanguage")
            svNames <- names
            names <- union(names,names(sNowPrev))
            # removed sNextLast as meanless
            #sNextLast <- languageColumn(qLast,"NextLanguage")
            #names <- intersect(names,names(sNextLast))
            sAddLast <- languageColumn(qLast,"AdditionalLanguages")
            names <- intersect(names,names(sAddLast))
            sPetLast <- languageColumn(qLast,"PetProjectsLanguages")
            names <- intersect(names,names(sPetLast))
            satisfaction <- satisfactionIndex(qLast)
 
            sNowLast[setdiff(names,names(sNowLast))] <- 0
            sNowLast <- sNowLast[names]
            d <- setdiff(names,names(sNowPrev))
            sNowPrev[setdiff(names,names(sNowPrev))] <- 0
            sNowPrev <- sNowPrev[names]
            # sNextLast[setdiff(names,names(sNextLast))] <- 0
            # sNextLast <- sNextLast[names]
            sAddLast[setdiff(names,names(sAddLast))] <- 0
            sAddLast <- sAddLast[names]
            sPetLast[setdiff(names,names(sPetLast))] <- 0
            sPetLast <- sPetLast[names]
            satisfaction[setdiff(names,names(satisfaction))] <- 0
            satisfaction <- satisfaction[names]

	    percentNow <- sNowLast*100/sum(sNowLast)
            percentPrev <- sNowPrev*100/sum(sNowPrev)
            # percentNextNow <- sNextLast*100/sum(sNextLast)
           
            diff = percentNow - percentPrev
            
            r <- cbind(percentNow, diff, sNowLast, sAddLast, sPetLast, satisfaction)
            r
          })

setGeneric("ageChart", function(object, when, toPlot=FALSE, ...) { standardGeneric("ageChart") } )


setMethod(f="ageChart", 
          signature="SetOfLanguageQuestionnaries",
          definition=function(object, when, toPlot, ...) {
             a <- sapply(when,function(x) { summary(getQuestionnaire(object,x)@data$Age)  })
             if (length(when) > 1) {
                a <- apply(a,2, function(x) { x*100/sum(x) })
             } else {
                a <- a*100/sum(a)
             }
             if (toPlot) {
               barplot(a,col=rainbow(5), legend=rownames(a), xlim=c(0,length(when)+2))
             } 
             a
          }) 



languageColumnPie <- function(languageColumn, title, barrier = 0.01, toPlot=FALSE, noUnknown=FALSE)
{
  rx <- languageColumn/sum(languageColumn)
  rownames(rx)[rownames(rx)=='none']<-'unknown'
  rx1 <- rx[rx > barrier]
  other <- sum(rx[rx <= barrier])
  rx1['other'] <- other
  rx1 <- sort(rx1)
  if (noUnknown) {
    rx1 <- rx1[names(rx1)!='unknown']
  }
  percents = round(100*rx1/sum(rx1),1)
  palette=rainbow(start=0.1,end=1,length(rx1))
  pie(rx1,labels=percents,col=palette,main=title)
  legend("topright",legend=names(rx1),fill=palette)
  rx1
}

setGeneric("languageColumnPieChart", function(object, when, columnName, title, barrier=0.03, toPlot=FALSE, noUnknown=TRUE, ...) { standardGeneric("languageColumnPieChart") } )


setMethod(f="languageColumnPieChart", 
          signature="SetOfLanguageQuestionnaries",
          definition=function(object, when, columnName, title, barrier, toPlot, noUnknown, ...) {
              tl <- table(getQuestionnaire(object,when)@data[columnName])
              languageColumnPie(tl,title,barrier,toPlot, noUnknown)
          }) 

