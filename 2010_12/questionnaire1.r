# R scripts for cleanup and produsing some statistics for dou questionare.
# (see report on http://www.developers.org.ua/archives/rssh/2010/12/14/programming-languages-rating-2010/ )
# Statistics is incomplete, some steps (such as calculating right bounds 
#  for statistically corrected data)  not included.
#
# Use this on own risc.
#
# You can use and redistribute this scripts on conditions of
# GNU General Public License version 2 or later.
# 
#
# (C) Ruslan Shevchenko <ruslan@shevchenko.kiev.ua> 2010
#
# note, that file contains cyrillic comments in utf8 encoding.

#config
drawNow=TRUE

qs <- read.csv(file="questionnaire1.csv", head=TRUE, sep=",")
# normalize data

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
  x <- gsub("^c$","C/C++",x);
  x <- gsub("что такое(.*)","",x);
  x <- gsub("PL-SQL|pl/sql|pl/pgsql","PL/SQL",x);
  x <- gsub("^sql$","SQL",x);
  x
}
#
languagesColumn <- function(cname) { al=NULL
  for(a in strsplit(as.character(qs[,cname]),",")) {
    al=c(al,normalizeLanguage(a))
  }
  al <- factor(al)
  al
} 
al <- languagesColumn('AdditionalLanguages')
pl <- languagesColumn('PetProjectsLanguages')

# в фиксированном списке языков тоже есть мусор  
normalizeFixLanguage <- function(x) {
 x <- gsub("(^ )|( $)","",x);
 x<-gsub("\\(выберите из списка\\)","другой",x)
}
qs['NowLanguage'] <- lapply(qs['NowLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})
qs['NextLanguage'] <- lapply(qs['NextLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})
qs['FirstLanguage'] <- lapply(qs['FirstLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})


# удалим неиспользуемые колонки
qs$Comment <- 0
qs$Timestamp <- 0
# на чем начинали ?
sfl <- summary(qs[['FirstLanguage']])
sfl <- sfl[order(sfl)]
sfl <- sfl[-match("другой",names(sfl))]
if (drawNow) {
  png(file="sfl.png")
  dotchart(sfl[sfl>10])
  title("На каком языке вы начинали работать.")
  dev.off()
}

# на чем пишут сейчас ?
snl <- summary(qs[['NowLanguage']])
snl <- snl[order(snl)]
snl <- snl[-match("другой",names(snl))]
#  нарисуем картинку
if (drawNow) {
  png(file="snl.png")
  dotchart(snl)
  title("На каком языке вы пишете для работы сейчас ")
  dev.off()
}


# на что хотят перейти сейчас ?
sxl <- summary(qs[['NextLanguage']])
sxl <- sxl[rev(order(sxl))]


sxl <- sxl[-match("другой",names(sxl))]
if (drawNow) {
  png(file="sxl.png")
  dotchart(sxl)
  title("Если бы вы начинали сейчас коммерческий проект \n и у вас была-бы свобода выбора ...")
  dev.off()
}

#
# Индекс удовлетворенности языком (для немаргинальных):
lct <- table(qs$NowLanguage,qs$Change)
lci <- lct[,"Нет"]/(lct[,"Нет"]+lct[,"Да"])
lci <- lci[names(snl[snl>15])]
lci <- lci[order(lci)]
if (drawNow) {
  png(file="lci.png")
  barplot(lci,las=2)
  title("Индекс приверженности к языков ...")
  dev.off()
}


lct <- table(qs$NowLanguage,qs$NextLanguage)
languageAfter <- function(name) {
 mgX <- lct[name,]/snl[name]
 mgX <- mgX[mgX>0.01]
 mgX <- mgX[rev(order(mgX))]
}

#
# куда планируют перейти PHP-ники:
print("mirgation from PHP:");
print(languageAfter("PHP"))

# то-же самое для l=других языков
print("mirgation from Delphi:");
print(languageAfter("Delphi"))

print("mirgation from Java:");
print(languageAfter("Java"))

print("mirgation from C#");
print(languageAfter("C#"))

# распределение по языкам и опыту работы
lct <- table(qs$NowLanguage,qs$Experience)
langPercentage <- function(x) {
   lct[x,]/snl[x]
}

lct <- lct[names(snl[snl>50]),]
lct <- lct[,c("0","1","2","3","4","5","6","7","8","9","10 и больше")]
colnames(lct)<-c("0","1","2","3","4","5","6","7","8","9",">10")
plct <- langPercentage(rownames(lct))
if (drawNow) {
  png(file="experience1.png")
  #oldpar <- par(mfrow=c(1,2))
  names<-c("C#","Java","C/C++")
  barplot(lct[names,],beside=TRUE,col=rainbow(3))
  legend("topleft",names,fill=rainbow(3))
  title("опыт работы: C#, Java, C/C++")
  #barplot(plct[names,],beside=TRUE,col=rainbow(3))
  dev.off()
  # и для скрипт-языков
  png(file="experience2.png")
  #oldpar <- par(mfrow=c(1,2))
  names<-c("PHP","Python","Ruby")
  barplot(lct[names,],beside=TRUE,col=rainbow(3))
  title("Опыт работы: скрипт-языки")
  legend("topleft",names,fill=rainbow(3))
  #barplot(plct[names,],beside=TRUE,col=rainbow(3))
  dev.off()
  #par(oldpar)
}

# какие языки используются как дополнительные
sal<-summary(al)
sal<-sal[sal>10]
sal<-sal[order(sal)]
if (drawNow) {
  png(file="sal.png")
  dotchart(sal)
  title("Какие дополнительные языки вы используете для работы ?")
  dev.off()
}


# и для развлечения
spl <- summary(pl)
spl <- spl[spl>10]
spl <- spl[order(spl)]
if (drawNow) {
  png(file="spl.png")
  dotchart(spl)
  title("Есть ли у вас свои pet-projects ?\nЕсли есть, то на каких языках ?")
  dev.off()
}
## сколько пользователей вобще пишет для развлечения:
ppl<-qs[["PetProjectsLanguages"]]
cat("К-ство пользователей, у кого есть свои проекты:",
  length(ppl[ppl!=""])
  ,"\n"
)

## как принимается решение о выборе языка:
scl=summary(qs$Choos)
names(scl) <- c("зависит \nот проекта","заказчиком","исполнителем","моя организация\n специализируется на этом языке","совместно")
if (drawNow) {
  png(file="scl.png")
  barplot(scl)
  title("Кем принимается решение о выборе языка ?")
  text(3,1,labels=c("исполнителем"))
  text(5.5,1,labels=c("совместно"))
  dev.off()
}

## опыт работы в диаспоре и приехавшиз из украины
stu <- table(qs$inUA,qs$Experience)
stu <- stu[,c("0","1","2","3","4","5","6","7","8","9","10 и больше")]
colnames(stu)<-c("0","1","2","3","4","5","6","7","8","9",">10")
stu <- stu[c("да","нет"),]
normalizePercents<-function(tbl) 
{
 for(x in rownames(tbl)) {
   tbl[x,]<-tbl[x,]/sum(tbl[x,])
 }
 tbl
}
stu<-normalizePercents(stu)
# barcode.
# 
if (drawNow) {
  png(file="expUA.png")
  barplot(stu,beside=TRUE,legend=TRUE)
  dev.off()
}

# 
stu <- table(qs$NowLanguage,qs$inUA)
linUA=stu[,"да"]
linNotUA=stu[,"нет"]

linUA<-linUA/sum(linUA)
linUA<-linUA[order(linUA)]
linUA<-linUA[linUA>0.03]

linNotUA<-linNotUA/sum(linNotUA)
linNotUA<-linNotUA[order(linNotUA)]
linNotUA<-linNotUA[linNotUA>0.05]

names<-c("C#","Java","PHP","C/C++","Python","Ruby")
lnua<-cbind(linUA[names],linNotUA[names])
colnames(lnua)<-c("in UA","not in UA")
if (drawNow) {
  png(file="lnUA.png")
  barplot(lnua,beside=TRUE,col=rainbow(6))
  legend("topright",names,fill=rainbow(6))
  dev.off()
}


# now do summary of languages.
names<-c("C#","Java","C/C++","PHP","Python","Ruby","Objective-C","Scala",
      "Delphi", "JavaScript", "Perl", "Haskell", "Lisp", "1С", "Basic",
      "DBase-подобные", "Asm", "Lua", "Fortran", "Cobol","Groovy")

snl['Groovy']=sal['Groovy']
snl['Cobol']=0
snl <- snl[rev(order(snl))]
names <- names(snl)
rxsnl <- snl[names]
sfl['Cobol']=0
sfl['Groovy']=NA
rxsfl <- sfl[names]
sxl['Cobol']=0
sxl['Groovy']=NA
rxsxl <- sxl[names]

splf <- summary(pl)
rxspl <- splf[names]

salf <- summary(al)
rxsal <- salf[names]

rxpsnl <- rxsnl/sum(rxsnl)*100
res<-cbind(rxpsnl,rxsnl,rxsxl,rxsal,rxspl)


