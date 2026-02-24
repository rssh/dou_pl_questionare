
using DataFrames
using FreqTables
using StatsPlots
using NamedArrays


function experience_freq(df, columnName; filterExpr = missing) 
    if (!ismissing(filterExpr)) 
        df = filter(filterExpr, df)
    end
    ft = freqtable(df.ExperienceInProgrammingYears)
    ft = (ft/sum(ft))*100
    return ft;
end

function experience_freq_fix_names(df, columnName, ftnames; filterExpr = missing) 
    if (!ismissing(filterExpr)) 
        df = filter(filterExpr, df)
    end
    ft = freqtable(df.ExperienceInProgrammingYears)
    ft = (ft/sum(ft))*100
    return ft;
end


function plot_experience_freq(ft; fname=missing, title="" )
    plot(names(ft), ft, xtick=(names(ft)[]), xtickfontsize=5, title=title, legend=false) 
    if !ismissing(fname)
        png(fname)
        dft = DataFrame([names(ft)[], Vector(ft)],[:nYears,:cnt])
        CSV.write("$fname.csv",dft)
    end
    return ft
end

function align_dims(ft0, ft1)
    ft0names = names(ft0)[]
    ft1names = names(ft1)[]
    ftr = map(x -> if (x in ft1names) ft1[x] else 0 end, ft0names)
    return NamedArray(ftr,ft0names)
end

function plot_experience_freq_by_lang(df, langs; fname=missing, title="" )

    ft0 = experience_freq(df, :ExperienceInProgrammingYears)
    ftn = map(l -> 
             align_dims(ft0,
                 experience_freq(filter(x -> !ismissing(x.NowLanguage) && x.NowLanguage==l, df), :ExperienceInProgrammingYears)
             ), langs)
    ftnames = names(ft0)

    ft=prepend!(copy(ftn),[ft0])
    ftlegend = permutedims(["All"; langs...])
    #cols = distinguishable_colors(length(ftlegend), [RGB(1,1,1), RGB(0,0,0)], dropseed=true)
    plot(ftnames, ft, xtick=(ftnames[]), xtickfontsize=5, title=title, labels=ftlegend) 
    if !ismissing(fname)
        png(fname)
        dftCols = ["nYears", "All", langs... ] 
        dft = DataFrame([ftnames[], ft...],dftCols)
        CSV.write("$fname.csv",dft)
    end
    return ft
end
