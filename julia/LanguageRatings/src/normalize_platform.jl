
function normalize_platform(x::Union{Missing,String})::Union{Missing,String}
    if ismissing(x)
        return missing
    end
    return x
end
