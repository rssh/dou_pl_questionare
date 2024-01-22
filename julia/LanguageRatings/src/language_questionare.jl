
 
 #
 # Define common dataset 
 #

struct LanguageQuestionare 
    label :: String
    commonData :: DataFrame
    originDF :: DataFrame
end;

function prepare_dataset_2024(fname::String = "../../2024_01/dec2023_programming_languages.csv")::DataFrame
    df = CSV.read(fname, DataFrame, delim=",")
    rename!(df,[
        names(df)[6]=>"FirstLanguage",
        names(df)[7]=>"NowLanguage",
        names(df)[8]=>"ExperienceInLanguageYears",
        names(df)[9]=>"AdditionalLanguages",
        names(df)[10]=>"Platforms",
        names(df)[11]=>"Specialization",
        names(df)[12]=>"Frameworks/Frontend",
        names(df)[13]=>"Frameworks/Fullstack",
        names(df)[14]=>"Frameworks/Backend",
        names(df)[15]=>"Frameworks/Mobile",
        names(df)[16]=>"Frameworks/QA",
        names(df)[17]=>"Frameworks/Data",
        names(df)[18]=>"NextLanguage",
        names(df)[19]=>"PetProjectLanguages",
        names(df)[21]=>"LearnLanguage",
        names(df)[22]=>"LearnWay"
    ])
    filter!( :NowLanguage => x -> !ismissing(x), df)
    normalize_dataset!(df)
end;

function prepare_dataset_2023(fname::String = "../../2023_01/lang-rating-2023.csv")::DataFrame
    df = CSV.read(fname, DataFrame, delim=";")
    rename!(df,[
        names(df)[25]=>"FirstLanguage",
        names(df)[26]=>"NowLanguage",
        names(df)[27]=>"ExperienceInLanguageYears",
        names(df)[28]=>"AdditionalLanguages",
        names(df)[29]=>"Platforms",
        names(df)[30]=>"Specialization",
        names(df)[37]=>"NextLanguage",
        names(df)[38]=>"PetProjectLanguages",
        names(df)[40]=>"LearnLanguage",
        names(df)[46]=>"ExperienceInProgrammingYears"
    ])
    # ask only developers
    filter!( :NowLanguage => x -> !ismissing(x), df)
    normalize_dataset!(df)
end;

function prepare_platform(x::Union{Missing,String}, allPlatforms::Set{String})::Array{String}
    if ismissing(x)
        return []
    else
        variants = map(x -> String(x), map(rstrip,map(lstrip,split(x,","))))
        normalize_platform.(variants)
        union!(allPlatforms, variants)
        return variants
    end
end


function prepare_dataset_2022(fname::String = "../../2022_01/lang-2022-data.csv")::DataFrame
    df = CSV.read(fname, DataFrame, delim=";")
    rename!(df,[
        names(df)[32]=>"FirstLanguage",
        "Основна мова програмування"=>"NowLanguage",
        names(df)[34]=>"ExperienceInLanguageYears",
        names(df)[36]=>"AdditionalLanguages",
        names(df)[37]=>"Platforms",
        names(df)[38]=>"Specialization",
        names(df)[45]=>"NextLanguage",
        names(df)[46]=>"PetProjectsLanguages",
        names(df)[47]=>"LearnLanguage",
        names(df)[54]=>"ExperienceInProgrammingYears"
    ])
    filter!( :NowLanguage => x -> !ismissing(x), df)
    normalize_dataset!(df)
end

function prepare_dataset_2021(fname::String = "../../2021_01/q12.csv")::DataFrame
    df = prepare_dataset_2019(fname)
    transform!(df,
       [ :ExperienceInProgrammingYears => x -> tryparse.(Float32, x)  ],
       renamecols = false
    )
    return df
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
       [ "NextLanguage" => x -> normalize_language_gen.(x) ],
       renamecols = false
    )
    filter!( :NowLanguage => x -> !ismissing(x), df)
end



function normalize_dataset!(df::DataFrame)
    allPlatforms::Set{String} = Set{String}()
    transform!(df,
        [ 
            "Platforms" => x -> prepare_platform.(x,Ref(allPlatforms)),
            #"Platforms" => x -> normalize_platform.(x)
            "NowLanguage" => x -> normalize_language_2023.(x),
            "Specialization" => x -> normalize_specialization.(x),
            "LearnLanguage" => x -> normalize_language_2023.(x),
            "NextLanguage" => x -> normalize_language_2023.(x),
            #"ExperienceInProgrammingYears" => x -> normalize_experience_2023.(x),
            #"ExperienceInLanguageYears" => x -> normalize_experience_2023.(x)
        ],
        renamecols=false 
    )
    if (columnindex(df,:ExperienceInProgrammingYears) > 0)
        transform!(df,
            [ "ExperienceInProgrammingYears" => x -> normalize_experience_2023.(x) ],
            renamecols=false 
        )
    end
    if (columnindex(df,:ExperienceInLanguageYears) > 0)
        transform!(df,
            [ "ExperienceInLanguageYears" => x -> normalize_experience_2023.(x) ],
            renamecols=false 
        )
    end
    #transform!(df,
    #   [ "Platforms" => x -> categorical.(x,levels=[allPlatforms...]) ],
    #   renamecols=false 
    #)
    #
end

function final_table(dfs::DataFrame...; fname=missing) 
    df=dfs[1]
    lcNow=LanguageRatings.language_freq(df,:NowLanguage; limit=30)
    dfPrev=dfs[2]
    lcPrev=LanguageRatings.language_freq(dfPrev,:NowLanguage,limit=50)
    select!(lcPrev,[:language,:freq])
    x=leftjoin(lcNow,lcPrev,on=:language, makeunique=true, renamecols=("" => "_prev"))
    x=coalesce.(x, 0.0)
    x.diff = (x.freq - x.freq_prev)*100
    lcAdditional=LanguageRatings.multi_language_freq(df,:AdditionalLanguages,limit=50)
    select!(lcAdditional,[:language,:cnt])
    x=leftjoin(x,lcAdditional,on=:language,makeunique=true,renamecols=(""=>"_additional"))
    lcPetProjects = LanguageRatings.multi_language_freq(df,:PetProjectLanguages,limit=50)
    select!(lcPetProjects,[:language,:cnt])
    x=leftjoin(x,lcPetProjects,on=:language,makeunique=true,renamecols=(""=>"_pet_projects"))
    si=LanguageRatings.satisfaction_index(df,limit=50)
    dfsi=DataFrame([:language=>vcat(names(si)...),:si=>values(si)])
    x=leftjoin(x,dfsi,on=:language)
    sort!(x,:freq, rev=true)
    select!(x,Not(:freq_prev))
    x.freq=x.freq*100
    x.freq= (x -> if x<1 missing else round(x*100)/100 end).(x.freq)
    x.diff = (x -> if (abs(x)<0.1) missing else round(x*100)/100 end ).( x.diff)
    x.si = (x -> round(x*1000)/10).(coalesce.(x.si,0.0))
    if (!ismissing(fname))
        CSV.write("$fname.csv",x)
    end
    return x
  end 


