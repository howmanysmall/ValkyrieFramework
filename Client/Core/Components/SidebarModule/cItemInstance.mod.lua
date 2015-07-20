_G.ValkyrieC:LoadLibrary "Design";
local Core          		= _G.ValkyrieC;
local cItemInstance     	= {};
local InstanceFunctions 	= {};

local Util 					= require(script.Parent.Util);
local AssertType, RunAsync 	= Util.AssertType, Util.RunAsync;

local Connections 			= setmetatable({}, {__mode = "k"});

local function spawn(f)
	coroutine.wrap(f)();
end

function cItemInstance.new(Item)
	if Item == nil then
		return nil;
	end

	AssertType("Argument #1", Item, "Instance");

	local FakeIndex 		= setmetatable({Raw = Item, Extend = Item.Extend1}, {__index = InstanceFunctions});

	local ItemInstance 		= newproxy(true);
	do
		local Metatable 		= getmetatable(ItemInstance);
		Metatable.__len 		= function() return math.pi; end;
		Metatable.__index 		= FakeIndex;
		Metatable.__metatable	= "Cherries are awesome!";
		Metatable.__newindex 	= function(_, k, v)
			if FakeIndex[k] ~= nil then
				FakeIndex[k] 	= v;
			else
				error("New index? Have some music instead! \14\14\14", 2);
			end
		end;
	end

	return ItemInstance;
end

function InstanceFunctions:TweenBackgroundColor(NewColor, Tween, Duration, Async)
	AssertType("Argument #1", NewColor, "Color3");
	AssertType("Argument #2", Tween, 	"string", 	true);
	AssertType("Argument #3", Duration, "number", 	true);
	AssertType("Argument #4", Async, 	"boolean", 	true);

	local MainObject 			= self.Raw;
	local Extend	 			= self.Extend;

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

	local MainObject 			= self.Raw;
	local Extend	 			= self.Extend;

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
	return Connections[self.Raw];
end

function InstanceFunctions:DisconnectCallback()
	if Connections[self.Raw] then
		Connections[self.Raw]:disconnect();
	end
	Connections[self.Raw] = nil;
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

	Connections[self.Raw]	= self.Raw.InputEnded:connect(Connection);
end

return cItemInstance;
