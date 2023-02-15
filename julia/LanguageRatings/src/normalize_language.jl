

function normalize_language_2023(x::Union{Missing,String})::Union{Missing,String}
    if ismissing(x)
        return missing
    end
    if (x in ["Не можу обрати одну основну мову", "Інша мова", "Важко сказати, не знаю"]) 
        return missing
    end
    if (x in ["Мови розробки БД (PL/SQL, Transact-SQL)", "SQL"]) 
        return "DB"
    end
    if (x == "C# / .NET") 
        return "C#"
    end
    if (x == "1С")
        return "1C"
    end
    if (x == "Salesforce Apex")
        return "Apex"
    end
    return x
end

languageNamePatterns =Dict(
    "Basic" => r"Basic|Visual Basic|BASIC|VB.Net|VBScript|^VB$",
    "Pascal/Delphi" => r"^pascal$|Turbo Pascal|^Delphi|Pascal / Delphi|Paskal|Delphi|Pascak/Delphi",
    "Apex" => r"APEX|apex|Apex",
    "Modula-2" => r"^Modula2|Modula-2",
    "Fortran" => r"Fortran",
    "Focal" => r"Focal|FOCAL|Фокал|fokal",
    # checked cleaned 2016-01, 2015-01
    "ASM" => r"калькулятор|MK-61|Assembler|машинные коды|MK-52|машинный код|MK61|МК-61|^Asm$",
    "CoffeeScript" => r"CoffeScript|coffeescript",
    "ActionScript" => r"(ActionScript(.*)$)|(Action *Script.*$)|^AS$|^as3$",
    "C#" => r"c#|С#|C#",
    "C++" =>  r"c\\+\\+|С\\+\\+|С\\+\\+",
    "C" => r"^c$|^С$|^С$",
    "SAP ABAP" => r"^SAP$|ABAP$",
    ##patterns["Shell"]="^sh$|^bash$|^shell$|Shell Script|linux shell|bash( |-)scripting|C-Shell$|^ksh$|sh / bash|UNIX shell"
    ## checked cleaned 2016-01, 
    #"T-SQL" => r"^T-SQL$|Transact-SQL$|^TSQL$|^T-SQL;",
    #"PL-SQL" => r"^pl/sql$",
    "DB" => r"^T-SQL$|Transact-SQL$|^TSQL$|^T-SQL;|ˆPL/SQL$|ˆPL-SQL$|^pl/sql$",
    "Matlab" => r"^MATLAB$|^matlab|Matlab$",
    "Clojure" => r"^clojure$|^Clojure$",
    "Python" => r"^python$|^jython$",
    "PowerShell" => r"^Povershell$|^Powershell$|^powershell$",
    "Groovy" => r"Groovy|^groovy",
    "Erlang" => r"erlang",
    "Go"=> r"^Google Go$|^golang$|^GoLang$|^go$",
    "OCaml"=> r"^ocaml$",
    "Lua" => r"^LUA$|ˆlua$"
)

missingLanguagePatterns = Set([r"(Н|н)е пишу",r"Сыроварня",r"Не работаю|^no$"])

function normalize_language_gen(x::Union{Missing,String})::Union{Missing,String}
    if (ismissing(x)) 
        return missing
    end
    x = lstrip(rstrip(x))
    for(pattern) in missingLanguagePatterns
        if (occursin(pattern,x))
            return missing
        end
    end
    for (lang,pattern) in languageNamePatterns
        if ( occursin(pattern,x) )
            return lang
        end
    end
    #not found.  TODO: warning (?)
    return x
end