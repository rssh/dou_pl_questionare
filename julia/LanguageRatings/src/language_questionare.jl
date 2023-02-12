
 
 #
 # Define common dataset 
 #

struct LanguageQuestionare 
    label :: String
    commonData :: DataFrame
    originDF :: DataFrame
end;


function prepare_dataset_2023(fname::String = "../../2023_01/lang-rating-2023.csv")::DataFrame
    df = CSV.read(fname, DataFrame, delim=";")
    rename!(df,[
        names(df)[25]=>"FirstLanguage",
        names(df)[26]=>"NowLanguage",
        names(df)[27]=>"ExperienceLanguage",
        names(df)[28]=>"AdditionalLanguages",
        names(df)[29]=>"Platforms"
    ])
    # ask only developers
    filter!( :NowLanguage => x -> !ismissing(x), df)
    categorize_dataset!(df)
end;

function prepare_platform(x::Union{Missing,String}, allPlatforms::Set{String})::Array{String}
    if ismissing(x)
        return []
    else
        variants = map(rstrip,map(lstrip,split(x,",")))
        union!(allPlatforms, variants)
        return variants
    end
end


function prepare_dataset_2022(fname::String = "../../2022_01/lang-2022-data.csv")::DataFrame
    df = CSV.read(fname, DataFrame, delim=";")
    rename!(df,[
        names(df)[32]=>"FirstLanguage",
        "Основна мова програмування"=>"NowLanguage",
        names(df)[34]=>"ExperienceLanguage",
        names(df)[36]=>"AdditionalLanguages",
        names(df)[37]=>"Platforms"
    ])
    filter!( :NowLanguage => x -> !ismissing(x), df)
    categorize_dataset!(df)
end

function prepare_dataset_2021(fname::String = "../../2021_01/q12.csv")::DataFrame
    prepare_dataset_2019(fname)
end

function prepare_dataset_2020(fname::String = "../../2020_01/q11.csv")::DataFrame
    prepare_dataset_2019(fname)
end

function prepare_dataset_2019(fname::String = "../../2019_01/q10.csv")::DataFrame
   prepare_dataset_2018(fname)
end

function prepare_dataset_2018(fname::String = "../../2018_01/q9.csv")::DataFrame
   prepare_dataset_2013(fname)
end

function prepare_dataset_2017(fname::String = "../../2017_01/q8.csv")::DataFrame
    prepare_dataset_2013(fname)
end

function prepare_dataset_2016(fname::String = "../../2016_01/q7.csv")::DataFrame
    prepare_dataset_2013(fname)
end

function prepare_dataset_2015(fname::String = "../../2015_01/questionnaire6_cleaned.csv")::DataFrame
    prepare_dataset_2013(fname)
end

function prepare_dataset_2014(fname::String = "../../2014_01/questionnaire5_cleaned.csv")::DataFrame
    prepare_dataset_2013(fname)
end

function prepare_dataset_2013(fname::String = "../../2013_01/questionnaire4_cleaned.csv")::DataFrame
    df = CSV.read(fname, DataFrame)
    filter!( :NowLanguage => x -> !ismissing(x), df)
    transform!(df,
       [ "NowLanguage" => x -> normalize_language_gen.(x) ],
       renamecols = false
    )
    filter!( :NowLanguage => x -> !ismissing(x), df)
end



function categorize_dataset!(df::DataFrame)
    allPlatforms::Set{String} = Set{String}()
    transform!(df,
        [ 
            "Platforms" => x -> prepare_platform.(x,Ref(allPlatforms)),
            "NowLanguage" => x -> normalize_language_2023.(x) 
        ],
        renamecols=false 
    )
    transform!(df,
       [ "Platforms" => x -> categorical.(x,levels=[allPlatforms...]) ],
       renamecols=false 
    )
end



