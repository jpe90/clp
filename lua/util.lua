function copy_table(t)
    local t2 = {}
    for k, v in pairs(t) do t2[k] = v end
    return t2
end

function print_r(t, indent)
    indent = indent or ""
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indent .. tostring(k) .. ":")
            print_r(v, indent .. "  ")
        else
            print(indent .. tostring(k) .. ": " .. tostring(v))
        end
    end
end
