local HS = game:GetService("HttpService")
local JSE = HS.JSONEncode;

return function(...) return JSE(HS,...):sub(2,-2) end;