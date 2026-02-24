
function prepare_all(baseDir::String = "../..")
    df2026 = LanguageRatings.prepare_dataset_2026("$baseDir/2026_01/dec2025_programming_languages.csv")
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
    allDfs = [df2026, df2025, df2024, df2023, df2022, df2021, df2020, df2019, df2018, df2017, df2016, df2015, df2014, df2013]
    for df in allDfs
        if hasproperty(df, :Specialization) || hasproperty(df, :Categories)
            add_extended_specialization!(df)
        end
    end
    return allDfs
end

function run_all(baseDir::String = "../..")

    dfs = prepare_all()

    df = dfs[1]
    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, barrier=10)
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування", fname="../../2026_01/NowLanguage", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> x.Categories == "SE"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/SE", fname="../../2026_01/NowLanguageSE", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=10, filterExpr = (x -> x.Categories == "Analyst"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/Analyst", fname="../../2026_01/NowLanguageAnalyst", limit=10)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> x.Categories == "DS/ML/AI"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/[DS/ML/AI]", fname="../../2026_01/NowLanguageDSMLAI", limit=10)


    lfh = LanguageRatings.freqHistory(:NowLanguage, dfs..., limit=15)
    LanguageRatings.freqHistoryBarPlot(lfh; fname="../../2026_01/NowLanguageHistory", nYears=5)

    cf = freqtable_categories(df ; fname="../../2026_01/Categories")
    cf_df = DataFrame(:language => names(cf,1), :freq => cf[:] ./ sum(cf[:]))
    freqBarPlot(cf_df, "Категорії респондентів")
    png("../../2026_01/Categories")

    # How specialization is changed
    glc = LanguageRatings.freqHistory(:Specialization, dfs..., nYears=4, filterExpr=(x -> !ismissing(x.Specialization) && !(x.Specialization in ["GameDev","QA","Other","Data Analysis","DevOps"]) ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/Specializations", nYears=4)
    
    # hostory by specialization:
    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Backend") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageBackendHistory", nYears=3)
    
    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=5, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Frontend") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageFrontendHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=4, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Full Stack") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageFullStackHistory", nYears=4)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Mobile") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageMobileHistory", nYears=4)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=2, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Desktop") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageDesktopHistory", nYears=2)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=2, limit=10, filterExpr=(x -> !ismissing(x.ExtendedSpecialization) && (x.ExtendedSpecialization == "Embedded") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageEmbeddedHistory", nYears=2)

    # NowLanguage by specialization
    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> !ismissing(x.Specialization) && x.Specialization == "Backend"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/Backend", fname="../../2026_01/NowLanguageBackend", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> !ismissing(x.Specialization) && x.Specialization == "Frontend"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/Frontend", fname="../../2026_01/NowLanguageFrontend", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> !ismissing(x.Specialization) && x.Specialization == "Full Stack"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/FullStack", fname="../../2026_01/NowLanguageFullStack", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> !ismissing(x.Specialization) && x.Specialization == "Mobile"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/Mobile", fname="../../2026_01/NowLanguageMobile", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> !ismissing(x.Specialization) && x.Specialization == "Desktop"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/Desktop", fname="../../2026_01/NowLanguageDesktop", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> !ismissing(x.Specialization) && x.Specialization == "Embedded"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/Embedded", fname="../../2026_01/NowLanguageEmbedded", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> x.Categories == "DevOps/SRE"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/DevOps", fname="../../2026_01/NowLanguageDevOps", limit=23)

    ls = LanguageRatings.language_freq(df,:NowLanguage, limit=30, filterExpr = (x -> x.Categories == "QA"))
    LanguageRatings.freqBarPlot(ls, "Основна мова програмування/QA", fname="../../2026_01/NowLanguageQA", limit=23)


    # Categories dimension (available since 2025, nYears=2)
    # Categories history
    ch = LanguageRatings.freqtable_categories_history(dfs..., nYears=2, fname="../../2026_01/CategoriesHistory")
    LanguageRatings.freqHistoryBarPlot(ch; fname="../../2026_01/CategoriesHistory", nYears=2, column="Category")

    # ExtendedSpecialization: unified view (SE specializations + non-SE categories)
    # Frequency chart for current year
    ls = LanguageRatings.language_freq(df, :ExtendedSpecialization, filterExpr=(x -> !ismissing(x.ExtendedSpecialization) && x.ExtendedSpecialization != "Other" && x.ExtendedSpecialization != "GameDev"))
    LanguageRatings.freqBarPlot(ls, "Розширена спеціалізація", fname="../../2026_01/ExtendedSpecialization")

    # ExtendedSpecialization history (QA/DevOps/DS available since 2023)
    glc = LanguageRatings.freqHistory(:ExtendedSpecialization, dfs..., nYears=3, filterExpr=(x -> !ismissing(x.ExtendedSpecialization) && !(x.ExtendedSpecialization in ["GameDev","Other"])))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/ExtendedSpecializationHistory", nYears=3)

    # NowLanguage history by ExtendedSpecialization (QA, DevOps, DS/ML/AI)
    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.ExtendedSpecialization) && x.ExtendedSpecialization == "QA"))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageQAHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.ExtendedSpecialization) && x.ExtendedSpecialization == "DevOps"))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageDevOpsHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.ExtendedSpecialization) && x.ExtendedSpecialization == "DS/ML/AI"))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageDSMLAIHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=2, limit=15, filterExpr=(x -> !ismissing(x.ExtendedSpecialization) && x.ExtendedSpecialization == "Analyst"))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NowLanguageAnalystHistory", nYears=2)

    # Platforms (single-year only: 2026 changed from multi-select to single-select)
    df = dfs[1]
    glc = LanguageRatings.multi_platform_freq(df, :Platforms)
    mainLimit = 6
    if size(glc,1) > mainLimit
        otherFreq = sum(glc[mainLimit+1:end, :freq])
        otherCnt = sum(glc[mainLimit+1:end, :cnt])
        glc = glc[1:mainLimit, :]
        push!(glc, (language="Other", cnt=otherCnt, freq=otherFreq))
    end
    LanguageRatings.freqBarPlot(glc, "Платформи", fname="../../2026_01/Platforms")

    # Platform-by-language: single-year only (2026 changed Platforms from multi-select to single-select, history not comparable)
    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Web" in x.Platforms) && !ismissing(x.ExtendedSpecialization) && x.ExtendedSpecialization == "Backend"))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/Web/Backend", fname="../../2026_01/NowLanguagePlatformWebBackend", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Web" in x.Platforms) && !ismissing(x.ExtendedSpecialization) && x.ExtendedSpecialization == "Frontend"))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/Web/Frontend", fname="../../2026_01/NowLanguagePlatformWebFrontend", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Web" in x.Platforms) && !ismissing(x.ExtendedSpecialization) && x.ExtendedSpecialization == "Full Stack"))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/Web/FullStack", fname="../../2026_01/NowLanguagePlatformWebFullStack", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Desktop" in x.Platforms) ))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/Desktop", fname="../../2026_01/NowLanguagePlatformDesktop", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Mobile cross-platform" in x.Platforms) ))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/MobileCross", fname="../../2026_01/NowLanguagePlatformMobileCross", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Mobile Android" in x.Platforms) ))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/MobileAndroid", fname="../../2026_01/NowLanguagePlatformMobileAndroid", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Mobile iOS" in x.Platforms) ))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/MobileIOS", fname="../../2026_01/NowLanguagePlatformMobileIOS", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Microcontrollers / Embedded / IoT" in x.Platforms) && x.Categories == "SE"))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/Embedded/SE", fname="../../2026_01/NowLanguagePlatformEmbeddedSE", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Microcontrollers / Embedded / IoT" in x.Platforms) && x.Categories != "SE"))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/Embedded/Non-SE", fname="../../2026_01/NowLanguagePlatformEmbeddedNonSE", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Platforms) && ("Voice (IVR)" in x.Platforms || "Multimedia (VoiceBots ChatBots)" in x.Platforms) ))
    LanguageRatings.freqBarPlot(ls, "NowLanguage/Platform/Voice", fname="../../2026_01/NowLanguagePlatformVoice", limit=10)

    # Specialization (SE only; non-SE have missing Specialization after normalization)
    glc = LanguageRatings.language_freq(df, :Specialization, filterExpr=(x -> !ismissing(x.Specialization) ))
    LanguageRatings.freqBarPlot(glc, "Спеціалізація (SE)", fname="../../2026_01/Specialization")

    # Specialization freqHistory

    s1 = freqtable(map(x -> x=="Desktop" ? "Other" : x == "Embedded" ? "Other" : x, filter(x -> !ismissing(x), df.Specialization)))
    s1 = s1/sum(s1)
    ds1 = DataFrame(names=names(s1,1), values=s1)
    s2 = freqtable(map(x -> x=="Desktop" ? "Other" : x == "Embedded" ? "Other" : x, filter(x -> !ismissing(x), dfs[2].Specialization)))
    s2 = s2/sum(s2)
    ds2 = DataFrame(names=names(s2,1), values=s2)
    s3 = freqtable(map(x -> x=="Desktop" ? "Other" : x, filter(x -> !ismissing(x) && x!="QA" && x!="DevOps" && x!="Data Analysis", dfs[3].Specialization)))
    s3 = s3/sum(s3)
    ds3 = DataFrame(names=names(s3,1), values=s3)
    s4 = freqtable(map(x -> x=="Embedded" ? "Other" : x, filter(x-> !ismissing(x) && x!="Data Analysis"  && x!="DevOps" && x!="QA", dfs[4].Specialization ) ))
    s4 = s4/sum(s4)
    ds4 = DataFrame(names=names(s4,1), values=s4)
    s5 = freqtable(map(x -> x=="Embedded" || x=="GameDev" || x=="Desktop" ? "Other" : x, filter(x-> !ismissing(x) && x!="Data Analysis"  && x!="DevOps" && x!="QA", dfs[5].Specialization ) ))
    s5 = s5/sum(s5)
    ds5 = DataFrame(names=names(s5,1), values=s5)
    sh = outerjoin(ds5,ds4,ds3,ds2,ds1,on=:names, makeunique=true)


    # Next Language.
    glc = LanguageRatings.multi_language_freq(df, :NextLanguage)
    LanguageRatings.freqBarPlot(glc, "NextLanguage", fname="../../2026_01/NextLanguage", limit=19)


    # Next Language By Specialization
    glc = LanguageRatings.multi_freq_history(:NextLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Backend") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NextLanguageBackend", nYears=3)

    glc = LanguageRatings.multi_freq_history(:NextLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Frontend") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NextLanguageFrontend", nYears=3)

    glc = LanguageRatings.multi_freq_history(:NextLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Full Stack") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NextLanguageFullStack", nYears=3)

    glc = LanguageRatings.multi_freq_history(:NextLanguage, dfs..., nYears=2, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Embedded") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NextLanguageEmbedded", nYears=2)

    glc = LanguageRatings.multi_freq_history(:NextLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Mobile") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/NextLanguageMobile", nYears=3)
 

    # Satisfaction index
    si = LanguageRatings.satisfaction_index2024(df, limit=19)
    LanguageRatings.plot_index(si, fname="../../2026_01/SatisfactionIndex")

    # Open Source
    glc = LanguageRatings.multi_language_freq(df, :PetProjectLanguages, limit=20) 
    LanguageRatings.freqBarPlot(glc, "PetProjectLanguages", fname="../../2026_01/PetProjectLanguages", limit=19)

    # OpenSourceLanguageNow not in 2026 questionnaire (commit question was dropped)
    #glc = LanguageRatings.multi_language_freq(df, :OpenSourceLanguageNow, limit=20)
    #LanguageRatings.freqBarPlot(glc, "OpenSourceLanguagesNow", fname="../../2026_01/OpenSourceNowLanguages", limit=19)


    # Learn Language
    ls = LanguageRatings.language_freq(df,:LearnLanguage, limit=30, barrier=10)
    LanguageRatings.freqBarPlot(ls, "Яку мову програмування плануєтк вивчити", fname="../../2026_01/LearnLanguage", limit=23)

    # Additional Languages
    af = LanguageRatings.multi_language_freq(df, :AdditionalLanguages, limit=20, normalizeFun=LanguageRatings.normalize_language_2023)
    LanguageRatings.freqBarPlot(af, "Додаткові мови", fname="../../2026_01/AdditionalLanguages")

    ## by specialization
    af = LanguageRatings.multi_language_freq(df, :AdditionalLanguages, limit=20, normalizeFun=LanguageRatings.normalize_language_2023, 
               filterExpr=(x -> !ismissing(x.Specialization) && x.Specialization == "Desktop" ))


    # Learn Language History
    glc = LanguageRatings.freqHistory(:LearnLanguage, dfs..., nYears=4, limit=15)
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/LearnLanguageHistory", nYears=4)

    # Specialization History
    sh = LanguageRatings.freqtable_specialization_history(dfs..., nYears=4, fname="../../2026_01/SpecializationHistory")

    # First language for 1-st year interns
    glc=LanguageRatings.freqHistory(:FirstLanguage, dfs..., nYears=4, limit=10, filterExpr=(x -> !ismissing(x.FirstLanguage) && !ismissing(x.ExperienceInProgrammingYears) && x.ExperienceInProgrammingYears <= 1 ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/FirstLanguageNewPeople", nYears=4)

    # First language history (all respondents)
    glc=LanguageRatings.freqHistory(:FirstLanguage, dfs..., nYears=4, limit=10)
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2026_01/FirstLanguageHistory", nYears=4)

    # Final table
    ft = LanguageRatings.final_table(dfs[1], dfs[2], fname="../../2026_01/FinalTable")

    # Employment
    ls = LanguageRatings.language_freq(df, :Employment)
    LanguageRatings.freqBarPlot(ls, "Зайнятість", fname="../../2026_01/Employment")

    # NowLanguage by Employment (only groups with enough respondents)
    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Employment) && x.Employment == "Працюю в GameDev"))
    LanguageRatings.freqBarPlot(ls, "Основна мова/GameDev", fname="../../2026_01/NowLanguageGameDev", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Employment) && x.Employment == "Працюю в DefTech (MilTech)"))
    LanguageRatings.freqBarPlot(ls, "Основна мова/DefTech", fname="../../2026_01/NowLanguageDefTech", limit=10)

    ls = LanguageRatings.language_freq(df, :NowLanguage, limit=10, filterExpr=(x -> !ismissing(x.Employment) && startswith(x.Employment, "Працюю НЕ в ІТ")))
    LanguageRatings.freqBarPlot(ls, "Основна мова/Не-ІТ", fname="../../2026_01/NowLanguageNonIT", limit=10)

    # experience
    ft=LanguageRatings.plot_experience_freq_by_lang(df, ["JavaScript","TypeScript", "Python", "Java", "C#","PHP", "Go"], title="Досвід у програмуванні", fname="../../2026_01/ExpirienceInProgramming")

    # frameworks: not in 2026 questionnaire
    #bckTypeScript = LanguageRatings.multi_language_freq(df, :FrameworksDevelopment, filterExpr=(x ->
    #         !ismissing(x.Specialization) && !ismissing(x.NowLanguage) &&
    #         x.NowLanguage=="TypeScript" && x.Specialization=="Backend" ), limit=10)


end