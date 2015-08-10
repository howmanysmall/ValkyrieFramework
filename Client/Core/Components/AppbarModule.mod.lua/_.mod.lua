_G.ValkyrieC:LoadLibrary "Design";
local Core 					= _G.ValkyrieC;

local AppbarModule 			= {};
local AppbarInstance		= require(script.cAppbarInstance);

local IntentService 		= Core:GetComponent "IntentService";

function AppbarModule:CreateAppbar(Settings, Tween, Duration, Async)
	local Appbar			= AppbarInstance.new(Settings, Tween, Duration, Async);
	IntentService:BroadcastIntent("AppbarCreated");
	return Appbar;
end

local ret 					= newproxy(true);
do
	local Metatable 		= getmetatable(ret);
	Metatable.__metatable	= "It's in vain!";
	Metatable.__len 		= function() return 117; end;
	Metatable.__tostring	= function() return "Valkyrie Appbar Module" end;
	Metatable.__newindex	= function() error("You can keep on trying all day!", 2); end;
	Metatable.__index		= AppbarModule;
end

return ret;
