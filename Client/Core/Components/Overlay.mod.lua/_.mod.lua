local OverlayController = {};

local extract;

local didInit = false;
local isOpen = false;
OverlayController.Open = function(...)
	isOpen = true;
	if not didInit then
		require(script.init);
		didInit = true;
	else
	
	end;
end;

OverlayController.Close = function(...)

end;

local ni = newproxy(true);
local mt = getmetatable(ni);
mt.__metatable = "Locked metatable: Valkyrie";
mt.__index = OverlayController;
mt.__tostring = function()
	return "Valkyrie Overlay Controller";
end;

extract = function(...)
	if ... == ni then
		return select(2,...);
	else
		return ...
	end;
end;

return ni;
