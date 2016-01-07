
# one differrence - age now number.
# so - exactly as 2012 + Age column


setClass("LanguageQuestionnare_from2016", 
         contains="LanguageQuestionnare_from2012"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_from2016",
          definition=function(.Object, when, data) {
            .Object <- callNextMethod(.Object, when, data)
            age <- data$AgeYears
            age[age < 16 | age > 90] <- NA
            .Object@data$Age <- age
            return(.Object)
          }
         )




