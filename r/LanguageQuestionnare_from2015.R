

setClass("LanguageQuestionnare_from2015", 
         contains="LanguageQuestionnare_from2012"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_from2015",
          definition=function(.Object, when, data) {
            .Object <- callNextMethod(.Object, when, data)
            age <- 2015 - (strptime(data$Birthday,"%m/%d/%Y")$year + 1900)
            age[age < 16 | age > 90] <- NA
            .Object@data$Age <- age
            return(.Object)
          }
         )



