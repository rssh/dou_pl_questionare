

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
            cat("LanguageQuestionnare initialize \n")
            .Object@when <- when
            .Object@originData <- data
            .Object@data <- data
            # normalization procedures.
            #(check - that we in not empty initializer in class definition)
            if (nrow(data)!=0) {
              if ('FirstLanguage' %in% colnames(.Object@originData))) {
                .Object@data["FirstLanguage"] <- normalizeLanguageColumn(.Object,"FirstLanguage")
              }
              if ('NowLanguage' %in% colnames(.Object@originData))) {
                .Object@data["NowLanguage"] <- normalizeLanguageColumn(.Object,"NowLanguage")
              }
              if ('NextLanguage' %in% colnames(.Object@originData))) {
                .Object@data["NextLanguage"] <- normalizeLanguageColumn(.Object,"NextLanguage")                
              }              
              validObject(.Object)
              if ('AdditionalLanguages' %in% colnames(.Object@originData)) {
                 .Object@additionalFields["AdditionalLanguagesById"] <- normalizeLanguagesColumn(.Object,"AdditionalLanguages")
              }
              if ('PetProjectsLanguages' %in% colnames(.Object@originData)) {
                 .Object@additionalFields["PetProjectsLanguagesById"] <- normalizeLanguagesColumn(.Object,"PetProjectsLanguages")
              }
              if ('NowLanguages2' %in% colnames(.Object@originData)) {
                 .Object@additionalFields["NowLanguages2ById"] <- normalizeLanguagesColumn(.Object,"NowLanguages2")
              }
              if (!('Age' %in% colnames(.Object@originData))) {
                 print(paste("No Age in ",when, sep=""))
              }
            }
            return(.Object)
          }
         )



normalizeLanguageName <-function(name) {
            #cat("normalizeLanguageName, name=",name," class(name)=",class(name),"\n")
            patterns<-c()
            patterns["none"]="зависит|it depends|Не определился|начал|не знаю|Зависит|^$|None |^None|не использую|only one|никакой|нічого|^nope$|^нет$"
            #patterns["Basic"]="Basic|Visual Basic|BASIC|VB.Net|VBScript|^VB$"

            # checked cleaned 2016-01, 2015-01, 2014-01
            patterns["Pascal/Delphi"]="^pascal$|Turbo Pascal|^Delphi|Pascal / Delphi"
            patterns["Modula-2"]="^Modula2|Modula-2"
            patterns["Fortran"]="Fortran"
            patterns["Focal"]="Focal|FOCAL|Фокал|fokal"

            # checked cleaned 2016-01, 2015-01
            patterns["ASM"]="калькулятор|MK-61|Assembler|машинные коды|MK-52|машинный код|MK61|МК-61|^Asm$"
            patterns["CoffeeScript"]="CoffeScript|coffeescript"
            patterns["ActionScript"]="(ActionScript(.*)$)|(Action *Script.*$)|^AS$|^as3$"
            patterns["C#"]="c#|С#|C#"
            patterns["C++"]="c\\+\\+|С\\+\\+|С\\+\\+"
            patterns["C"]="^c$|^С$|^С$"
            patterns["SAP ABAP"]="^SAP$|ABAP$"
            #patterns["Shell"]="^sh$|^bash$|^shell$|Shell Script|linux shell|bash( |-)scripting|C-Shell$|^ksh$|sh / bash|UNIX shell"
            # checked cleaned 2016-01, 
            patterns["T-SQL"]="^T-SQL$|Transact-SQL$|^TSQL$|^T-SQL;"
            patterns["Matlab"]="^MATLAB$|^matlab|Matlab$"
            patterns["Clojure"]="^clojure$|^Clojure$"
            patterns["Python"]="^python$|^jython$"
            patterns["PowerShell"]="^Povershell$|^Powershell$|^powershell$"
            patterns["Groovy"]="Groovy|^groovy"
            patterns["Erlang"]="erlang"
            patterns["Go"]="^Google Go$|^golang$|^GoLang$|^go$"
            patterns["OCaml"]="^ocaml$"
            patterns["PL-SQL"]="^pl/sql$"
            patterns["Lua"]="^LUA$"
            for(np in names(patterns)) {
               if (grepl(patterns[np],name, ignore.case = TRUE)) {
                 return(np)
               }
            }
            return(name)
}

setGeneric("normalizeLanguageColumn", function(object, columnName) { standardGeneric("normalizeLanguageColumn") } )

setMethod(f="normalizeLanguageColumn",
          signature="LanguageQuestionnare",
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
          signature="LanguageQuestionnare",
          definition=function(object, columnName) {
            cat("call of normalizeLanguagesColumn ",columnName, "\n")
            c <- lapply(object@data[columnName], function(x) {
		          l <- lapply(strsplit(x,","),
                                   function(y) {
                                     gsub("^( )+|( )+$","",y)
                                   })
                          lapply(l, function(y) {
                                    l1 <- lapply(y, function(z) {
                                       normalizeLanguageName(z)
                                    })
                                    unlist(l1)
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
  if (!is.na(match("unknown",names(r)))) {
    r <- r[-match("unknown",names(r))]
  }
  if (!is.na(match("unknown",names(r)))) {
    r <- r[-match("unknown",names(r))]
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
           function(object,columnName,top=100,barrier=0,local.filter=NULL) {
             standardGeneric("languageColumn")
           }
          )

setMethod("languageColumn",
          signature="LanguageQuestionnare",
           definition=function(object,columnName,top=100,barrier=0,local.filter=NULL) {
             if (is.null(local.filter)) {
               local.filter = function(obj) { object@data }
             }
             if (columnName=="AdditionalLanguages"
                 || columnName=="PetProjectsLanguages"
                 || columnName=="NowLanguages2"
               ) {
               cdata <- as.factor(unlist(object@additionalFields[[paste(columnName,"ById",sep="")]]))
             } else {
               cdata <- local.filter(object)[[columnName]]
             }
             languageColumnSummary(cdata, top, barrier)
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


setGeneric("withAdditional", function(object, language, barrier=2) 
   { standardGeneric("withAdditional") } )

setMethod(f="withAdditional",
          definition = function(object, language, barrier) {
            cp <- sapply(object@additionalFields$AdditionalLanguagesById,
                         function(y) { language %in% y } )
            r <- summary(object@data["NowLanguage"][cp,])
            r <- r[r > barrier]
            r[order(r, decreasing=TRUE)]
          }
         )




