

setClass("LanguageQuestionnare_from2012", 
         contains="LanguageQuestionnare"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_from2012",
          # setClass of subclass call constructor without parameters, so need to provide defaults
          definition=function(.Object, when=as.Date("1970-01-01"), data = data.frame()) {
            cat("call of from2012_initialize\n")
            .Object <- callNextMethod(.Object, when, data)
            if (nrow(data)!=0) {
              .Object@additionalFields["AdditionalLanguagesById"] <- normalizeLanguagesColumn(.Object,"AdditionalLanguages1")
              if ( c("Age") %in% names(data) ) {
                 .Object@data$Age <- factor(data$Age, levels=c("<20","[20,30)","[30,40)","[40,50)",">50"))
              }
              .Object@data$ExperienceInProgramming <- factor(data$ExperienceInProgramming, levels=c("<1","1","2","3","4","5","6","7","8","9","10+"))
              .Object@data$ExperienceInLanguage <- factor(data$ExperienceInLanguage, levels=c("<1","1","2","3","4","5","6","7","8","9","10+"))
            }
            return(.Object)
          }
         )

setMethod("languageColumn",
          signature="LanguageQuestionnare_from2012",
           definition=function(object,columnName,top=100,barrier=0,filter=NULL) {
             if (columnName == "AdditionalLanguages") {
                x <- as.factor(unlist(object@additionalFields$AdditionalLanguagesById))
                languageColumnSummary(x,top,barrier)
             } else {
                callNextMethod()
             }
           }
         )


