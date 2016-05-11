-- DO IT SOME TIME
local newproxy = newproxy;

local convert do
    local function All(this, from, to, ...)
        local ret = {...};
        local n = #ret;
        for i=1,n do
            ret[i] = convert(this, from, to, ret[i]);
        end;
        return unpack(ret)
    end;
    convert = function(this, from, to, obj)
    
    end;
end;
