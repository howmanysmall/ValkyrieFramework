-- Settings
local Settings = {};
-- Identities contain the settings.

local S = {
    GetSetting = function(this, k)
        local r = Settings[this][k];
        return r and r.get() or nil;
    end;
    SetSetting = function(this, k, v)
        local Settings = Settings[this][k];
        Settings.set(v);
    end;
    RegisterSetting = function(this, k, t)
        local Settings = Settings[this];
        assert(type(t) == 'table' and type(t.set) == 'function' and type(t.get) == 'function', "You need to supply a value for the get/set", 2);
        Settings[k] = t;
    end;
};

local newSettings = function(name)
    local ns = newproxy(true);
    Settings[ns] = {};
    local mt = getmetatable(ns);
    mt.__index = S;
    mt.__tostring = function() return name and "Settings: "..name or "Settings" end;
    mt.__metatable = "Locked Metatable: Valkyrie";
    return ns
end;

local sets = {
    Core = newSettings("Core");
    Components = setmetatable({},{__index = function(t,k) local r = newSettings(k); rawset(t,k,r); return r; end});
    Custom = newSettings("Custom");
    User = newSettings("User");
    };
local r = newproxy(true);
local mt = getmetatable(r);
mt.__index = function(_,k) return sets[k]; end;
mt.__metatable = "Locked Metatable: Valkyrie";
mt.__tostring = function() return "Valkyrie Settings"; end;

return r;