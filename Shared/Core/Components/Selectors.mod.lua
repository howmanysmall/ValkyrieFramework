-- I should be writing LiteLib right now.
local Controller = {};
local extract;

-- Body

local r = newproxy(true);
do
	local mt = getmetatable(r);
	mt.__index = Controller;
	mt.__tostring = function()
		return "Valkyrie Selectors Controller"
	end;
	mt.__metatable = "Locked metatable: Valkyrie";
end;
extract = function(...)
	if ... == r then
		return select(2,...);
	else
		return ...
	end;
end;

return r;
