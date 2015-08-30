_G.ValkyrieC:LoadLibrary "Design";
local Core 					= _G.ValkyrieC;

local SidebarModule 		= {};
local SidebarInstance 		= require(script.cSidebarInstance);
local IntentService 		= Core:GetComponent "IntentService";

function SidebarModule:CreateSidebar(Settings, Tween, Duration, Async)
	local Sidebar 			= SidebarInstance.new(Settings, Tween, Duration, Async);
	IntentService:BroadcastIntent("SidebarCreated");
	return Sidebar;
end

local ret 					= newproxy(true);
do
	local Metatable 		= getmetatable(ret);
	Metatable.__metatable 	= ret;
	Metatable.__len 		= function() return 0x117; end;
	Metatable.__tostring 	= function() return "Valkyrie Sidebar Module"; end;
	Metatable.__newindex 	= function() error("You did not try to add an index to me. I've destroyed all evidence.", 2); end
	Metatable.__index 		= SidebarModule;
end

return ret;
