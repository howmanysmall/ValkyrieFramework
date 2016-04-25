-- Notifications Module
local NotificationCache = {};
local NotificationLinks = setmetatable({},{__mode = 'k'});

local extract;
local Controller = {};



local r = newproxy(true);
local _mt = getmetatable(r);
_mt.__index = Controller;
_mt.__metatable = "Locked metatable: Valkyrie";;
_mt.__tostring = function() return "Valkyrie Notifications Controller" end;

extract = function(...)
  if ... == r then
    return select(2, ...);
  else
    return ...
  end;
end;

return r
