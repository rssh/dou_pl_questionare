
function prepare_all(baseDir::String = "../..")
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
    return [df2024, df2023, df2022, df2021, df2020, df2019, df2018, df2017, df2016, df2015, df2014, df2013]
end

function run_all(baseDir::String = "../..")

    dfs = prepare_all()
    lfh = freqHistory(:NowLanguage, dfs..., limit=15)

    # How specialization is changed
    glc = LanguageRatings.freqHistory(:Specialization, dfs..., nYears=2, filterExpr=(x -> !ismissing(x.Specialization) && !(x.Specialization in ["GameDev","QA","Other"]) ))
    LanguageRatings.freqHistoryBarPlot(glc; fname="Specializations", nYears=2)
    
    # hostory by specialization:
    # Backend:
    glc = LanguageRatings.freqHistory(:NowLanguage, dfs..., nYears=2, filterExpr=(x -> !ismissing(x.Specialization) && (x.Specialization == "Backend") ))
    
    

end