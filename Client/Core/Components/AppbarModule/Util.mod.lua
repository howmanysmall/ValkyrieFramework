-- Do I have to load a library here? Doing it just to be sure.
_G.ValkyrieC:LoadLibrary"Design";
local Util 					= {};
local Core 					= _G.ValkyrieC;
local GetType				= Core:GetComponent "DataTypes";

local RenderStepped 		= game:GetService"RunService".RenderStepped;

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

return Util;