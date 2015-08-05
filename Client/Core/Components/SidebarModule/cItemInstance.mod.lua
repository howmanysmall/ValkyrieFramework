_G.ValkyrieC:LoadLibrary "Design";
_G.ValkyrieC:LoadLibrary "Util";
local Core          		= _G.ValkyrieC;
local cItemInstance     	= {};
local InstanceFunctions 	= {};

local function spawn(f)
	coroutine.wrap(f)();
end

local SharedVariables 		= Core:GetComponent "References";
local SharedMetatable 		= {
	__len 					= function() return math.pi; end;
	__index 				= InstanceFunctions;
	__metatable 			= "Cherries are awesome!";
	__newindex 				= function(self, k, v)
		if SharedVariables[self][k] then
			SharedVariables[self][k] = v;
		else
			error("New index? Have some music instead! \14\14\14", 2);
		end
	end;
};

function cItemInstance.new(Item)
	if Item == nil then -- Invalid index?
		return nil;
	end

	AssertType("Argument #1", Item, "Instance");

	local ItemInstance 		= newproxy(true);
	CopyMetatable(ItemInstance, SharedMetatable);
	SharedVariables[ItemInstance] = {Raw = Item, Extension = Item.Extend1};

	return ItemInstance;
end

function InstanceFunctions:GetRaw()
	return SharedVariables[self].Raw;
end

function InstanceFunctions:GetExtension()
	return SharedVariables[self].Extension;
end

function InstanceFunctions:TweenBackgroundColor(NewColor, Tween, Duration, Async)
	AssertType("Argument #1", NewColor, "Color3");
	AssertType("Argument #2", Tween, 	"string", 	true);
	AssertType("Argument #3", Duration, "number", 	true);
	AssertType("Argument #4", Async, 	"boolean", 	true);

	local MainObject 			= self:GetRaw();
	local Extend	 			= self:GetExtension();

	local function Runner()
		spawn(function() 	MainObject:TweenBackgroundColor3(NewColor, Tween, Duration); end);
							Extend 	  :TweenBackgroundColor3(NewColor, Tween, Duration);
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

function InstanceFunctions:TweenOnX(New, Tween, Duration, Async)
	AssertType("Argument #1", New, 		"number");
	AssertType("Argument #2", Tween, 	"string", 	true);
	AssertType("Argument #3", Duration, "number", 	true);
	AssertType("Argument #4", Async, 	"boolean", 	true);

	local MainObject 			= self:GetRaw();
	local Extend	 			= self:GetExtension();

	local function Runner()
		spawn(function() 	Extend		:VTweenSize(	UDim2.new(0, 10 + New, 1, 0),  Tween, Duration); end);
		spawn(function() 	Extend		:VTweenPosition(UDim2.new(0, -10 - New, 0, 0), Tween, Duration); end);
							MainObject	:VTweenPosition(UDim2.new(0, 10 + New, 0, MainObject.Position.Y.Offset),  Tween, Duration);
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

function InstanceFunctions:GetCallback()
	return SharedVariables[self].Connection;
end

function InstanceFunctions:DisconnectCallback()
	if SharedVariables[self].Connection then
		SharedVariables[self].Connection:disconnect();
	end
	SharedVariables[self].Connection = nil;
end

function InstanceFunctions:SetCallback(Callback)
	AssertType("Argument #1", Callback, "function");
	self:DisconnectCallback();

	local Connection 		= function(InputObject)
		if  	InputObject.UserInputType ~= Enum.UserInputType.MouseButton1
			and InputObject.UserInputType ~= Enum.UserInputType.Touch then
			return;
		end

		Callback();
	end

	SharedVariables[self].Connection	= self:GetRaw().InputEnded:connect(Connection);
end

return cItemInstance;
