_G.ValkyrieC:LoadLibrary "Design";
local Core 					= _G.ValkyrieC;
local FontRendering 		= {};

function FontRendering:CreateLabel(Settings)

end

local ret 					= newproxy(true);
local Metatable 			= getmetatable(ret);
Metatable.__index 			= FontRendering;
Metatable.__len 			= function() return "A dozen."; end;
Metatable.__tostring 		= function() return "Valkyrie Font Rendering Component"; end;
Metatable.__newindex 		= function() return 211851454; end;
Metatable.__metatable 		= ret;

return ret;
