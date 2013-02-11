

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
                                                 ...) { standardGerneric("languageColumnSummaries") }  
          )
                                                 

setMethod(f="languageColumnSummaries",
          definition=function(object,columnName, top, barrier, when, main, toPlot, ... ) {
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
             cat("main=",main,"\n")
             cat("data=") 
             print(data)
             if (length(when) > 1) {
               mainOrder <- data[[main]][commonNames]
               commonNames <- commonNames[order(mainOrder,decreasing=TRUE)]
               data <- lapply(data, function(data) { data[commonNames]/sum(data[commonNames]) })
               data <- t(rbind(sapply(names(data),function(n){ data[[n]] } )))
             } else {
               data <- t(data/sum(data))
             }
             print(data)
             if (length(commonNames) > top) {
               commonNames <- commonNames[1:top]
               data <- data[,commonNames]
             }
             if (toPlot) {
               barplot(data,beside=TRUE,cex.axis=0.8, cex=0.8, ...)
               legend("topright",rownames(data))    # TOD
               #title("AAA")
               #dev.off()
             }
             data
          }
         )

setGeneric("getQuestionnaire", function(object, name) { standardGeneric("getQuestionnaire") } )

setMethod(f="getQuestionnaire", definition = function(object, name) { object@questionaries[[name]] } )

