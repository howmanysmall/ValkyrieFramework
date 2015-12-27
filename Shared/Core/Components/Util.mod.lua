local Util 					= {};
local Core 					= _G.Valkyrie;
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
		assert(Util.CheckSingleType(Value, Type), string.format("%s needs to be a %s (%s given)", Name, Type, Util.GetRealType(Value)), 3);
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

function Util.GetScreenResolution()
	local DummyFrame 		= Instance.new("Frame", Core:GetOverlay());
	DummyFrame.BackgroundTransparency = 1;
	DummyFrame.BorderSizePixel = 0;
	DummyFrame.Size 		= UDim2.new(1,0,1,0);
	local Size 				= DummyFrame.AbsoluteSize;
	DummyFrame:Destroy();

	return Size;
end

local chainmeta = {
	__newindex = function(t,k,v) t._obj[k] = v; end;
	__index = function(t,k)
		return function(v)
			if v then
				t._obj[k] = v;
				return t;
			else
				return t._obj;
			end;
		end;
	end;
}
function Util.Chain(obj)
	return setmetatable({_obj = obj},chainmeta);
end;

Util.isLocal = isLocal;

Util.wait = wait;
if isLocal then
	local tick = tick;
	Util.Player = game.Players.LocalPlayer;
	Util.wait = function(n)
		n = n or 0.29
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
