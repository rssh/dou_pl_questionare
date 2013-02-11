

setClass("LanguageQuestionnare",
         representation(when="Date", 
                        originData="data.frame",
                        data="data.frame",
                        additionalFields="list"
                        ),
         prototype(data=data.frame(),
                   additionalFields=list()
                  )
        )


setMethod(f="initialize",
          signature="LanguageQuestionnare",
          definition=function(.Object, when, data) {
            cat("LanguageQuestionnare initialize")
            .Object@when <- when
            .Object@originData <- data
            .Object@data <- data
            # normalization procedures.
            .Object@data["FirstLanguage"] <- normalizeLanguageColumn(.Object,"FirstLanguage")
            .Object@data["NowLanguage"] <- normalizeLanguageColumn(.Object,"NowLanguage")
            validObject(.Object)
            return(.Object)
          }
         )



setGeneric("normalizeLanguageName", function(object,name) { standardGeneric("normalizeLanguageName") })

setMethod(f="normalizeLanguageName",
          definition=function(object,name) {
            patterns<-c()
            patterns["none"]="не программирую|Программирую не для работы"
            patterns["Basic"]="Basic|Visual Basic|VBA|BASIC|VB.Net"
            patterns["Pascal/Delphi"]="^pascal$|Turbo Pascal|^Delphi|Pascal / Delphi"
            patterns["Modula-2"]="Modula2|Modula-2"
            patterns["Fortran"]="Fortran"
            patterns["Focal"]="Focal|FOCAL|Фокал|fokal"
            patterns["ASM"]="калькулятор|MK-61|Assembler|машинные коды|MK-52|машинный код|MK61|МК-61"
            patterns["CoffeeScript"]="CoffeScript"
            patterns["Logo"]="logo"
            patterns["ActionScript"]="(ActionScript(.*)$)|(Action *Script.*$)|^AS$|^as3$"
            patterns["C#"]="c#|С#|C#"
            for(np in names(patterns)) {
               if (grepl(patterns[np],name, ignore.case = TRUE)) {
                 return(np)
               }
            }
            return(name)
          }
         )

setGeneric("normalizeLanguageColumn", function(object, columnName) { standardGeneric("normalizeLanguageColumn") } )

setMethod(f="normalizeLanguageColumn",
          definition=function(object, columnName) {
            cat("call of normalizeLanguageColumn \n")
            object@data[columnName] <- apply(
                                          object@originData[columnName], 
                                          1,
                                          function(x){
                                             factor(normalizeLanguageName(object,as.character(x)))
                                          }
                                       )
            print(object@data[columnName])
            return (object@data[columnName])
          }
         );



languageColumnSummary <- function(x, top, barrier) {
  r <- summary(x)
  if (!is.na(match("",names(r)))) {
    r <- r[-match("",names(r))]
  }
  if (!is.na(match("другой",names(r)))) {
    r <- r[-match("другой",names(r))]
  }
  if (!is.na(match("none",names(r)))) {
    r <- r[-match("none",names(r))]
  }
  r <- r[r>barrier] 
  r <- r[order(r, decreasing=TRUE, na.last=NA)]
  if (top < length(r)) {
     r <- r[1:top]
  }
  r 
}

# vectore of languages, which was first 
# top - select
# barries - barries.

setGeneric("languageColumn", 
           function(object,columnName,top=100,barrier=0,...) {
             standardGeneric("languageColumn")
           }
          )

setMethod("languageColumn",
           definition=function(object,columnName,top=100,barrier=0,...) {
             languageColumnSummary(object@data[[columnName]], top, barrier)
           }
         )


setGeneric("firstLanguages", 
           function(object,top=100,barrier=0,...) {
             standardGeneric("firstLanguages")
           }
          )
setMethod(f="firstLanguages",
          definition=function(object, top=100, barrier=0) {
            languageColumnSummary(object@data$FirstLanguage, top, barrier)
          })


setGeneric("nowLanguages", 
           function(object,top=100,barrier=0,...) {
             standardGeneric("nowLanguages")
           }
          )
setMethod(f="nowLanguages",
          definition=function(object, top=100, barrier=0) {
            languageColumnSummary(object@data$NowLanguage, top, barrier)
          })


