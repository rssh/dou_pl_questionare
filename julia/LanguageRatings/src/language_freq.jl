using DataFrames
using StatsPlots
using CSV

function language_freq(df::DataFrame, columnName::Symbol; limit::Int=100, barrier::Int=1)::DataFrame
   rTable = freqtable(df,columnName)
   rData = dropmissing(DataFrame(language=names(rTable)[1],cnt=rTable))
   sort!(rData,"cnt",rev=true)
   transform!(rData, :cnt => (x -> x/sum(rData.cnt)) => :freq )
   if (barrier > 1)
    rData = filter(x -> x.cnt >= barrier, rData)
   end 
   currentLen = size(rData)[1]
   if (limit < currentLen)
     rData = rData[1:limit,:]
   end 
   return rData
end


function freqBarPlot(lc::DataFrame, title::String; fname::Union{String,Missing}, limit=30) 

  currentLen = size(lc)[1]
  if (limit < currentLen) 
    lc = lc[1:limit,:]
  end
  bar(lc.freq, xticks=(1:size(lc)[1], lc.language), xrotation=90, legend=false, title=title)
  if !ismissing(fname)
    png(fname)
    CSV.write("$fname.csv",lc)
  end
end

#
# dataframes - list of data frames,  the last is first.
#   
function freqHistory(columnName::Symbol, dataframes::DataFrame ... ; limit::Int = 30, nYears=5, filterExpr = missing)::DataFrame 
  dfs = collect(dataframes)

  if (nYears > length(dfs))
    nYears = length(dfs)
  end
  startYear=2023-nYears

  rData = DataFrame()
  for i in 1:nYears
    df = dfs[i]
    if (!ismissing(filterExpr)) 
      df = filter(filterExpr, df)
    end
    currentYear = startYear+nYears-i
    cData = language_freq(df,columnName)
    cData = select(cData,Not(:cnt))
    if i==1
      rData = rename(cData, ["freq"=> "freq$(currentYear)"])
    else
      rData = outerjoin(rData,cData,on=:language,makeunique=true,renamecols= ""=> "$(currentYear)" )
    end
  end
  
  rData = coalesce.(rData,0.0)
  sort!(rData, [ "freq$(startYear+nYears-1)" ], rev=true)

  #: reverse colums
  ns = names(rData)
  orderedNames = append!([ns[1]],reverse(ns[2:length(ns)])) 
  rData = rData[!,orderedNames]
  currentLen = size(rData)[1]
  if (limit < currentLen)
    rData = rData[1:limit,:]
  end 

  return rData
end

#
# glc should have form
# language |  freq_year1 | ....  | freq_yearN
#
# usually glc is an outer join of language_freq datasets
# glc = outerjoin(select(lc2022,Not(:cnt)),select(lc2023,Not(:cnt)),on=:language,makeunique=true)
function freqHistoryBarPlot(glc::DataFrame; title::String="", fname::Union{String,Missing} = missing, plotSize=(800,600), nYears=5)
  groupedbar(Matrix(glc[:,2:size(glc)[2]]), xticks=(1:size(glc)[1], glc.language), 
            xrotation=90, size=plotSize, title=title,
            labels = hcat((2022-nYears+1):2022...)           
  )
  if (!ismissing(fname))
    png(fname)
    CSV.write("$fname.cvs",glc)
  end
end

function languagesBySpecialization(columnName, dfs::DataFrame...; nYears = 2 )
  #allSpecializations = union!(Set(), dfs[1..nYears])
  allSpecializations = Set()
  for i in 1..nYears
    df = dfs[i]
    if ("Specialization" in names(df))
        union!(a, names(freqtable(df,"Specialization")))
    end   
  end

  rData = DataFrame()

end

