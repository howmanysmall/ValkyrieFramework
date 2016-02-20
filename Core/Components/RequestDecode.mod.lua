local HS = game:GetService("HttpService")
local JSD = HS.JSONDecode;

return function(...) return JSD(HS,...) end;