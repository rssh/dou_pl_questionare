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
# (C) Ruslan Shevchenko <ruslan@shevchenko.kiev.ua> 2010, 2011
#
# note, that file contains cyrillic comments in utf8 encoding.

#config
drawNow=TRUE

qs1 <- read.csv(file="../2010_12/questionare1.csv", head=TRUE, sep=",")
qs2 <- read.csv(file="questionare2.csv", head=TRUE, sep=",")
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
qs1['NowLanguage'] <- lapply(qs1['NowLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})
qs1['NextLanguage'] <- lapply(qs1['NextLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})
qs1['FirstLanguage'] <- lapply(qs1['FirstLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})

qs2['NowLanguage'] <- lapply(qs2['NowLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})
qs2['NextLanguage'] <- lapply(qs2['NextLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})
qs2['FirstLanguage'] <- lapply(qs2['FirstLanguage'],
                            function(x){factor(normalizeFixLanguage(x))})

# удалим неиспользуемые колонки
qs1$Comment <- NULL
qs1$Timestamp <- NULL
qs2$Timestamp <- NULL


# "да"/"нет" пусть будут с большой буквы 
normalizeBool <- function(x) {
  x<-gsub("да","Да",x)
  x<-gsub("нет","Нет",x)
}
qs2['InUA'] <- lapply(qs2['InUA'],function(x){factor(normalizeBool(x))})

qs <- qs2


# на чем начинали ?
funsfl <- function(qs) {
  sfl <- summary(qs[['FirstLanguage']])
  sfl <- sfl[order(sfl)]
  return(sfl[sfl>10])
}
sfl1 <- funsfl(qs1)
sfl1 <- sfl1[-match("другой",names(sfl1))]
sfl2 <- funsfl(qs2)

if (drawNow) {
  png(file="sfl.png")
  dotchart(sfl2)
  title("На каком языке вы написали свою первую программу")
  dev.off()
}



# на чем пишут сейчас ?
funsnl<-function(qs) {
 snl <- summary(qs[['NowLanguage']])
 snl <- snl[order(snl)]
 if (!is.na(match("другой",names(snl)))) {
    snl <- snl[-match("другой",names(snl))]
 }
 # хмм, у нас же в преамбле было написано что SQL здесь не рассматривается
 if (!is.na(match("SQL",names(snl)))) {
    snl <- snl[-match("SQL",names(snl))]
 }
 return(snl)
}
snl1 <- funsnl(qs1)
# в прошлый раз 1С была кириллицей, сейчас латыницей
snl1['1C']=snl1['1С']
snl1sv <- snl1
snl1 <- snl1[snl1>3]
snl2 <- funsnl(qs2)
snl2sv <- snl2
snl2 <- snl2[snl2>3]
#  нарисуем картинку
if (drawNow) {
  png(file="snl.png")
  dotchart(snl2)
  title("На каком языке вы пишете для работы сейчас ")
  dev.off()
}

# приведем прошлый и будущтй опрос к одним параметром
# нынешний:
snlp <- snl2
snlp["C/C++"] <- snl2["C"]+snl2["C++"]
snlp["JavaScript"] <- snl2["JavaScript"]+snl2["ActionScript"]
snlp <- snlp[-match(c("C","C++","ActionScript"),names(snlp))]
# прошлый:
i<-match("DBase-подобные", names(snl1))
names(snl1)[i]<-"DBase"

snl1old <- snl1
snlpold <- snlp
# приведем к долям от общего к-ства
snl1 <- (snl1/sum(snl1))*100
snlp <- (snlp/sum(snlp))*100
# нам интересно  тольк то, что больше процента
snl1 <- snl1[snl1>1]
snlp <- snlp[snlp>1]


cnames <- intersect(names(snl1),names(snlp))
## сдалаем общую матрицу и выложим на общий график
snlm <- matrix(ncol=length(cnames),nrow=2,byrow=TRUE)
colnames(snlm) <- cnames
rownames(snlm) <- c("2010-11","2011-07") 
snlm["2010-11",] <- snl1[cnames]
snlm["2011-07",] <- snlp[cnames]
if (drawNow) {
  png(file="slnm.png")
  barplot(snlm,beside=TRUE,cex.names=0.6,legend=TRUE,args.legend=list(x="topleft"))
  title("Доли языков в сравнении с прошлым опросом")
  dev.off();
}



# на что хотят перейти сейчас ?
sxl <- summary(qs[['NextLanguage']])
sxl <- sxl[order(sxl)]
if (!is.na(match("другой",names(sxl)))) {
  sxl <- sxl[-match("другой",names(sxl))]
}
if (!is.na(match("нет",names(sxl)))) {
  sxl <- sxl[-match("нет",names(sxl))]
}
sxl<-sxl[sxl>5]
if (drawNow) {
  png(file="sxl.png")
  dotchart(sxl)
  title("Если бы вы начинали сейчас коммерческий проект \n и у вас была-бы свобода выбора ...")
  dev.off()
}

#
# Индекс удовлетворенности языком (для немаргинальных):
#  старые рассчеты
lct1 <- table(qs1$NowLanguage,qs1$Change)
lci1 <- lct1[,"Нет"]/(lct1[,"Нет"]+lct1[,"Да"])
# Запомним для использования в итогах
lci1 <- lci1[names(snl1old[snl1old>15])]
lci1 <- lci1[order(lci1)]
lct1 <- table(qs1$NowLanguage,qs1$NextLanguage)
# новые на основе выбора следующего языка
lct <- table(qs$NowLanguage,qs$NextLanguage)
lci <- array(0,length(rownames(lct)))
names(lci) <- rownames(lct)
for(i in rownames(lct)) {
  if (i %in% colnames(lct)) {
    lci[i]<-lct[i,i]/sum(lct[i,])
  }
}
lcisv <- lci
lci <- lci[names(snl2[snl2>15])]
lci <- lci[order(lci)]
if (drawNow) {
  png(file="lci.png")
  barplot(lci,las=2)
  title("Индекс приверженности к языкам ...")
  dev.off()
}


snl <- snl2
languageAfter <- function(lct,name) {
 mgX <- lct[name,]/snl[name]
 mgX <- mgX[mgX>0.01]
 mgX <- mgX[rev(order(mgX))]
}

#
# куда планируюь уйти с C
print("mirgation from C:");
print(languageAfter(lct,"C"))

#
# куда планируют перейти PHP-ники:
print("mirgation from PHP:");
print(languageAfter(lct,"PHP"))

print("mirgation from Perl");
print(languageAfter(lct,"Perl"))

# то-же самое для l=других языков
print("mirgation from Delphi:");
print(languageAfter(lct,"Delphi"))

print("mirgation from 1C:");
print(languageAfter(lct,"1C"))

print("mirgation from Java:");
print(languageAfter(lct,"Java"))

print("old mirgation from Java:");
print(languageAfter(lct1,"Java"))

print("mirgation from Python");
print(languageAfter(lct,"Python"))

print("mirgation from C#");
print(languageAfter(lct,"C#"))



# распределение по языкам и опыту работы
lct1 <- table(qs1$NowLanguage,qs1$Experience)
lct2 <- table(qs2$NowLanguage,qs2$ExperienceInProgramming)
langPercentage <- function(lct,snl,x) {
   lct[x,]/snl[x]
}


lct2 <- lct2[names(snl2[snl2>50]),]
#lct <- lct[,c("0","1","2","3","4","5","6","7","8","9","10 и больше")]
lct2 <- lct2[,c("1","2","3","4","5","6","7","8","9","10+")]
#colnames(lct)<-c("0","1","2","3","4","5","6","7","8","9",">10")
plct2 <- langPercentage(lct2,snl2,rownames(lct2))
if (drawNow) {
  png(file="experience1.png")
  #oldpar <- par(mfrow=c(1,2))
  names<-c("C#","Java","C","C++")
  barplot(lct2[names,],beside=TRUE,col=rainbow(4))
  legend("topleft",names,fill=rainbow(3))
  title("опыт работы: C#, Java, C, C++")
  #barplot(plct[names,],beside=TRUE,col=rainbow(3))
  dev.off()
  # и для скрипт-языков
  png(file="experience2.png")
  #oldpar <- par(mfrow=c(1,2))
  names<-c("PHP","Python","Ruby")
  barplot(lct2[names,],beside=TRUE,col=rainbow(3))
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

# демография - опыт работы в программировании сейчас,
ew2 <- summary(qs2[['ExperienceInProgramming']])[c("1","2","3","4","5","6","7","8","9","10+")]
ew2 <- ew2/sum(ew2)
# по сравнению с прошлым опросом
ew1 <- summary(qs1[['Experience']])
ew1["1"]=ew1["1"]+ew1["2"];
ew1["10+"]<-ew1["10 и больше"]
ew1 <- ew1[c("1","2","3","4","5","6","7","8","9","10+")]
ew1 <- ew1/sum(ew1)
## сдалаем общую матрицу и выложим на общий график
ew <- matrix(ncol=10,nrow=2,byrow=TRUE)
colnames(ew) <- names(ew2)
rownames(ew) <- c("2010-11","2011-07")
ew["2010-11",] <- ew1
ew["2011-07",] <- ew2
if (drawNow) {
  png(file="ew.png")
  barplot(ew,beside=TRUE)
  title("Распределение опыта работы программистом")
  dev.off()
}

#на чем пишут люи старше 50 ?
t <- table(qs$Age,qs$NowLanguage)
x <- t[">= 50",]
x <- x[x>0]
x <- x[rev(order(x))]
print("languages for people after 50")
print(x)
# а 40-50 ?
x <- t["[40, 50)",]
x <- x[x>0]
x <- x[rev(order(x))]
print("languages for people in [40,50)")
print(x)

en <- c("1","2","3","4","5","6","7","8","9","10+")
t2<-table(qs$ExperienceInLanguage,qs$ExperienceInProgramming)[en,en]
if (drawNow) {
  png(file="el.png")
  barplot(t2,col=rainbow(10))
  title("Опыт работы программистом/на выбранном языке")
  dev.off()
}



## опыт работы в диаспоре и приехавшиз из украины
stu <- table(qs$InUA,qs$ExperienceInProgramming)
stu <- stu[,c("1","2","3","4","5","6","7","8","9","10+")]
colnames(stu)<-c("1","2","3","4","5","6","7","8","9",">10")
stu <- stu[c("Да","Нет"),]
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
stu <- table(qs$NowLanguage,qs$InUA)
linUA=stu[,"Да"]
linNotUA=stu[,"Нет"]


linUA<-linUA/sum(linUA)
linUA<-linUA[order(linUA)]
linUA<-linUA[linUA>0.03]

linNotUA<-linNotUA/sum(linNotUA)
linNotUA<-linNotUA[order(linNotUA)]
linNotUA<-linNotUA[linNotUA>0.03]

names<-c("C#","Java","PHP","C++","Python","Ruby")
lnua<-cbind(linUA[names],linNotUA[names])
colnames(lnua)<-c("in UA","not in UA")
if (drawNow) {
  png(file="lnUA.png")
  barplot(lnua,beside=TRUE,col=rainbow(6))
  legend("topright",names,fill=rainbow(6))
  dev.off()
}

# now do summary of languages.
names<-c("C#","Java","C","C++","PHP","Python","Ruby","Objective-C","Scala",
      "Delphi", "JavaScript", "ActionScript","F#",
      "Perl", "Haskell", "Lisp", "1C", "Basic", "Erlang",
      "DBase", "PL/SQL", "Asm", "Lua", "Fortran", "Cobol","Groovy")

#
# allign all to one set of names
zeroNames <- function(data,names) {
 for(i in names) {
   if (is.na(data[i])) {
     data[i] = 0
   }
 }
 data
}


snl1sv <- snl1sv[-match("нет",names(snl1sv))]
# snl2sv <- snl2sv[-match("нет",names(snl1sv)]

snl1sv <- zeroNames(snl1sv,names)
snl2sv <- zeroNames(snl2sv,names)

rxsnl1p <- (snl1sv/sum(snl1sv))[names]*100
rxsnl2p <- (snl2sv/sum(snl2sv))[names]*100

rxsnl2 <- snl2sv[names]

rxsfl <- sfl2[names]

sxl <- zeroNames(sxl,names)
rxsxl <- sxl[names]
rxsxlp <- (sxl/sum(sxl))[names]*100


splf <- summary(pl)
splf <- zeroNames(splf,names)
rxspl <- splf[names]

salf <- summary(al)
salf <- zeroNames(salf,names)
rxsal <- salf[names]

diff = rxsnl2p-rxsnl1p

rxlci <- lcisv[names]

#
# печатаем изменения по сравнению с прошлым разом
# если вероятность изменения > 90%
pv <- cbind(names)
for(l in names) {
  pv[l] <-prop.test(c(snl2sv[l],snl1sv[l]),c(n2,n1))$p.value
}


res<-cbind(rxsnl2p,diff,rxsnl2,rxsxlp,rxsxl,rxsal,rxspl,rxlci)

for(l in names) {
  if (is.na(pv[l]) || pv[l]>0.10) {
    res[l,'diff'] <- NA
  }
}

# и показать финальную таблцу, отсортированную по доле рынка
res<- res[rev(order(rxsnl2)),]
res

