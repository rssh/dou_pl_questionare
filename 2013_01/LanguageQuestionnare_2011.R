

setClass("LanguageQuestionnare_2011", 
         contains="LanguageQuestionnare"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_2011",
          definition=function(.Object, when, data) {
            cat("call of 2011_initialize")
            .Object <- callNextMethod(.Object, when, data)
            .Object@data$Age <- factor(data$Age, levels=c("< 20","[20, 30)","[30, 40)","[40, 50)",">=50"))
            levels(.Object@data$Age) <- c("<20","[20,30)","[30,40)","[40,50)",">=50")
           .Object@data$ExperienceInProgramming <- factor(data$ExperienceInProgramming, levels=c("0","1","2","3","4","5","6","7","8","9","10+"))
            levels(.Object@data$ExperienceInProgramming) <- c("<1","1","2","3","4","5","6","7","8","9","10+")
           .Object@data$ExperienceInLanguage <- factor(data$ExperienceInLanguage, levels=c("0","1","2","3","4","5","6","7","8","9","10+"))
            levels(.Object@data$ExperienceInLanguage) <- c("<1","1","2","3","4","5","6","7","8","9","10+")

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

