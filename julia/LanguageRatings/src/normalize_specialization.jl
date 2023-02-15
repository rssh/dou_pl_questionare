
function normalize_specialization(x::Union{Missing,String}; unknownAsOther = true)::Union{Missing,String}
    if ismissing(x)
        return missing
    end
    if (x in ["Embedded", "Embedded ", "embedded", "embedded "])
        return "Embedded"
    end
    if (x == "Back-end  розробка")
        return "Backend"
    end
    if (x == "Front-end  розробка")
        return "Frontend"
    end
    if (x == "Mobile  розробка")
        return "Mobile"
    end
    if (x == "Full Stack розробка")
        return "Full Stack"
    end
    if (x in [ "Робота з даними, аналіз даних", "DS, AI, ML", "Data Analysis" ] )
        return "Data Analysis"
    end
    if (x == "QA")
        return "QA"
    end
    if (x == "Системне програмування")
        return "Other"
    end
    if (x == "Інше")
        return "Other"
    end
    if (x == "DevOps/SRE")
        return "DevOps"
    end
    if (x == "gamedev" || x=="GameDev")
        return "GameDev"
    end
    if (x == "AOSP, RTOS")
        return "Embedded"
    end
    if (x in [ "DevOps", "devops" ] )
        return "DevOps"
    end
    if (x in [ "QA", "qa" ])
        return "QA"
    end
    if (unknownAsOther)
        return "Other"
    else
        return x
    end
end
