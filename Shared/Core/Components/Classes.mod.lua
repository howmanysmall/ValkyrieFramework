local r = newproxy(true);
local mt = getmetatable(r);

local function echo(...)
	if (...) == r then
		return select(2,...);
	else
		return ...
	end;
end;

local ClassesList = {
	
};

mt.__index = {
	ClassList = ClassesList;
	NewClass = function(class)
		
	end;
	new = function(type)
		return function(...)
			return ClassesList[type](...);
		end;
	end;
};
mt.__tostring = "Classes controller";
mt.__metatable = "Locked Metatable: Valkyrie";

return r;
