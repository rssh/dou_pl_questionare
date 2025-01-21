using DataFrames
using StatsPlots
using CSV

function language_freq(df0::DataFrame, columnName::Symbol; limit::Int=100, barrier::Int=1, filterExpr=missing)::DataFrame
  if (!ismissing(filterExpr)) 
    df = filter(filterExpr, df0)
  else
    df = df0  
  end
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


function freqBarPlot(lc::DataFrame, title::String; fname::Union{String,Missing}=missing, limit=30) 

  currentLen = size(lc)[1]
  if (limit < currentLen) 
    lc = lc[1:limit,:]
  end
  bar(Array(lc.freq), xticks=(1:size(lc)[1], lc.language), xrotation=90, legend=false, title=title)
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
  startYear=2025-nYears

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
function freqHistoryBarPlot(glc::DataFrame; title::String="", fname::Union{String,Missing} = missing, plotSize=(800,600), nYears=5, nowYear=2024)
  groupedbar(Matrix(glc[:,2:size(glc)[2]]), xticks=(1:size(glc)[1], glc.language), 
            xrotation=90, size=plotSize, title=title,
            labels = hcat((nowYear-nYears+1):nowYear...)           
  )
  if (!ismissing(fname))
    png(fname)
    CSV.write("$fname.csv",glc)
  end
end

#
# accept column with multiplelanguages 
function  multi_language_freq(df::DataFrame, columnName::Symbol; limit::Int=30, barrier=1, normalizeFun=missing, filterExpr = missing)
  if ismissing(normalizeFun) 
    normalizeFun = normalize_language_2023
  end
  dict = Dict{AbstractString,Int}()
  for r in eachrow(df)
    if (ismissing(r[columnName]))
      continue
    end
    if (!ismissing(filterExpr)) 
      if (!filterExpr(r))
        continue
      end
    end
    if occursin("Немає",r[columnName]) 
      continue;
    end;
    a = map(x -> normalizeFun(String(lstrip(rstrip(x)))), split(r[columnName],","))
    for i in 1:length(a)
      name=a[i]
      if (ismissing(name)) 
        continue 
      end
      dict[name]=get(dict,name,0)+1
    end
  end 
  rData=DataFrame(language=collect(keys(dict)),cnt=collect(values(dict)))
  sort!(rData,:cnt,rev=true)
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


#
# differs that in platform
#
function  multi_platform_freq(df::DataFrame, columnName::Symbol; limit::Int=30, barrier=1, normalizeFun=missing)
  if ismissing(normalizeFun) 
    normalizeFun = normalize_platform
  end
  dict = Dict{AbstractString,Int}()
  for r in eachrow(df)
    if (ismissing(r[columnName]))
      continue
    end
    a = map(x -> normalizeFun(String(lstrip(rstrip(x)))), r[columnName])
    for i in 1:length(a)
      name=a[i]
      if (ismissing(name)) 
        continue 
      end
      dict[name]=get(dict,name,0)+1
    end
  end 
  rData=DataFrame(language=collect(keys(dict)),cnt=collect(values(dict)))
  sort!(rData,:cnt,rev=true)
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

function multi_freq_history(columnName::Symbol, dataframes::DataFrame ... ; limit::Int = 30, nYears=5, filterExpr = missing)::DataFrame 
  dfs = collect(dataframes)

  if (nYears > length(dfs))
    nYears = length(dfs)
  end
  startYear=2024-nYears

  rData = DataFrame()
  for i in 1:nYears
    df = dfs[i]
    if (!ismissing(filterExpr)) 
      df = filter(filterExpr, df)
    end
    currentYear = startYear+nYears-i
    cData = multi_language_freq(df,columnName)
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

