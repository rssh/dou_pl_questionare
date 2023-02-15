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
    bar(si, xticks=(1:length(si),names(si)[1]), xrotation=90 )
    if !ismissing(fname)
        png(fname)
        dsi=DataFrame(language=names(si)[1], si=si)
        CSV.write("$fname.csv",dsi)
    end
end