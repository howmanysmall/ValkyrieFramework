local Controller = {};
local evalmt = {};
local evalref = setmetatable({},{__mode = 'k'});
local DataTypes = _G.Valkyrie:GetComponent "DataTypes";
local BanController = _G.Valkyrie:GetComponent "ValkyrieBans"; -- Secure version, injected on load.
local extract;

evalmt.__call = function(t)
    return evalref[t].Eval();
end;
evalmt.__tostring = function(t)
    local t = evalref[t];
    if t.unobj then
        return "(" .. t.type .. " " .. tostring(t.unobj) .. ")";
    elseif t.lhs then
        return "(" .. tostring(t.lhs) .. " " .. t.type .. tostring(t.rhs) .. ")";
    else
        return "(" .. t.obj:GetFullName() .. ".Value " .. t.type .. " " .. tostring(t.rhs) .. ")";
    end;
end;
evalmt.__metatable = "Locked metatable: Valkyrie (Eval object)";

Controller.Equal = function(...)
    local obj, val = extract(...);
    assert(
        DataTypes(obj) == 'Instance' and obj.Name:sub(-5,-1) == 'Value',
        "[Error][AntiCheat] (in Equal): You need to supply a Value type Instance as argument #1", 2
    );
    local ne = newproxy(true);
    local mt = getmetatable(ne);
    for k,v in next, evalmt do
        mt[k] = v;
    end;
    evalref[ne] = {
        Eval = function()
            return obj.Value == val;
        end;
        obj = obj;
        rhs = val;
        type = "==";
    };
    return ne;
end;

Controller.MoreThan = function(...)
    local obj, val = extract(...);
    assert(
        DataTypes(obj) == 'Instance' and obj.Name:sub(-5,-1) == 'Value',
        "[Error][AntiCheat] (in MoreThan): You need to supply a Value type Instance as argument #1", 2
    );
    local ne = newproxy(true);
    local mt = getmetatable(ne);
    for k,v in next, evalmt do
        mt[k] = v;
    end;
    evalref[ne] = {
        Eval = function()
            return obj.Value > val;
        end;
        obj = obj;
        rhs = val;
        type = ">";
    };
    return ne;
end;

Controller.LessThan = function(...)
    local obj, val = extract(...);
    assert(
        DataTypes(obj) == 'Instance' and obj.Name:sub(-5,-1) == 'Value',
        "[Error][AntiCheat] (in LessThan): You need to supply a Value type Instance as argument #1", 2
    );
    local ne = newproxy(true);
    local mt = getmetatable(ne);
    for k,v in next, evalmt do
        mt[k] = v;
    end;
    evalref[ne] = {
        Eval = function()
            return obj.Value < val;
        end;
        obj = obj;
        rhs = val;
        type = "<";
    };
    return ne;
end;

Controller.Or = function(...)
    local e1, e2 = extract(...);
    assert(
        e1 and evalref[e1],
        "[Error][AntiCheat] (in Or): You need to supply an Eval object as argument #1", 2
    );
    assert(
        e2 and evalref[e2],
        "[Error][AntiCheat] (in Or): You need to supply an Eval object as argument #2", 2
    );
    local ne = newproxy(true);
    local mt = getmetatable(ne);
    for k,v in next, evalmt do
        mt[k] = v;
    end;
    evalref[ne] = {
        Eval = function()
            return e1() or e2();
        end;
        lhs = e1;
        rhs = e2;
        type = "or";
    };
    return ne;
end;

Controller.And = function(...)
    local e1, e2 = extract(...);
    assert(
        e1 and evalref[e1],
        "[Error][AntiCheat] (in And): You need to supply an Eval object as argument #1", 2
    );
    assert(
        e2 and evalref[e2],
        "[Error][AntiCheat] (in And): You need to supply an Eval object as argument #2", 2
    );
    local ne = newproxy(true);
    local mt = getmetatable(ne);
    for k,v in next, evalmt do
        mt[k] = v;
    end;
    evalref[ne] = {
        Eval = function()
            return e1() and e2();
        end;
        lhs = e1;
        rhs = e2;
        type = "and";
    };
    return ne;
end;

Controller.Not = function(...)
    local e1 = extract(...);
    assert(
        e1 and evalref[e1],
        "[Error][AntiCheat] (in Not): You need to supply an Eval object as argument #1", 2
    );
    local ne = newproxy(true);
    local mt = getmetatable(ne);
    for k,v in next, evalmt do
        mt[k] = v;
    end;
    evalref[ne] = {
        Eval = function()
            return not e1();
        end;
        unobj = e1;
        type = "not";
    };
    return ne;
end;

Controller.Protect = function(...)
    local obj = extract(...);
    assert(
        DataTypes(obj) == 'Instance',
        "[Error][AntiCheat] (in Protect): You need to supply an Instance as argument #1", 2
    );
    
end;

Controller.BanWhen = function(...)
    local player, condition = extract(...);
    assert(
        condition and evalref[condition],
        "[Error][AntiCheat] (in BanWhen): You need to supply an Eval object as argument #1", 
        2
    );
    local ref = evalref[condition];
    local q = {ref};
    local function kill()
        BanController.BanCheck(player, condition);
    end;
    while q[#q] do
        local v = q[#q];
        q[#q] = nil;
        if v.obj then
            v.obj.Changed:connect(kill);
        else
            q[#q+1] = lhs;
            q[#q+1] = rhs;
            q[#q+1] = unobj;
        end;
    end;
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
