using DataFrames
using FreqTables
using StatsPlots


function satisfaction_index(df::DataFrame; limit=15)
    nn = filter(x -> !ismissing(x.NowLanguage) && !ismissing(x.NextLanguage), df)[!,[:NowLanguage,:NextLanguage]]
    nn.same = nn.NowLanguage .== nn.NextLanguage
    nn1=freqtable(nn,:NowLanguage,:same)
    si = sort( nn1[:,2]./(nn1[:,1]+nn1[:,2]), rev=true)
    if (limit < length(si))
        si = si[1:limit]
    end
    return si
end

function plot_index(si; fname=missing, limit=15)
    bar(Array(si), xticks=(1:length(si),names(si)[1]), xrotation=90 )
    if !ismissing(fname)
        png(fname)
        dsi=DataFrame(language=names(si)[1], si=si)
        CSV.write("$fname.csv",dsi)
    end
end

# in 2024 and 2025 can be more that one language in next languages
function satisfaction_index2024(df::DataFrame; limit=15, filterExpr=missing)
    lf = language_freq(df,:NowLanguage,limit=limit, filterExpr=filterExpr) 
    dlf = DataFrame(:language => vec(lf.language), :cnt=>vec(lf.cnt))
    nn = filter(x -> !ismissing(x.NowLanguage) && !ismissing(x.NextLanguages) ,  df)[!,[:NowLanguage,:NextLanguages]]
    nn = innerjoin(nn, dlf, on = :NowLanguage => :language)
    nn.same = in.(nn.NowLanguage,nn.NextLanguages)
    nn1=freqtable(nn,:NowLanguage,:same)
    si = sort( nn1[:,2]./(nn1[:,1]+nn1[:,2]), rev=true)
    return si
end

    