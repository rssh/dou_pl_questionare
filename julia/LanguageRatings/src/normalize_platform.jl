
function normalize_platform(x::Union{Missing,AbstractString})::Union{Missing,AbstractString}
    if ismissing(x)
        return missing
    end
    if x in ("Analytics", "Data Platform", "Data", "DWH")
        return "Data / Analytics"
    end
    if x == "Mobile cross-platform Web"
        return "Mobile cross-platform"
    end
    if x in ("Cloud", "Backend", "Web Desktop")
        return "Web"
    end
    if x in ("Robotics", "Embedded", "Microcontrollers  Embedded  IoT")
        return "Microcontrollers / Embedded / IoT"
    end
    if x in ("Infrastructure", "None", "-")
        return "Other"
    end
    return x
end
