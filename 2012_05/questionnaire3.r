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
# (C) Ruslan Shevchenko <ruslan@shevchenko.kiev.ua> 2010, 2011, 2012
#
# note, that file contains cyrillic comments in utf8 encoding.

#config
drawNow=TRUE

qs1 <- read.csv(file="../2010_12/questionnaire1.csv", head=TRUE, sep=",")
qs2 <- read.csv(file="../2011_07/questionnaire2.csv", head=TRUE, sep=",")
qs3 <- read.csv(file="questionnaire3.csv", head=TRUE, sep=",")
# normalize data

source('func.r');

al1 <- languagesColumn('AdditionalLanguages',qs1)
al2 <- languagesColumn('AdditionalLanguages',qs2)
al3 <- languagesColumn('AdditionalLanguages1',qs3)
al3_1 <- languagesColumn('NowLanguages2',qs3)
al3_2 <- languagesColumn('AdditionalLanguages3',qs3)
pl2 <- languagesColumn('PetProjectsLanguages',qs2)
pl3 <- languagesColumn('PetProjectsLanguages',qs3)

languageColumn <- function(cname,qs) {
 lapply(qs[cname],function(x){factor(normalizeFixLanguage(x))})
}


qs1['NowLanguage'] <- languageColumn('NowLanguage',qs1);
qs1['NextLanguage'] <- languageColumn('NextLanguage',qs1);
qs1['FirstLanguage'] <- languageColumn('FirstLanguage',qs1);

qs2['NowLanguage'] <- languageColumn('NowLanguage',qs2);
qs2['NextLanguage'] <- languageColumn('NextLanguage',qs2);
qs2['FirstLanguage'] <- languageColumn('FirstLanguage',qs2);

qs3['NowLanguage'] <- languageColumn('NowLanguage',qs3);
qs3['NextLanguage'] <- languageColumn('NextLanguage',qs3);
qs3['FirstLanguage'] <- languageColumn('FirstLanguage',qs3);

# удалим неиспользуемые колонки
qs1$Comment <- NULL
qs1$Timestamp <- NULL
qs2$Timestamp <- NULL

#
qs3$Timestamp <- NULL


qs2['InUA'] <- lapply(qs2['InUA'],function(x){factor(normalizeBool(x))})
qs3['InUA'] <- lapply(qs3['InUA'],function(x){factor(normalizeBool(x))})

qs <- qs3


# на чем начинали ?
funsfl <- function(qs) {
  sfl <- summary(qs[['FirstLanguage']])
  sfl <- sfl[order(sfl)]
  return(sfl[sfl>10])
}
sfl1 <- funsfl(qs1)
sfl1 <- sfl1[-match("другой",names(sfl1))]
sfl2 <- funsfl(qs2)
sfl3 <- funsfl(qs3)

cnames <- intersect(names(sfl2),names(sfl3))
sflm <- matrix(ncol=length(cnames),nrow=2,byrow=TRUE)
colnames(sflm) <- cnames
rownames(sflm) <- c("2011-07","2012-04")
sflm["2011-07",] <- sfl2[cnames]/sum(sfl2)
sflm["2012-04",] <- sfl3[cnames]/sum(sfl3)

if (drawNow) {
  cnames1 <- cnames[8:length(cnames)]
  png(file="sfl.png")
  barplot(sflm[,cnames1],beside=TRUE,col=c("blue","green"),cex.axis=0.8, cex=0.8)
  legend("topleft",c("2011-07","2012-04"),fill=c("blue","green"))
  title("На каком языке вы написали свою первую программу")
  dev.off()
}



# на чем пишут сейчас ?
snl1 <- summaryLangColumn('NowLanguage',qs1)
snl2 <- summaryLangColumn('NowLanguage',qs2)
snl3 <- summaryLangColumn('NowLanguage',qs3)
snl1 <- snl1[snl1>3]
snl2 <- snl2[snl2>3]
snl3 <- snl3[snl3>3]
#  нарисуем картинку
if (drawNow) {
  png(file="snl.png")
  dotchart(snl3)
  title("На каком языке вы пишете для работы сейчас ")
  dev.off()
}

svsnl3 <- snl3
svsnl2 <- snl2
# приведем к долям от общего к-ства
snl1n = sum(snl1)
snl2n = sum(snl2)
snl3n = sum(snl3)
snl1 <- (snl1/snl1n)*100
snl2 <- (snl2/snl2n)*100
snl3 <- (snl3/snl3n)*100
# нам интересно  тольк то, что больше процента
snl1 <- snl1[snl1>1]
snl1 <- snl1[order(snl1)]
snl2 <- snl2[snl2>1]
snl2 <- snl2[order(snl2)]
snl3 <- snl3[snl3>1]
snl3 <- snl3[order(snl3)]


cnames <- intersect(names(snl3),names(snl2))
## сдалаем общую матрицу и выложим на общий график
snlm <- matrix(ncol=length(cnames),nrow=2,byrow=TRUE)
colnames(snlm) <- cnames
rownames(snlm) <- c("2011-07","2012-04") 
#snlm["2010-11",] <- snl1[cnames]
snlm["2011-07",] <- snl2[cnames]
snlm["2012-04",] <- snl3[cnames]
if (drawNow) {
  png(file="slnm.png")
  barplot(snlm,beside=TRUE,cex.names=0.8,legend=TRUE,
          args.legend=list(x="topleft"),
          las=2,
          col=c("blue","green")
  )
  title("Доли языков в сравнении с прошлым опросом")
  dev.off();
}

#
# печатаем изменения по сравнению с прошлым разом
# если вероятность изменения > 90%
pv <- cbind(cnames)
for(l in cnames) {
  pv[l] <- prop.test(c(svsnl3[l],svsnl2[l]),c(snl3n,snl2n))$p.value
}

print(pv[as.numeric(pv)<0.10 & !is.na(as.numeric(pv))])


# на что хотят перейти сейчас ?
sxl <- summaryLangColumn('NextLanguage',qs)
sxl <- sxl[order(sxl)]
sxl<-sxl[sxl>5]
if (drawNow) {
  png(file="sxl.png")
  dotchart(sxl)
  title("Если бы вы начинали сейчас коммерческий проект \n и у вас была бы свобода выбора ...")
  dev.off()
}

#
# Индекс удовлетворенности языком (для немаргинальных):
lct3 <- table(qs3$NowLanguage,qs3$NextLanguage)
lci3 <- array(0,length(rownames(lct3)))
names(lci3) <- rownames(lct3)
for(i in rownames(lct3)) {
  if (i %in% colnames(lct3)) {
    lci3[i]<-lct3[i,i]/sum(lct3[i,])
  }
}
lci3sv <- lci3
lci3 <- lci3[names(svsnl3[svsnl3>15])]
lci3 <- lci3[order(lci3)]


lct2 <- table(qs2$NowLanguage,qs2$NextLanguage)
lci2 <- array(0,length(rownames(lct2)))
names(lci2) <- rownames(lct2)
for(i in rownames(lct2)) {
  if (i %in% colnames(lct2)) {
    lci2[i]<-lct2[i,i]/sum(lct2[i,])
  }
}
lci2sv <- lci2

if (drawNow) {
  png(file="lci.png")
  cnames <- intersect(names(lci3),names(lci2))
  lcim <- matrix(ncol=length(cnames),nrow=2,byrow=TRUE)
  colnames(lcim) <- cnames
  rownames(lcim) <- c("2011-07","2012-04")
  lcim["2011-07",] <- lci2[cnames]
  lcim["2012-04",] <- lci3[cnames]
  barplot(lcim,beside=TRUE, las=2, col=c("blue","green"),cex.name=0.8,
          args.legend=list(x="topleft"))
  title("Индекс привязанности к языкам ...")
  dev.off()
}

languageAfter <- function(lct,snl,name) {
 mgX <- lct[name,]/snl[name]
 mgX <- mgX[mgX>0.01]
 mgX <- mgX[rev(order(mgX))]
}

#
# куда планируюь уйти с C
print("mirgation from C:");
print(languageAfter(lct3, svsnl3, "C"))

#
# куда планируют перейти PHP-ники:
print("mirgation from PHP:");
print(languageAfter(lct3, svsnl3, "PHP"))

print("mirgation from Perl");
print(languageAfter(lct3, svsnl3, "Perl"))

# то-же самое для l=других языков
print("mirgation from Delphi:");
print(languageAfter(lct3, svsnl3, "Pascal/Delphi"))

print("mirgation from 1C:");
print(languageAfter(lct3, svsnl3 ,"1С"))

print("mirgation from Java:");
print(languageAfter(lct3, svsnl3, "Java"))

print("old mirgation from Java:");
print(languageAfter(lct2, svsnl2, "Java"))

print("mirgation from Python");
print(languageAfter(lct3, svsnl3, "Python"))

print("mirgation from C#");
print(languageAfter(lct3, svsnl3 ,"C#"))



# распределение по языкам и опыту работы
lct1 <- table(qs1$NowLanguage,qs1$Experience)
lct2 <- table(qs2$NowLanguage,qs2$ExperienceInProgramming)
lct3 <- table(qs3$NowLanguage,qs3$ExperienceInProgramming)
langPercentage <- function(lct,snl,x) {
   lct[x,]/snl[x]
}


lct2 <- lct2[names(svsnl2[svsnl2>20]),]
lct3 <- lct3[names(svsnl3[svsnl3>20]),]
lct3 <- lct3[,c("< 1","1","2","3","4","5","6","7","8","9","10+")]
#lct <- lct[,c("0","1","2","3","4","5","6","7","8","9","10 и больше")]
lct2 <- lct2[,c("1","2","3","4","5","6","7","8","9","10+")]
#colnames(lct)<-c("0","1","2","3","4","5","6","7","8","9",">10")
plct2 <- langPercentage(lct2,svsnl2,rownames(lct2))
plct3 <- langPercentage(lct3,svsnl3,rownames(lct3))
if (drawNow) {
  png(file="experience1.png")
  #oldpar <- par(mfrow=c(1,2))
  names<-c("C#","Java","C++", "Objective-C")
  barplot(lct3[names,],beside=TRUE,col=rainbow(3))
  legend("topleft",names,fill=rainbow(3))
  title("опыт работы: C#, Java, C++, Objective-C")
  #barplot(plct[names,],beside=TRUE,col=rainbow(3))
  dev.off()
  # и для скрипт-языков
  png(file="experience2.png")
  #oldpar <- par(mfrow=c(1,2))
  names<-c("PHP","Python","Ruby")
  barplot(lct3[names,],beside=TRUE,col=rainbow(3))
  title("Опыт работы: скрипт-языки")
  legend("topleft",names,fill=rainbow(3))
  #barplot(plct[names,],beside=TRUE,col=rainbow(3))
  dev.off()
  #par(oldpar)
}


# какие языки используются как дополнительные
#  (сольем тут данные тех кто может выделить основной язые (al3)
#  и тех кто нет)
sal3_0 <- summary(al3);
sal3_1 <- summary(al3_1);
sal3_2 <- summary(al3_2);
anames <- union(names(sal3_0),names(sal3_1))
anames <- union(anames,names(sal3_2))
sal3_0 <- zeroNames(sal3_0,anames)[anames]
sal3_1 <- zeroNames(sal3_1,anames)[anames]
sal3_2 <- zeroNames(sal3_2,anames)[anames]
sal<-sal3_0+sal3_1+sal3_2
sal<-sal[sal>30]
sal<-sal[order(sal)]
if (drawNow) {
  png(file="sal.png")
  dotchart(sal, cex=0.8)
  title("Какие дополнительные языки вы используете для работы ?")
  dev.off()
}


# и для развлечения
spl <- summary(pl3)
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
ew3 <- summary(qs3[['ExperienceInProgramming']])[c("< 1", "1","2","3","4","5","6","7","8","9","10+")]
# сольем <1 и 1, что-бы было как в пролый раз.  А в следующем году начнем разделять
ew3["1"] = ew3["< 1"]+ew3["1"]
ew3 <- ew3/sum(ew3)
# по сравнению с прошлым опросом
ew2 <- summary(qs2[['ExperienceInProgramming']])[c("1","2","3","4","5","6","7","8","9","10+")]
ew2 <- ew2/sum(ew2)
# и позапрошлым
ew1 <- summary(qs1[['Experience']])
ew1["1"]=ew1["1"]+ew1["2"];
ew1["10+"]<-ew1["10 и больше"]
ew1 <- ew1[c("1","2","3","4","5","6","7","8","9","10+")]
ew1 <- ew1/sum(ew1)
## сдалаем общую матрицу и выложим на общий график
ew <- matrix(ncol=10,nrow=3,byrow=TRUE)
colnames(ew) <- names(ew2)
rownames(ew) <- c("2010-11","2011-07","2012-04")
ew["2010-11",] <- ew1
ew["2011-07",] <- ew2
ew["2012-04",] <- ew3[colnames(ew)]
if (drawNow) {
  png(file="ew.png")
  barplot(ew,beside=TRUE,legend=TRUE,args.legend=c(x=32))
  title("Распределение опыта работы программистом")
  dev.off()
}


#на чем пишут люи старше 50 ?
t <- table(qs$Age,qs$NowLanguage)
x <- t["> 50",]
x <- x[x>0]
x <- x[rev(order(x))]
print("languages for people after 50")
print(x)
# а 40-50 ?
x <- t["[40,50)",]
x <- x[x>0]
x <- x[rev(order(x))]
print("languages for people in [40,50)")
print(x)

en <- c("< 1", "1","2","3","4","5","6","7","8","9","10+")
t2<-table(qs$ExperienceInLanguage,qs$ExperienceInProgramming)[en,en]
if (drawNow) {
  png(file="el.png")
  barplot(t2,col=rainbow(11),legend=TRUE,args.legend=list(x=10,y=450))
  title("Опыт работы программистом/на выбранном языке")
  dev.off()
}



## опыт работы в диаспоре и приехавшиз из украины
stu <- table(qs$InUA,qs$ExperienceInProgramming)
stu <- stu[,en]
colnames(stu)<-en
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
      "Pascal/Delphi", "JavaScript", "ActionScript","F#",
      "Perl", "Haskell", "Lisp", "1С", "Basic", "Erlang",
      "DBase", "PL/SQL", "Asm", "Lua", "Fortran", "Cobol","Groovy","Apex")

svsnl2 <- zeroNames(svsnl2,names)
snl2 <- zeroNames(snl2,names)
svsnl3 <- zeroNames(svsnl3,names)
snl3 <- zeroNames(snl3,names)

rxsnl2p <- snl2[names]
rxsnl3p <- snl3[names]

rxsnl3 <- svsnl3[names]

rxsfl <- sfl3[names]

sxl <- zeroNames(sxl,names)
rxsxl <- sxl[names]
rxsxlp <- (sxl/sum(sxl))[names]*100


splf <- summary(pl)
splf <- zeroNames(splf,names)
rxspl <- splf[names]

salf <- sal
salf <- zeroNames(salf,names)
rxsal <- salf[names]

diff = rxsnl3p-rxsnl2p

rxlci <- lcisv[names]


res<-cbind(rxsnl3p,diff,rxsnl3,rxsxlp,rxsxl,rxsal,rxspl,rxlci)

res<- res[rev(order(rxsnl3)),]

for(l in names) {
  if (is.na(pv[l]) ||  abs(as.numeric(pv[l]))>0.10) {
    res[l,'diff'] = NA
  }
}

# и показать финальную таблцу, отсортированную по доле рынка
print(res);

# взять данные ДОУ и rabota.ua по вакансиям
v_dou=read.csv(file="dou_vacancies.csv",head=TRUE)
vnames <- v_dou$Language
v_dou <- as.data.frame(t(v_dou[,-1]))
colnames(v_dou) <- vnames
v_ra=read.csv(file="rabotaua_vacancies.csv",head=TRUE)
vnames <- v_ra$Language
v_ra <- as.data.frame(t(v_ra[,-1]))
colnames(v_ra) <- vnames

v <- merge(v_dou,v_ra,all=TRUE)
v[2,] <- zeroNames(v[2,],colnames(v))
v <- v[,c("Java","C#","PHP","C++","Python","Ruby","JavaScript","Objective-C","1C","PL/SQL")]
rownames(v) <- c("DOU","rabota.ua")

# привести к относительному виду
v[1,] <- v[1,]/sum(v[1,])
v[2,] <- v[2,]/sum(v[2,])

if (drawNow) {
  png(file="vacancies.png")
  barplot(as.matrix(v),beside=TRUE,legend=TRUE,cex.names=0.8,las=2)
  dev.off()
}


