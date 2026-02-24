
function normalize_specialization(x::Union{Missing,AbstractString}; unknownAsOther = true)::Union{Missing,AbstractString}
    if ismissing(x)
        return missing
    end
    if (x in ["Embedded", "Embedded ", "embedded", "embedded "])
        return "Embedded"
    end
    if (x in ["Back-end  розробка", "Back-end розробка"])
        return "Backend"
    end
    if (x in ["Front-end  розробка", "Front-end розробка"])
        return "Frontend"
    end
    if (x in [ "Mobile  розробка", "Mobile розробка" ] )
        return "Mobile"
    end
    if (x == "Mobile")
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
    if (x == "Немає відповіді")
        return missing
    end
    if (x == "Інше")
        return "Other"
    end
    if (x in ["Database розробка", "Systems & Infrastructure"])
        return "Other"
    end
    if (startswith(x, "Платформна"))
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
    if (x == "Desktop")
        return "Desktop"
    end
    if (unknownAsOther)
        return "Other"
    else
        return x
    end
end
