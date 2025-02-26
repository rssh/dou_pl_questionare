
function prepare_all(baseDir::String = "../..")
    df2025 = LanguageRatings.prepare_dataset_2025("$baseDir/2025_01/dec2024_programming_languages.csv")
    df2024 = LanguageRatings.prepare_dataset_2024("$baseDir/2024_01/lang-rating-dec2023.csv")
    df2023 = LanguageRatings.prepare_dataset_2023("$baseDir/2023_01/lang-rating-2023.csv")
    df2022 = LanguageRatings.prepare_dataset_2022("$baseDir/2022_01/lang-2022-data.csv")
    df2021 = LanguageRatings.prepare_dataset_2021("$baseDir/2021_01/q12.csv")
    df2020 = LanguageRatings.prepare_dataset_2020("$baseDir/2020_01/q11.csv")
    df2019 = LanguageRatings.prepare_dataset_2019("$baseDir/2019_01/q10.csv")
    df2018 = LanguageRatings.prepare_dataset_2018("$baseDir/2018_01/q9.csv")
    df2017 = LanguageRatings.prepare_dataset_2017("$baseDir/2017_01/questionnaire8_cleaned.csv")
    df2016 = LanguageRatings.prepare_dataset_2016("$baseDir/2016_01/questionnaire7_cleaned.csv")
    df2015 = LanguageRatings.prepare_dataset_2015("$baseDir/2015_01/questionnaire6_cleaned.csv")
    df2014 = LanguageRatings.prepare_dataset_2014("$baseDir/2014_01/questionnaire5_cleaned.csv")
    df2013 = LanguageRatings.prepare_dataset_2013("$baseDir/2013_01/questionnaire4_cleaned.csv")
    return [df2025, df2024, df2023, df2022, df2021, df2020, df2019, df2018, df2017, df2016, df2015, df2014, df2013]
end

function run_all(baseDir::String = "../..")

    dfs = prepare_all()

    df = dfs[1]
    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, barrier=10)
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування", fname="../../2025_01/NowLanguage", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> x.Categories == "SE"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/SE", fname="../../2025_01/NowLanguageSE", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> x.Categories == "Analyst"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/Analyst", fname="../../2025_01/NowLanguageAnalyst", limit=23)

    lfh = freqHistory(:NowLanguage, dfs..., limit=15)
    LanguageRatings.freqHistoryBarPlot(lfh; fname="../../2025_01/NowLanguageHistory", nYears=2)

    cf = freqtable_categories(df ; fname="../../2025_01/Categories")

    # How specialization is changed
    glc = LanguageRatings.freqHistory(:Specialization, dfs..., nYears=3, filterExpr=(x -> !ismissing(x.Specialization) && !(x.Specialization in ["GameDev","QA","Other","Embedded"]) ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/Specializations", nYears=3)
    
    # hostory by specialization:
    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Backend") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/NowLanguageBackendHistory", nYears=3)
    
    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Frontend") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/NowLanguageFrontendHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Full Stack") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/NowLanguageFullStackHistory", nYears=4)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Mobile") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/NowLanguageMobileHistory", nYears=4)

    # desktop is new, so not historu
    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> !ismissing(x.Specialization) && x.Specialization == "Desktop"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/Desktop", fname="../../2025_01/NowLanguageDesktop", limit=23)


    #glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Data Analysis") ))
    #LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/NowLanguageDataAnalysisHistory", nYears=3)

    #in 2024 this was in categories
    # glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "DevOps") ))
    #LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/NowLanguageDevOpsHistory", nYears=3)

    # Platforms
    df = dfs[1]
    glc = LanguageRatings.multi_platform_freq(df, :Platforms)
    LanguageRatings.freqBarPlot(glc, "Платформи", fname="../../2024_01/Platforms")

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Web" in x.Platforms) ))
    LanguageRatings.freqHistoryBarPlot(glc; title="NowLanguage/Platform/Web", fname="../../2025_01/NowLanguagePlatformWeb", nYears=4)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Desktop" in x.Platforms) ))
    LanguageRatings.freqHistoryBarPlot(glc; title="NowLanguage/Platform/Desktop", fname="../../2025_01/NowLanguagePlatformDesktop", nYears=4)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Mobile cross-platform" in x.Platforms) ))
    LanguageRatings.freqHistoryBarPlot(glc; title="NowLanguage/Platform/MobileCross", fname="../../2025_01/NowLanguagePlatformMobileCross", nYears=4)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Mobile Android" in x.Platforms) ))
    LanguageRatings.freqHistoryBarPlot(glc; title="NowLanguage/Platform/MobileAndroid", fname="../../2025_01/NowLanguagePlatformMobileAndroid", nYears=4)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Mobile iOS" in x.Platforms) ))
    LanguageRatings.freqHistoryBarPlot(glc; title="NowLanguage/Platform/Mobile/IOS", fname="../../2025_01/NowLanguagePlatformMobileIOS", nYears=4)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Microcontrollers / Embedded / IoT" in x.Platforms) ))
    LanguageRatings.freqHistoryBarPlot(glc; title="NowLanguage/Platform/Embedded", fname="../../2024_01/NowLanguagePlatformEmbedded", nYears=3)


    # Specialization
    glc = LanguageRatings.language_freq(df, :Specialization, filterExpr=(x -> !ismissing(x.Specialization) ))
    LanguageRatings.freqBarPlot(glc, "Спеціалізація", fname="../../2025_01/Specialization")

    # Specialization freqHistory

    s1 = freqtable(map(x -> x=="Desktop" ? "Other" : x == "Embedded" ? "Other" : x, filter(x -> !ismissing(x), df.Specialization)))
    s1 = s1/sum(s1)
    ds1 = DataFrame(names=names(s1,1), values=s1)
    s2 = freqtable(map(x -> x=="Desktop" ? "Other" : x, filter(x -> !ismissing(x) && x!="QA" && x!="DevOps" && x!="Data Analysis", dfs[2].Specialization)))
    s2 = s2/sum(s2)
    ds2 = DataFrame(names=names(s2,1), values=s2)
    s3 = freqtable(map(x -> x=="Embedded" ? "Other" : x, filter(x-> !ismissing(x) && x!="Data Analysis"  && x!="DevOps" && x!="QA", dfs[3].Specialization ) ))
    s3 = s3/sum(s3)
    ds3 = DataFrame(names=names(s3,1), values=s3)
    s4 = freqtable(map(x -> x=="Embedded" || x=="GameDev" || x=="Desktop" ? "Other" : x, filter(x-> !ismissing(x) && x!="Data Analysis"  && x!="DevOps" && x!="QA", dfs[4].Specialization ) ))
    s4 = s4/sum(s4)
    ds4 = DataFrame(names=names(s4,1), values=s4)
    sh = outerjoin(ds4,ds3,ds2,ds1,on=:names, makeunique=true)


    # Next Language.
    glc = LanguageRatings.multi_language_freq(df, :NextLanguage)
    LanguageRatings.freqBarPlot(glc, "NextLanguage", fname="../../2025_01/NextLanguage", limit=19)


    # Next Language By Specialization
    glc = LanguageRatings.multi_language_freq(df, :NextLanguage, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Backend") ))
    LanguageRatings.freqBarPlot(glc, "NextLanguage/Backend", fname="../../2025_01/NextLanguageBackend", limit=15)

    glc = LanguageRatings.multi_language_freq(df, :NextLanguage, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Frontend") ))
    LanguageRatings.freqBarPlot(glc, "NextLanguage/Frontend", fname="../../2025_01/NextLanguageFrontend", limit=10)

    glc = LanguageRatings.multi_language_freq(df, :NextLanguage, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Full Stack") ))
    LanguageRatings.freqBarPlot(glc, "NextLanguage/FullStack", fname="../../2025_01/NextLanguageFullStack", limit=20)

    ## glc = LanguageRatings.multi_language_freq(df, :NextLanguage, filterExpr=(x -> !ismissing(x.Platforms) && ("Microcontrollers / Embedded / IoT" in x.Platforms) ))
    glc = LanguageRatings.multi_language_freq(df, :NextLanguage, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Embedded") ))   
    LanguageRatings.freqBarPlot(glc, "NextLanguage/Embedded", fname="../../2025_01/NextLanguageEmbedded", limit=10)

    glc = LanguageRatings.multi_language_freq(df, :NextLanguage, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Mobile") ))   
    LanguageRatings.freqBarPlot(glc, "NextLanguage/Mobile", fname="../../2025_01/NextLanguageMobile", limit=10)
 

    # Satisfaction index
    si = LanguageRatings.satisfaction_index2024(df, limit=19)
    LanguageRatings.plot_index(si, fname="../../2025_01/SatisfactionIndex")

    # Open Source
    glc = LanguageRatings.multi_language_freq(df, :PetProjectLanguages, limit=20) 
    LanguageRatings.freqBarPlot(glc, "PetProjectLanguages", fname="../../2025_01/PetProjectLanguages", limit=19)

    glc = LanguageRatings.multi_language_freq(df, :OpenSourceLanguageNow, limit=20)
    LanguageRatings.freqBarPlot(glc, "OpenSourceLanguagesNow", fname="../../2025_01/OpenSourceNowLanguages", limit=19)


    # Learn Language
    ls = LanguageRatings.language_freq(df,:LearnLanguage, limit=30, barrier=10)
    LanguageRatings.freqBarPlot(ls, "Яку мову програмування плануєтк вивчити", fname="../../2025_01/LearnLanguage", limit=23)

    # Additional Languages
    af = LanguageRatings.multi_language_freq(df, :AdditionalLanguages, limit=20, normalizeFun=LanguageRatings.normalize_language_2023)
    LanguageRatings.freqBarPlot(af, "Додаткові мови", fname="../../2025_01/AdditionalLanguages")

    ## by specialization
    af = LanguageRatings.multi_language_freq(df, :AdditionalLanguages, limit=20, normalizeFun=LanguageRatings.normalize_language_2023, 
               filterExpr=(x -> !ismissing(x.Specialization) && x.Specialization == "Desktop" ))


    # Final table
  
    # First language for 1-st year interns
    glc=LanguageRatings.freqHistory(:FirstLanguage, dfs..., nYears=4, limit=10, filterExpr=(x -> !ismissing(x.FirstLanguage) && !ismissing(x.ExperienceInProgrammingYears) && x.ExperienceInProgrammingYears <= 1 ))


    # experience
    ft=LanguageRatings.plot_experience_freq_by_lang(df, ["JavaScript","TypeScript", "Python", "Java", "C#","PHP", "Go"], title="Досвід у програмуванні", fname="../../2024_01/ExpirienceInProgramming")

    # frameworks:
    bckTypeScript = LanguageRatings.multi_language_freq(df, :FrameworksDevelopment, filterExpr=(x ->
             !ismissing(x.Specialization) && !ismissing(x.NowLanguage) && 
             x.NowLanguage=="TypeScript" && x.Specialization=="Backend" ), limit=10)

    
end