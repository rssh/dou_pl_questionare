
#  as 2016 + education


setClass("LanguageQuestionnare_from2019", 
         contains="LanguageQuestionnare_from2017"
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare_from2019",
          definition=function(.Object, when, data) {
            .Object <- callNextMethod(.Object, when, data)
            if (nrow(data)!=0) {
              a <- data$ExperienceInProgramming
              a <- factor(
                     ifelse(a<1,"<1", ifelse(a>=10,"10+", as.integer(a))),
                     levels=c("<1","1","2","3","4","5","6","7","8","9","10+"))
              .Object@data["ExperienceInProgramming"] <- a
            }
            return(.Object)
          }
         )




