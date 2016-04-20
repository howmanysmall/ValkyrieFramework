local Controller = {};
local evalmt = {};
local evalref = setmetatable({},{__mode = 'k'});
local extract;

Controller.Equal = function(...)
    local obj, val = extract(...);
    
end;

Controller.MoreThan = function(...)
    local obj, val = extract(...);
    
end;

Controller.LessThan = function(...)
    local obj, val = extract(...);
    
end;

Controller.Or = function(...)
    local e1, e2 = extract(...);
    
end;

Controller.And = function(...)
    local e1, e2 = extract(...);
    
end;

Controller.Not = function(...)
    local e1 = extract(...);
    
end;

Controller.Protect = function(...)
    local obj = extract(...);
    
end;

Controller.BanWhen = function(...)
    local condition = extract(...);
    
end;

local r = newproxy();
local _mt = getmetatable(r);
_mt.__index = Controller;
_mt.__tostring = function() return "Valkyrie AntiCheat Controller" end;
_mt.__metatable = "Locked metatable: Valkyrie";

extract = function(...)
    if ... == r then
        return select(2,...);
    else
        return ...;
    end;
end;

return r;
