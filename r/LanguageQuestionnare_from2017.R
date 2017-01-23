
#  as 2016 + education


setClass("LanguageQuestionnare_from2017", 
         contains="LanguageQuestionnare_from2016"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_from2017",
          definition=function(.Object, when, data) {
            .Object <- callNextMethod(.Object, when, data)
            if (nrow(data)!=0) {
              .Object@data["LearnLanguage"] <- normalizeLanguageColumn(.Object,"LearnLanguage")
            }
            return(.Object)
          }
         )




