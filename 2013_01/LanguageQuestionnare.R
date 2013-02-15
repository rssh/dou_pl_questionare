

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
          definition=function(.Object, when = as.Date("1970-01-01"), data = data.frame()) {
            cat("LanguageQuestionnare initialize")
            .Object@when <- when
            .Object@originData <- data
            .Object@data <- data
            # normalization procedures.
            #(check - that we in not empty initializer in class definition)
            if (nrow(data)!=0) {
              .Object@data["FirstLanguage"] <- normalizeLanguageColumn(.Object,"FirstLanguage")
              .Object@data["NowLanguage"] <- normalizeLanguageColumn(.Object,"NowLanguage")
              .Object@data["NextLanguage"] <- normalizeLanguageColumn(.Object,"NextLanguage")
              validObject(.Object)
            }
            return(.Object)
          }
         )



normalizeLanguageName <-function(name) {
            patterns<-c()
            patterns["none"]="не программирую|Программирую не для работы|изучил бы рынок|некорректен|абстрактный|зависит|it depends|Не определился|начал|не знаю|Зависит|^$"
            patterns["Basic"]="Basic|Visual Basic|VBA|BASIC|VB.Net|VBScript"
            patterns["Pascal/Delphi"]="^pascal$|Turbo Pascal|^Delphi|Pascal / Delphi"
            patterns["Modula-2"]="Modula2|Modula-2"
            patterns["Fortran"]="Fortran"
            patterns["Focal"]="Focal|FOCAL|Фокал|fokal"
            patterns["ASM"]="калькулятор|MK-61|Assembler|машинные коды|MK-52|машинный код|MK61|МК-61"
            patterns["CoffeeScript"]="CoffeScript"
            patterns["Logo"]="logo"
            patterns["ActionScript"]="(ActionScript(.*)$)|(Action *Script.*$)|^AS$|^as3$"
            patterns["C#"]="c#|С#|C#"
            patterns["C++"]="c\\+\\+|С\\+\\+|С\\+\\+"
            patterns["C"]="^c$|^С$|^С$"
            patterns["SAP ABAP"]="^SAP$|ABAP$"
            patterns["Shell"]="^sh$|^bash$|^shell$"
            patterns["T-SQL"]="^T-SQL$|Transact-SQL$"
            patterns["Tcl"]="^Tcl$|Tcl/Tk$"
            patterns["Matlab"]="^MATLAB$|^matlab$"
            patterns["Clojure"]="^clojure$|^Clojure$"
            patterns["Python"]="^python$|^jython$"
            for(np in names(patterns)) {
               if (grepl(patterns[np],name, ignore.case = TRUE)) {
                 return(np)
               }
            }
            return(name)
}

setGeneric("normalizeLanguageColumn", function(object, columnName) { standardGeneric("normalizeLanguageColumn") } )

setMethod(f="normalizeLanguageColumn",
          definition=function(object, columnName) {
            cat("normalizeLanguageColumn for ",object@when," ",columnName,"\n")
            object@data[columnName] <- apply(
                                          object@originData[columnName], 
                                          1,
                                          function(x){
                                             factor(normalizeLanguageName(as.character(x)))
                                          }
                                       )
            return (object@data[columnName])
          }
         );

setGeneric("normalizeLanguagesColumn", function(object, columnName) { standardGeneric("normalizeLanguagesColumn") } )

setMethod(f="normalizeLanguagesColumn",
          definition=function(object, columnName) {
            cat("call of normalizeLanguagesColumn ",columnName, "\n")
            print(object);
            print(object@when);
            c <- sapply(object@data[columnName], function(x) {
                          sapply(strsplit(as.character(x),","),function(x) {
                              normalizeLanguageName(gsub(x," ",""))
                          })
                        })
            c
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
           function(object,columnName,top=100,barrier=0) {
             standardGeneric("languageColumn")
           }
          )

setMethod("languageColumn",
           definition=function(object,columnName,top=100,barrier=0) {
             languageColumnSummary(object@data[[columnName]], top, barrier)
           }
         )


setGeneric("firstLanguages", 
           function(object,top=100,barrier=0) {
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


migrations <- function(object) {
  data <- object@data
  m <- table(data$NowLanguage, data$NextLanguage)
  apply(m, 1, function(r) { r[r>0] })
}

setGeneric("satisfactionIndex", function(object, barrier=5) { standardGeneric("satisfactionIndex") } )

setMethod(f="satisfactionIndex",
          definition = function(object, barrier) {
            data <- object@data
            t <- table(data$NowLanguage, data$NextLanguage)
            names <- intersect(rownames(t),colnames(t))
            lc <- languageColumn(object,"NowLanguage",barrier=barrier)
            names <- intersect(names,names(lc))
            li <- array(0,length(names))
            names(li) <- names
            for(i in names) {
               li[i] <- t[i,i]/sum(t[i,])
            }
            li[order(li, decreasing=TRUE)]
          })



