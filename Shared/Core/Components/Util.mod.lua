local Util 					= {};
local Core 					= _G.ValkyrieC;
local GetType				= Core:GetComponent "DataTypes";
local isLocal 				= pcall(function() return assert(game.Players.LocalPlayer,'') end);

local RenderStepped 		= game:GetService"RunService".RenderStepped;
local ewait = RenderStepped.wait;

function Util.GetRealType(Value)
	if type(Value) == "userdata" then
		return GetType(Value);
	end
	
	return type(Value);
end

function Util.CheckSingleType(Value, Type)
	if type(Type) ~= "string" then
		error("Your type must be a string!", 2);
	end
	
	return Util.GetRealType(Value) == Type;
end

function Util.AssertType(Name, Value, Type, IgnoreNil)
	if not (IgnoreNil and Value == nil) then 
		assert(Util.CheckSingleType(Value, Type), string.format("%s needs to be a %s", Name, Type), 3);
	end
end

function Util.RunAsync(Runner)
	local Coroutine = coroutine.create(Runner);
	coroutine.resume(Coroutine);
	return function()
		while coroutine.status(Coroutine) ~= "dead" do
			RenderStepped:wait();
		end
	end
end

function Util.CopyMetatable(Object, Metatable)
	local ObjMetatable		= getmetatable(Object);
	for Name, Method in next, Metatable do
		ObjMetatable[Name] 	= Method;
	end
end

Util.isLocal = isLocal;

Util.wait = wait;
if isLocal then
	local tick = tick;
	Util.Player = game.Players.LocalPlayer;
	Util.wait = function(n)
		local now = tick();
		local later = now+n;
		while tick() < later do
			ewait(RenderStepped);
		end;
		return tick() - now;
	end;
end;
Util.ewait = ewait;
local yield = coroutine.yield;
Util.ywait = function(n)
	local now = tick();
	local later = now+n;
	while tick() < later do
		yield();
	end;
	return tick() - now;
end;

return Util;