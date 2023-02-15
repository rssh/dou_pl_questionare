

function normalize_experience_2023(x)
    if (ismissing(x)) 
        return missing;
    elseif (x=="Менше як 3 місяці")
        return 0.20
    elseif (x=="3 місяці")
        return 0.25
    elseif x=="Пів року"
        return 0.5
    elseif x=="1 рік"
        return 1
    elseif x=="1,5 року"
        return 1.5
    elseif x=="2 роки"
        return 2
    elseif x=="3 роки"
        return 3
    elseif x=="4 роки"
        return 4
    elseif x=="5 років"
        return 5
    elseif x=="6 років"
        return 6
    elseif x=="7 років"
        return 7
    elseif x=="8 років"
        return 8
    elseif x=="9 років"
        return 9
    elseif x=="10 років"
        return 10
    elseif x=="10 і більше років"
        return 20
    elseif x=="11 років"
        return 11
    elseif x=="12 років"
        return 12
    elseif x=="13 років"
        return 13
    elseif x=="14 років"  
        return 14
    elseif x=="15 і більше років"
        return 20
    else
        return x  
    end
end