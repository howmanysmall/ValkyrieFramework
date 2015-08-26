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
	Event = function(n)
		local prxev = Instance.new("BindableEvent");
		local r = newproxy(true);
		local mt = getmetatable(r);
		mt.__index = function(t,k)
			k = k:lower();
			if k == 'fire' then
				return function(...)
					prxev:Fire(t == ... and select(2,...) or ...);
				end;
			elseif k == 'connect' then
				return function(...)
					return prxev.Event:connect(t == ... and select(2,...) or ...);
				end;
			end;
		end;
		mt.__tostring = function() return n end;
		mt.__metatable = "Inefficient Event";
		return r;
	end;
};

mt.__index = {
	ClassList = ClassesList;
	NewClass = function(className)
		return function(class)
			local new = function(repl)
				local repl = type(repl) == 'table' and repl or {};
				local cap = {};
				for k,v in next,class do
					if k ~= 'new' and (type(k) ~= 'string' or k:sub(1,2) ~= '__') then
						cap[k] = v;
					end;
				end;
				for k,v in next,repl do
					cap[k] = v;
				end;
				local r = newproxy(true);
				local mt = getmetatable(r);
				mt.__index = cap;
				mt.__newindex = function(_,k,v) cap[k] = v end;
				mt.__tostring = class.__tostring;
				mt.__metatable = class.__metatable;
				mt.__len = class.__len;
				mt.__lt = class.__lt;
				mt.__le = class.__le;
				mt.__eq = class.__eq;
				mt.__add = class.__add;
				mt.__sub = class.__sub;
				mt.__mul = class.__mul;
				mt.__div = class.__div;
				mt.__pow = class.__pow;
				mt.__mod = class.__mod;
				return r;
			end;
			if type(class.new) == 'function' then
				local onew = new;
				local cnew = class.new;
				new = function(...)
					return onew(cnew(...));
				end;
			end;
			ClassList[className] = new;
		end;
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
