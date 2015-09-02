local function echo(...)
	return ...
end;
local function pack(...)
	return {n=select('#',...),...};
end;
local V3Zero  = Vector3.new(0,0,0);
local V3O = {
	zero = V3Zero;
	one = Vector3.new(1,1,1);
	forward = Vector3.new(0,0,-1);
	back = Vector3.new(0,0,1);
	up = Vector3.new(0,1,0);
	down = Vector3.new(0,-1,0);
	left = Vector3.new(-1,0,0);
	right = Vector3.new(1,0,0);
};
local CFO = {
	fromDirection = function(v3dir)
		return CFrame.new(V3Zero, v3dir);
	end;
};
local map = function(f,t)
	for k,v in pairs(t) do
		rawset(t,k,f(v));
	end;
	if pcall(setmetatable,getmetatable(t)) then
		local mt = getmetatable(t);
		local oi = mt.__index;
		mt.__index = function(...)
			local v = type(oi) == 'table' and oi[select(2,...)] or oi(...);
			return f(v);
		end;
		local ni = mt.__newindex;
		mt.__newindex = function(t,k,v)
			v = f(v);
			if ni then ni(t,k,v) else rawset(t,k,v) end;
		end;
	end;
	return t;
end;
local CustomClasses = _G.Valkyrie:GetComponent "Classes".ClassList
local QueryImmediate = _G.Valkyrie:GetComponent "Query".Direct

local assertLocal = function() return assert(game.Players.LocalPlayer,'') end

local UtilMod = _G.Valkyrie:GetComponent "Util";
-- Import it from there

return function(wrapper)
	local client = pcall(assertLocal);
	if client then
		wrapper:OverrideGlobal "LocalPlayer" (game.Players.LocalPlayer)
	end;
	wrapper:OverrideGlobal "isLocal" (client)
	wrapper:OverrideGlobal "new" (function(thing)
		return setmetatable({
			Instance = function(_,t)
				local r = pack(
					pcall(
						Instance.new,
						thing
					)
				);
				if r[1] then
					for k,v in pairs(t) do
						r[2][k] = v;
					end;
					return r[2];
				else
					error(r[2],2);
				end;
			end
		},{
			__call = function(_,...)
				if CustomClasses[thing] then return CustomClasses[thing](...) end;
				local _ENV = getfenv(2);
				local r = pack(
					pcall(
						function(_ENV,...)
							return _ENV[thing].new(...);
						end,
						_ENV, ...
					)
				);
				if r[1] then
					return unpack(r,2,r.n)
				else
					error(r[2], 2);
				end
			end
		});
	end);
	wrapper:OverrideGlobal "Vector3" (V3O);
	wrapper:OverrideGlobal "CFrame" (CFO);
	wrapper:OverrideGlobal "map" (map);
	wrapper:OverrideGlobal "pack" (pack);
	wrapper:OverrideGlobal "query" (QueryImmediate);

	for FuncName, UtilFunction in next, UtilMod do
	   wrapper:OverrideGlobal(FuncName)(UtilFunction);
	end

	wrapper:Override "Player":Instance {
		Kill = function(p)
			if p.Character then
				p.Character:BreakJoints();
			end;
		end;
	};
	wrapper:Override "ModuleScript":Instance {
		require = require;
		Require = require;
	};

	wrapper:Override "UDim2" {
		__mul = function(a, b)
			if type(b) == "UDim2" then
				return UDim2.new(a.X.Scale * b.X.Scale, a.X.Offset * b.X.Offset, a.Y.Scale * b.Y.Scale, a.Y.Offset * b.Y.Offset);
			else
				return UDim2.new(a.X.Scale * b, a.X.Offset * b, a.Y.Scale * b, a.Y.Offset * b);
			end
		end
	};
end;
