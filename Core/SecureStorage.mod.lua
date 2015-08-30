local storage = {};
local e = newproxy(true);
local mt = getmetatable(e);
mt.__index = storage;
mt.__newindex = function(t,k,v) if storage[k] then storage[k] = v else error("You should not be setting "..tostring(k), 2) end end;
mt.__metatable = "Secure storage ain't being touched";

storage.Key = "";

return e