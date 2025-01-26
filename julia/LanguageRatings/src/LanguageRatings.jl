module LanguageRatings

# Write your package code here.
using DataFrames
using CategoricalArrays
using CSV
using FreqTables
using StatsPlots

struct LanguageRating
    year::Int
    data::DataFrame
end

include("language_questionare.jl")
include("normalize_language.jl")
include("normalize_platform.jl")
include("normalize_specialization.jl")
include("normalize_experience.jl")
include("satisfaction_index.jl")
include("language_freq.jl")
include("experience_plots.jl")
include("freqtable_categories.jl")
include("run_all.jl")

export prepare_all
export run_all
export final_table

end
