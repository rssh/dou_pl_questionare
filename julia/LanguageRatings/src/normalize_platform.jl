
function normalize_platform(x::Union{Missing,AbstractString})::Union{Missing,AbstractString}
    if ismissing(x)
        return missing
    end
    return x
end
