using LanguageRatings
using Test

@testset "LanguageRating.jl" begin
    # Write your tests here.

    dfs = LanguageRatings.prepare_all("../../..")

    df2023 = dfs[1]
 
    @test df2023.NowLanguage[2] == "C#"

    nowLanguages2023 = LanguageRatings.language_freq(df2023, :NowLanguage)

    @test nowLanguages2023.language[1] == "JavaScript"

    df2022 = dfs[2]

    @test df2022.NowLanguage[2] == "C#"

    nowLanguages2022 = LanguageRatings.language_freq(df2022, :NowLanguage)

    df2021 = dfs[3]

    @test df2021.NowLanguage[2] == "C#"

    @test begin
        mlc = LanguageRatings.multi_language_freq(df2023, :AdditionalLanguages)
        size(mlc)[1] > 0
    end
end


