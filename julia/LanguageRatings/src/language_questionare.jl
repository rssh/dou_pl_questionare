
 
 #
 # Define common dataset 
 #

struct LanguageQuestionare 
    label :: String
    commonData :: DataFrame
    originDF :: DataFrame
end;

function normalize_categories_2026(x::Union{Missing,AbstractString})::Union{Missing,AbstractString}
    if ismissing(x)
        return missing
    end
    if startswith(x, "Software Engineer")
        return "SE"
    end
    if x == "DevOps & SRE"
        return "DevOps/SRE"
    end
    if x == "Data Science"
        return "DS/ML/AI"
    end
    return x
end

# 2026 questionnaire exports multi-choice Platforms as space-separated values.
# Multi-word platform names need special handling before space-splitting.
function space_separated_platforms_2026(x::Union{Missing,AbstractString})::Union{Missing,AbstractString}
    if ismissing(x)
        return missing
    end
    s = x
    # Replace known multi-word platform names with single-word placeholders
    s = replace(s, "Multimedia (VoiceBots ChatBots)" => "Multimedia_VoiceBots_ChatBots")
    s = replace(s, "Microcontrollers  Embedded  IoT" => "Microcontrollers_Embedded_IoT")
    s = replace(s, "Mobile cross-platform" => "Mobile_cross-platform")
    s = replace(s, "Mobile Android" => "Mobile_Android")
    s = replace(s, "Mobile iOS" => "Mobile_iOS")
    s = replace(s, "Mobile other" => "Mobile_other")
    s = replace(s, "Voice (IVR)" => "Voice_IVR")
    s = replace(s, "Smart TV" => "Smart_TV")
    s = replace(s, "Game Consoles" => "Game_Consoles")
    parts = filter(p -> p != "", map(String, split(strip(s))))
    # Convert placeholders back to proper names
    result = map(parts) do p
        p = replace(p, "Multimedia_VoiceBots_ChatBots" => "Multimedia (VoiceBots ChatBots)")
        p = replace(p, "Microcontrollers_Embedded_IoT" => "Microcontrollers / Embedded / IoT")
        p = replace(p, "Mobile_cross-platform" => "Mobile cross-platform")
        p = replace(p, "Mobile_Android" => "Mobile Android")
        p = replace(p, "Mobile_iOS" => "Mobile iOS")
        p = replace(p, "Mobile_other" => "Mobile other")
        p = replace(p, "Voice_IVR" => "Voice (IVR)")
        p = replace(p, "Smart_TV" => "Smart TV")
        p = replace(p, "Game_Consoles" => "Game Consoles")
        p
    end
    isempty(result) ? missing : join(result, ",")
end

# 2026 questionnaire exports multi-choice fields as space-separated values
# with special characters stripped. This function restores comma-separated format.
function space_separated_to_csv_2026(x::Union{Missing,AbstractString})::Union{Missing,AbstractString}
    if ismissing(x)
        return missing
    end
    s = x
    # Replace known multi-word tokens before splitting by space
    s = replace(s, "Мови розробки БД (PLSQL Transact-SQL)" => "DB")
    s = replace(s, "Важко сказати не знаю" => "")
    s = replace(s, "C#  NET" => "C#/.NET")
    s = replace(s, "Bash  Shell" => "Bash/Shell")
    s = replace(s, "PascalDelphi" => "Pascal/Delphi")
    s = replace(s, "Verilog VHDL" => "Verilog/VHDL")
    parts = filter(p -> p != "", map(String, split(strip(s))))
    isempty(parts) ? missing : join(parts, ",")
end

function prepare_dataset_2026(fname::String = "../../2026_01/dec2025_programming_languages.csv")::DataFrame
    df = CSV.read(fname, DataFrame, delim=",")
    # Categories normalization
    transform!(df, :Categories => ByRow(normalize_categories_2026) => :Categories, renamecols=false)
    # Fix space-separated multi-choice fields
    for col in [:NextLanguage, :AdditionalLanguages, :PetProjectLanguages]
        if hasproperty(df, col)
            transform!(df, col => ByRow(space_separated_to_csv_2026) => col, renamecols=false)
        end
    end
    # Fix space-separated Platforms (has multi-word names like "Mobile Android")
    if hasproperty(df, :Platforms)
        transform!(df, :Platforms => ByRow(space_separated_platforms_2026) => :Platforms, renamecols=false)
    end
    filter!( :NowLanguage => x -> !ismissing(x), df)
    normalize_dataset!(df)
    transform!(df,
        [ :NextLanguage => ByRow( x ->
           if (ismissing(x))
              missing
            else
              map(l -> normalize_language_2023(lstrip(rstrip(l))), split(x,","))
            end
         ) => :NextLanguages],
        renamecols = false
    )
end

function prepare_dataset_2025(fname::String = ".../../2025_01/dec2024_programming_languages.csv")::DataFrame
    df = CSV.read(fname, DataFrame, delim=",")
    rename!(df,[
        names(df)[4]  => "Employment",
        names(df)[5]  => "Title",
        names(df)[8]  => "Specialization",
        names(df)[9]  => "FirstLanguage",
        names(df)[10] => "NowLanguage",
        names(df)[11] => "ExperienceInLanguageYears",
        names(df)[12] => "FactAdditionalLanguages",
        names(df)[13] => "AdditionalLanguages",
        names(df)[14] => "NextLanguage",
        names(df)[15] => "FactOpenSourceNow",
        names(df)[16] => "OpenSourceLanguageNow", 
        names(df)[17] => "FactPetProjectLanguage",
        names(df)[18] => "PetProjectLanguages",
        names(df)[19] => "FactLearn",
        names(df)[20] => "LearnLanguage",
        names(df)[21] => "FrameworksDevelopment",
        names(df)[22] => "FrameworksQA",
        names(df)[23] => "FrameworksDataAnalysis",
        names(df)[24] => "LearnWay",
        names(df)[25] => "Platforms",
        names(df)[26] => "Area",
        names(df)[27] => "ExperienceInTitleYears",
        names(df)[28] => "ExperienceInProgrammingYears"
    ])
    filter!( :NowLanguage => x -> !ismissing(x), df)
    normalize_dataset!(df)
    # Next language is multi-column.  It's error but we miss one :(  will fix nect year.
    # not fixed yet.
    transform!(df,
        [ :NextLanguage => ByRow( x -> 
           if (ismissing(x)) 
              missing 
            else 
              map(l -> normalize_language_2023(lstrip(rstrip(l))), split(x,",")) 
            end 
         ) => :NextLanguages],
        renamecols = false
    )    
end


function prepare_dataset_2024(fname::String = "../../2024_01/dec2023_programming_languages.csv")::DataFrame
    df = CSV.read(fname, DataFrame, delim=",")
    rename!(df,[
        names(df)[20]=>"FirstLanguage",
        names(df)[21]=>"NowLanguage",
        names(df)[22]=>"ExperienceInLanguageYears",
        names(df)[23]=>"AdditionalLanguages",
        names(df)[24]=>"Platforms",
        names(df)[25]=>"Specialization",
        names(df)[26]=>"FrameworksFrontend",
        names(df)[27]=>"FrameworksFullstack",
        names(df)[28]=>"FrameworksBackend",
        names(df)[29]=>"FrameworksMobile",
        names(df)[30]=>"FrameworksQA",
        names(df)[31]=>"FrameworksDataAnalysis",
        names(df)[32]=>"NextLanguage",
        names(df)[33]=>"PetProjectLanguages",
        names(df)[35]=>"LearnLanguage",
        names(df)[36]=>"LearnWay",
        names(df)[37]=>"Area",
        names(df)[41]=>"ExperienceInProgrammingYears"
    ])
    filter!( :NowLanguage => x -> !ismissing(x), df)
    normalize_dataset!(df)
    # Next language is multi-column.  It's error but we miss one :(  will fix nect year.
    transform!(df,
        [ :NextLanguage => ByRow( x -> 
           if (ismissing(x)) 
              missing 
            else 
              map(l -> normalize_language_2023(lstrip(rstrip(l))), split(x,",")) 
            end 
         ) => :NextLanguages],
        renamecols = false
    )
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
            "FirstLanguage" => x -> normalize_language_2023.(x),
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
    if hasproperty(df, :OpenSourceLanguageNow)
        lcOpenSource = LanguageRatings.multi_language_freq(df,:OpenSourceLanguageNow,limit=50)
        select!(lcOpenSource,[:language,:cnt])
        x=leftjoin(x,lcOpenSource,on=:language,makeunique=true,renamecols=(""=>"_open_source"))
    end
    si=LanguageRatings.satisfaction_index2024(df,limit=50)
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


