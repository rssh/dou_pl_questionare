# R scripts for cleanup and produsing some statistics for dou questionare.
# This file use sone common functions.
#
# Use this on own risc.
#
# You can use and redistribute this scripts on conditions of
# GNU General Public License version 2 or later.
# 
#
# (C) Ruslan Shevchenko <ruslan@shevchenko.kiev.ua> 2010, 2011, 2012
#
# note, that file contains cyrillic comments in utf8 encoding.

#config

# попробуес привести к нормальному виду список дополнительных языков:
normalizeLanguage <- function(x) {
  x <- gsub("(^ )|( $)","",x);
  x <- gsub("(ActionScript(.+)$)|(Action *Script.*$)|AS3|AS|as3",
            "JavaScript",x);
  x <- gsub("actionscript|Actionscript|ActionScript|actionScript|(Adobe Fl.*)",
            "JavaScript",x);
  x <- gsub("JavaScript(.*)","JavaScript",x);
  x <- gsub("groovy","Groovy",x);
  x <- gsub("Groovy / Grails at back-end","Groovy",x);
  x <- gsub("(Groovy.*)|& Groovy","Groovy",x);
  x <- gsub("Android Java|Android","Java",x);
  x <- gsub("xslt","XSLT",x);
  x <- gsub("(built-in.*)","Other",x);
  x <- gsub("Delphi.*","Delphi",x);
  x <- gsub("(erlang)|(Erlang \\(server side\\))","Erlang",x);
  x <- gsub("Flash|Flex","JavaScript",x);
  x <- gsub("Google Go","Go",x);
  x <- gsub("Shell.*|bash|UNIX shell|unix shell|Shell.*Bash|shell|Bash|ksh","Shell",x);
  x <- gsub("(Shell.scripts)|(Shell-scripting)","Shell",x);
  x <- gsub("FoxPro","DBase-подобные",x);
  x <- gsub("Matlab|matlab","MatLab",x);
  x <- gsub("Ocaml|ocaml","OCaml",x);
  x <- gsub("(VBScript)|(VB.Net)|(VB.NET)|VBS|PureBasic","Basic",x);
  x <- gsub("JavaScript(.*)$|JScript","JavaScript",x);
  x <- gsub("MXML","",x);
  x <- gsub("(^XML$)|(^xml$)","",x);
  x <- gsub("^XSL$","XSLT",x);
  x <- gsub("Qt","",x);
  x <- gsub("English","",x);
  x <- gsub("sh","Shell",x);
  x <- gsub("php","PHP",x);
  x <- gsub("go!|go","Go",x);
  x <- gsub("TCL|tcl","Tcl",x);
  x <- gsub("TurboProlog","Prolog",x);
  x <- gsub("Assembler","Asm",x);
  x <- gsub("CPL(.*)","CPL",x);
  x <- gsub("D \\(client side\\)","D",x);
  x <- gsub("jruby","Ruby",x);
  x <- gsub("clojure","Clojure",x);
  x <- gsub("f#","F#",x);
  x <- gsub("^c$","C",x);
  x <- gsub("что такое(.*)","",x);
  x <- gsub("PL-SQL|pl/sql|pl/pgsql","PL/SQL",x);
  x <- gsub("^sql$","SQL",x);
  x <- gsub("^html$","HTML",x);
  x <- gsub("^Qt C$","C",x);
  x <- gsub("(выберите из списка)","другой",x);
  x <- gsub("Visual Basic|VBA|VBscript","Basic",x);
  x <- gsub("Shell scripting","Shell",x);
  x <- gsub("t-sql|TSQL","T-SQL",x);
  x
}
#
languagesColumn <- function(cname,data) { al=NULL
  for(a in strsplit(as.character(data[,cname]),",")) {
    al=c(al,normalizeLanguage(a))
  }
  al <- factor(al)
  al
} 

# в фиксированном списке языков тоже есть мусор  
normalizeFixLanguage <- function(x) {
 x <- gsub("(^ )|( $)","",x);
 x <- gsub("PL\\\\SQL|(pl/sql)","PL/SQL",x);
 x <- gsub("Visual Basic(.*)|VisualBasic|VB|Sinclair BASIC|QBasic","Basic",x);
 x <- gsub("Basic.NET|Basic (.*)","Basic",x);
 x <- gsub("(^машинный код(.*))|(binary code)|Assembler(.*)|Ассембер(.*)","Asm",x);
 x <- gsub("Asm for M-22","Asm",x);
 x <- gsub("Assembler","Asm",x);
 x <- gsub("мнемокоды МК(.*)|МК-62","Asm",x);
 x <- gsub("Clipper|Clarion|Fox Pro|FoxPro","DBase",x);
 x <- gsub("С#","C#",x);
 x<-gsub("\\(выберите из списка\\)","нет",x);
 x <- gsub("зависит от(.*)","нет",x);
 x <- gsub("Зависит от(.*)","нет",x);
 x <- gsub("не занимаюсь(.*)","нет",x);
 x <- gsub("Больше проект(.*)|какой(.*)","нет",x);
 x <- gsub("В зависимости(.*)","нет",x);
 x <- gsub("Depends(.*)|где же(.*)","нет",x);
 x <- gsub("Python(.*)","Python",x);
 x <- gsub("erlang","Erlang",x);
 x <- gsub("F#, Ocaml","F#",x);
 x <- gsub("сильно(.*)","нет",x);
 x <- gsub("flex","ActionScript",x);
 x <- gsub("go|go,(.*)","Go",x);
 x <- gsub("Ruby(.*)","Ruby",x);
 x <- gsub("c/asm/(.*)","C",x);
 x <- gsub("PL/Sql(.*)","PL/SQL",x);
 x <- gsub("APEX(.*)|Apex/(.*)","Apex",x);
 x <- gsub("Action Script|ActionScript 3","ActionScript",x);
 x <- gsub("Qt C[+][+]","C++",x);
 x <- gsub("ocaml","OCaml",x);
 x <- gsub("x[+][+]","X++",x);
 x <- gsub("[(]выберите из списка[)]","другой",x);
 x <- gsub("Delphi|Pascal|Pascal / Delphi","Pascal/Delphi",x);
 x <- gsub("DBase-подобные|Dbase","DBase",x);
 # в прошлый раз 1С была кириллицей, сейчас латыницей
 x <- gsub('1C','1С',x);
 x
}

# "да"/"нет" пусть будут с большой буквы 
normalizeBool <- function(x) {
  x<-gsub("да","Да",x)
  x<-gsub("нет","Нет",x)
}


summaryLangColumn<-function(cname,qs) {
 snl <- summary(qs[[cname]])
 snl <- snl[order(snl)]
 if (!is.na(match("",names(snl)))) {
    snl <- snl[-match("",names(snl))]
 }
 if (!is.na(match("другой",names(snl)))) {
    snl <- snl[-match("другой",names(snl))]
 }
 # хмм, у нас же в преамбле было написано что SQL здесь не рассматривается
 if (!is.na(match("SQL",names(snl)))) {
    snl <- snl[-match("SQL",names(snl))]
 }
 if (!is.na(match("HTML",names(snl)))) {
    snl <- snl[-match("HTML",names(snl))]
 }
 return(snl)
}

zeroNames <- function(data,names) {
 for(i in names) {
   if (is.na(data[i])) {
     data[i] = 0
   }
 }
 data
}


