

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
                                                 ...) { standardGerneric("languageColumnSummaries") }  
          )
                                                 

setMethod(f="languageColumnSummaries",
          definition=function(object,columnName, top, barrier, when, main, toPlot, plot.col, ... ) {
             if (is.null(when)) {
                 when <- names(object@questionaries)
             }
             if (is.null(main)) {
                 main <- when[length(when)]
             }
             data <- sapply(when,function(x) { 
                        q <- getQuestionnaire(object,x)
                        languageColumn(q,columnName,barrier=barrier)
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
                  # cat("skipped names :",diffNames,"\n")
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
   pv[n] <- prop.test(c(l1[n],l2[n]),c(nl1,nl2))$p.value
 }
 pv <- pv[as.numeric(pv)<1-p & !is.na(as.numeric(pv))]
 print(pv)
 pv
} )

setGeneric("experienceChart", function(object, name, when=c("2012-05","2013-01"), toPlot=FALSE, ...) { standardGeneric("experienceChart") } )

setMethod(f="experienceChart",
          definition=function(object,name, when, toPlot, ... ) {
             d <- sapply(when,function(x) { 
                        q <- getQuestionnaire(object,x)
                        summary(q@data[[name]])
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