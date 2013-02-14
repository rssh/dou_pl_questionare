

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
             for(l in data) {
               nl <- names(l)
               if (is.null(commonNames)) {
                  commonNames <- nl
               } else {
                  commonNames <- intersect(commonNames,nl)
                  diffNames <- nl[!(nl %in% commonNames)]
                  cat("skipped names :",diffNames,"\n")
               }
             }
             if (length(when) > 1) {
               mainOrder <- data[[main]][commonNames]
               commonNames <- commonNames[order(mainOrder,decreasing=TRUE)]
               data <- lapply(data, function(data) { 
                          data[commonNames]/sum(data[commonNames]) })
               data <- t(rbind(sapply(names(data),function(n){ data[[n]] } )))
             } else {
               data <- t(data/sum(data))
               commonNames <- colnames(data)
             }
             cat("commonNames=",commonNames,"\n");
             if (length(commonNames) > top) {
               commonNames <- commonNames[1:top]
               data <- data[,commonNames]
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
