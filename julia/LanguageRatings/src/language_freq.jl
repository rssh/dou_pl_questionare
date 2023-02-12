using DataFrames
using StatsPlots
using CSV

function language_freq(df::DataFrame, columnName::Symbol, limit::Int=30, barrier::Int=1)::DataFrame

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

function freqBarPlot(lc::DataFrame,title::String,fname) 

  bar(lc.freq, xticks=(1:size(lc)[1], lc.language), xrotation=90, legend=false, title="title")
  png(fname)
  CSV.write("$name.csv",lc)

end

#
# dataframes - list of data frames,  the last is first.
#   
function languageFreqHistory(columnName::Symbol, dataframes::DataFrame ... ; limit::Int = 30, startYear=2019)::DataFrame 
  dfs = collect(dataframes)
  

  rData = DataFrame()
  for i in 1:length(dfs)
    df = dfs[i]
    currentYear = startYear+length(dfs)-i
    cData = language_freq(df,columnName)
    cData = select(cData,Not(:cnt))
    if i==1
      rData = rename(cData, ["freq"=> "freq$(currentYear)"])
    else
      rData = outerjoin(rData,cData,on=:language,makeunique=true,renamecols= ""=> "$(currentYear)" )
    end
  end
  
  sort!(rData, [ "freq$(startYear+length(dfs)-1)" ])

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
function freqHistoryBarPlot(glc::DataFrame, title::String, fname::String)
  #TODO: add legend
  groupedbar(Matrix(glc[:,2:size(glc)[2]]), xticks=(1:size(glc)[1], glc.language), xrotation=90)
end

