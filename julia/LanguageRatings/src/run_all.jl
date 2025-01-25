
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

    lfh = freqHistory(:NowLanguage, dfs..., limit=15)
    LanguageRatings.freqHistoryBarPlot(lfh; fname="../../2025_01/NowLanguageHistory", nYears=2)


    # How specialization is changed
    glc = LanguageRatings.freqHistory(:Specialization, dfs..., nYears=3, filterExpr=(x -> !ismissing(x.Specialization) && !(x.Specialization in ["GameDev","QA","Other","Embedded"]) ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/Specializations", nYears=3)
    
    # hostory by specialization:
    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Backend") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2024_01/NowLanguageBackendHistory", nYears=3)
    
    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Frontend") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2024_01/NowLanguageFrontendHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=15, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Full Stack") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2024_01/NowLanguageFullStackHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Mobile") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2024_01/NowLanguageMobileHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Data Analysis") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2024_01/NowLanguageDataAnalysisHistory", nYears=3)

    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=3, limit=10, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "DevOps") ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="../../2025_01/NowLanguageDevOpsHistory", nYears=3)

    # Platforms
    df = dfs[1]
    glc = LanguageRatings.multi_platform_freq(df, :Platforms)
    LanguageRatings.freqBarPlot(glc, "Платформи", fname="../../2024_01/Platforms")

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
    LanguageRatings.freqBarPlot(ls, "Яку мову програмування плануєтк вивчити", fname="../../2024_01/LearnLanguage", limit=23)

    # Additional Languages
    af = LanguageRatings.multi_language_freq(df, :AdditionalLanguages, limit=20, normalizeFun=LanguageRatings.normalize_language_2023)
    LanguageRatings.freqBarPlot(af, "Додаткові мови", fname="../../2024_01/AdditionalLanguages")

    # Final table
  
    # experience
    ft=LanguageRatings.plot_experience_freq_by_lang(df, ["JavaScript","TypeScript", "Python", "Java", "C#","PHP"], title="Досвід у програмуванні", fname="../../2024_01/ExpirienceInProgramming")
    

    
end