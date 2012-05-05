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
  x <- gsub("Matlab","MatLab",x);
  x <- gsub("Ocaml|ocaml","OCaml",x);
  x <- gsub("(VBScript)|(VB.Net)|(VB.NET)|VBS|PureBasic","Basic",x);
  x <- gsub("JavaScript(.*)$","JavaScript",x);
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
  x <- gsub("CPL(.*)","CPL",x);
  x <- gsub("D \\(client side\\)","D",x);
  x <- gsub("jruby","Ruby",x);
  x <- gsub("clojure","Clojure",x);
  x <- gsub("f#","F#",x);
  x <- gsub("^c$","C",x);
  x <- gsub("что такое(.*)","",x);
  x <- gsub("PL-SQL|pl/sql|pl/pgsql","PL/SQL",x);
  x <- gsub("^sql$","SQL",x);
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
al <- languagesColumn('AdditionalLanguages',qs2)
pl <- languagesColumn('PetProjectsLanguages',qs2)

# в фиксированном списке языков тоже есть мусор  
normalizeFixLanguage <- function(x) {
 x <- gsub("(^ )|( $)","",x);
 x <- gsub("PL\\\\SQL|(pl/sql)","PL/SQL",x);
 x <- gsub("Visual Basic(.*)|VisualBasic|VB|Sinclair BASIC|QBasic","Basic",x);
 x <- gsub("(^машинный код(.*))|(binary code)|Assembler(.*)|Ассембер(.*)","Asm",x);
 x <- gsub("Asm for M-22","Asm",x);
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
}

# "да"/"нет" пусть будут с большой буквы 
normalizeBool <- function(x) {
  x<-gsub("да","Да",x)
  x<-gsub("нет","Нет",x)
}


