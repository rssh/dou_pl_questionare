d <- read.csv("data-2.csv",stringsAsFactors = FALSE)
d1 <- d[c(1,2,3,4,32,33,34,35,36,37,38,41,42,43,44,45)]
colnames(d1) <- c("Timestamp","FirstLanguage","MainLanguage","NowLanguage",
                  "NowLanguages2", "AdditionalLanguages1", "NextLanguage",
                  "PetProjectsLanguages", "Learn" , "LearnLanguage",
                  "LearnWay", "ExperienceInProgrammingYears", "ExperienceInLanguageYears",
                  "AgeYears", "InUA", "InPrev")
d1$AdditionalLanguages1 <- str_replace_all(d1$AdditionalLanguages1,";",",")
d1$PetProjectsLanguages <- str_replace_all(d1$PetProjectsLanguages,";",",")
write.csv(d1,"2021_01_t.csv", row.names=FALSE)


