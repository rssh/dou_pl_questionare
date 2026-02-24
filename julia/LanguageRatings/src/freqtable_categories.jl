using Plots;
using FreqTables

const MAIN_CATEGORIES = Set(["SE", "QA", "DevOps/SRE", "DS/ML/AI", "Analyst", "Management"])

function freqtable_categories(df::DataFrame; fname=missing)

    categories = map(normalize_category, df.Categories)

    retval = freqtable(categories)
    retval = sort(retval, rev=true)

    if (!ismissing(fname))
        w = DataFrame(:value => retval[:], :Category=>names(retval,1))
        CSV.write("$fname.csv", w)
    end
    return retval
end

function freqtable_specializations(df::DataFrame; fname=missing)
    specs = filter(x -> !ismissing(x), df.Specialization)
    retval = freqtable(specs)
    retval = sort(retval, rev=true)

    if (!ismissing(fname))
        w = DataFrame(:value => retval[:], :Specialization=>names(retval,1))
        CSV.write(fname, w)
    end
    return retval
end

function freqtable_specialization_history(dataframes::DataFrame...; nYears=4, fname=missing)
    dfs = collect(dataframes)
    if nYears > length(dfs)
        nYears = length(dfs)
    end
    startYear = 2026 - nYears

    rData = DataFrame()
    for i in 1:nYears
        df = dfs[i]
        if !hasproperty(df, :Specialization)
            continue
        end
        currentYear = startYear + nYears - i
        specs = filter(x -> !ismissing(x), df.Specialization)
        ft = freqtable(specs)
        ft = ft / sum(ft)
        cData = DataFrame(:Specialization => names(ft, 1), Symbol("freq$(currentYear)") => ft[:])
        if isempty(rData)
            rData = cData
        else
            rData = outerjoin(rData, cData, on=:Specialization, makeunique=true)
        end
    end
    rData = coalesce.(rData, 0.0)
    sort!(rData, names(rData)[end], rev=true)

    if !ismissing(fname)
        CSV.write("$fname.csv", rData)
    end
    return rData
end

function normalize_category(x)
    if x == "Agile Management" || x == "Other Management" ||
       x == "Product Management" || x == "Project Management"
        "Management"
    elseif x in MAIN_CATEGORIES
        x
    else
        "Other"
    end
end

function freqtable_categories_history(dataframes::DataFrame...; nYears=2, fname=missing)
    dfs = collect(dataframes)
    if nYears > length(dfs)
        nYears = length(dfs)
    end
    startYear = 2026 - nYears

    rData = DataFrame()
    for i in 1:nYears
        df = dfs[i]
        if !hasproperty(df, :Categories)
            continue
        end
        currentYear = startYear + nYears - i
        cats = map(normalize_category, df.Categories)
        ft = freqtable(cats)
        ft = ft / sum(ft)
        cData = DataFrame(:Category => names(ft, 1), Symbol("freq$(currentYear)") => ft[:])
        if isempty(rData)
            rData = cData
        else
            rData = outerjoin(rData, cData, on=:Category, makeunique=true)
        end
    end
    rData = coalesce.(rData, 0.0)
    sort!(rData, names(rData)[end], rev=true)

    if !ismissing(fname)
        CSV.write("$fname.csv", rData)
    end
    return rData
end

# ExtendedSpecialization: unifies Specialization (for SE) and Categories (for non-SE).
# For datasets with Categories (2025+): SE gets Specialization, non-SE gets Category.
# For older datasets: Specialization already had QA/DevOps/Data Analysis.
function add_extended_specialization!(df::DataFrame)
    if hasproperty(df, :Categories)
        df.ExtendedSpecialization = map(eachrow(df)) do r
            if r.Categories == "SE" && !ismissing(r.Specialization)
                r.Specialization
            elseif r.Categories == "QA"
                "QA"
            elseif r.Categories == "DevOps/SRE"
                "DevOps"
            elseif r.Categories == "DS/ML/AI"
                "DS/ML/AI"
            elseif r.Categories == "Analyst"
                "Analyst"
            else
                missing
            end
        end
    else
        df.ExtendedSpecialization = map(df.Specialization) do s
            if ismissing(s)
                missing
            elseif s == "Data Analysis"
                "DS/ML/AI"
            else
                s
            end
        end
    end
    return df
end

function freqtable_specializations_qa(df::DataFrame; fname=missing)
    specs = filter(x -> !ismissing(x) && x != "", df.SpecializationQA)
    retval = freqtable(specs)
    retval = sort(retval, rev=true)

    if (!ismissing(fname))
        w = DataFrame(:value => retval[:], :SpecializationQA=>names(retval,1))
        CSV.write(fname, w)
    end
    return retval
end
