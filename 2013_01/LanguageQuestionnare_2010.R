

setClass("LanguageQuestionnare_2010", 
         contains="LanguageQuestionnare"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_2010",
          definition=function(.Object, when, data) {
            cat("call of 2010_initialize\n")
            .Object <- callNextMethod(.Object, when, data)
            .Object@data$ExperienceInProgramming <- factor(data$Experience, levels=c("0","1","2","3","4","5","6","7","8","9","10 и больше"))
            levels(.Object@data$ExperienceInProgramming) <- c("<1","1","2","3","4","5","6","7","8","9","10+")
            return(.Object)
          }
         )

setMethod("languageColumn",
          signature="LanguageQuestionnare_from2012",
           definition=function(object,columnName,top=100,barrier=0) {
             if (columnName == "AdditionalLanguages") {
                x <- as.factor(unlist(object@additionalFields$AdditionalLanguagesById))
                languageColumnSummary(x,top,barrier)
             } else {
                callNextMethod()
             }
           }
         )

