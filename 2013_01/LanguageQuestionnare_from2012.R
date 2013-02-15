

setClass("LanguageQuestionnare_from2012", 
         contains="LanguageQuestionnare"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_from2012",
          definition=function(.Object, when, data) {
            cat("call of from2012_initialize")
            .Object <- callNextMethod(.Object, when, data)
            .Object@data["AdditionalLanguages"] <- normalizeLanguagesColumn(.Object,"AdditionalLanguages1")
            return(.Object)
          }
         )


