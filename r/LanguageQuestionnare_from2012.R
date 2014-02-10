

setClass("LanguageQuestionnare_from2012", 
         contains="LanguageQuestionnare"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_from2012",
          definition=function(.Object, when, data) {
            cat("call of from2012_initialize")
            .Object <- callNextMethod(.Object, when, data)
            .Object@additionalFields["AdditionalLanguagesById"] <- normalizeLanguagesColumn(.Object,"AdditionalLanguages1")
            .Object@data$Age <- factor(data$Age, levels=c("<20","[20,30)","[30,40)","[40,50)",">50"))
           .Object@data$ExperienceInProgramming <- factor(data$ExperienceInProgramming, levels=c("<1","1","2","3","4","5","6","7","8","9","10+"))
           .Object@data$ExperienceInLanguage <- factor(data$ExperienceInLanguage, levels=c("<1","1","2","3","4","5","6","7","8","9","10+"))
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


