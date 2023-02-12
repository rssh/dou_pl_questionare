
function prepare_all(baseDir::String = "../..")
    df2023 = LanguageRatings.prepare_dataset_2023("$baseDir/2023_01/lang-rating-2023.csv")
    df2022 = LanguageRatings.prepare_dataset_2022("$baseDir/2022_01/lang-2022-data.csv")
    df2021 = LanguageRatings.prepare_dataset_2021("$baseDir/2021_01/q12.csv")
    df2020 = LanguageRatings.prepare_dataset_2020("$baseDir/2020_01/q11.csv")
    df2019 = LanguageRatings.prepare_dataset_2019("$baseDir/2019_01/q10.csv")
    df2018 = LanguageRatings.prepare_dataset_2018("$baseDir/2018_01/q9.csv")
    return [df2023, df2022, df2021, df2020, df2019, df2018]
end

function run_all(baseDir::String = "../..")

    dfs = prepare_all()
    lfh = languageFreqHistory(:NowLanguage, dfs..., limit=15)

end