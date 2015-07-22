_G.ValkyrieC:LoadLibrary "Design";
_G.ValkyrieC:LoadLibrary "Util";
local Core          			= _G.ValkyrieC;
local cTextInstance 			= {};
local InstanceFunctions 		= {};
local SharedVariables 			= Core:GetComponent "References";

local FakeMT 					= {}; -- Just for fun!
FakeMT.__index 					= {"You shouldn't be looking here!"};
FakeMT.__tostring 				= function() return "This totally isn't a fake metatable!"; end;
FakeMT.__len 					= 5678;
FakeMT.__newindex 				= FakeMT.__tostring; -- Looks like it could be __newindex

local CommonMetatable			= {
	__index 		= InstanceFunctions;
	__metatable 	= FakeMT;
	__len 		= function() return "This table is longer than IE6's loading times!!"; end;
	__newindex 	= function(self,k,v)
		if SharedVariables[self][k] ~= nil then
			SharedVariables[self][k] = v;
		else
			spawn(function() -- lols
				for i = 0, 100 do
					print("Appbar.GetTextObject: Setting index... " .. i .. "%...");
					wait();
				end
			end);
		end
	end;
};

local function spawn(f)
	coroutine.wrap(f)();
end

function cTextInstance.new(MainObject, AltObject, AppbarInstance)
	local Appbar 				= AppbarInstance:GetRaw();
	local TextInstance 			= newproxy(true);

	CopyMetatable(TextInstance, CommonMetatable);

	SharedVariables[TextInstance]		= {
		Appbar 					= Appbar;
		MainObject 				= MainObject;
		AltObject 				= AltObject;
	};

	return TextInstance;
end

function InstanceFunctions:GetAppbar()
	return SharedVariables[self].Appbar;
end

function InstanceFunctions:GetMainObject()
	return SharedVariables[self].MainObject;
end

function InstanceFunctions:GetAltObject()
	return SharedVariables[self].AltObject;
end

function InstanceFunctions:ChangeText(NewText, Tween, Duration, Async)
	AssertType("Argument #2", Tween, 	"string", 	true);
	AssertType("Argument #3", Duration, "number", 	true);
	AssertType("Argument #4", Async, 	"boolean", 	true);

	local MainObject 			= self:GetMainObject();
	local AltObject 			= self:GetAltObject();

	AltObject.Text 				= tostring(NewText);

	local function Runner()
		spawn(function() 	MainObject:VTweenPosition(UDim2.new(-0.5, 0, 0, 10), Tween, Duration); end);
							AltObject :VTweenPosition(UDim2.new(0, 50, 0, 10), 	 Tween, Duration);
		MainObject.Position 						= UDim2.new(0, 50, 0, -100);
	end

	MainObject.Name 			= "TopHeader_alt";
	AltObject.Name 				= "TopHeader";
	self.MainObject 			= AltObject;
	self.AltObject 				= MainObject;

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

function InstanceFunctions:TweenTextColor(NewColor, Tween, Duration, Async)
	AssertType("Argument #1", NewColor, "Color3");
	AssertType("Argument #2", Tween, 	"string", 	true);
	AssertType("Argument #3", Duration, "number", 	true);
	AssertType("Argument #4", Async, 	"boolean", 	true);

	local MainObject 			= self:GetMainObject();
	local AltObject 			= self:GetAltObject();

	local function Runner()
		spawn(function() 	MainObject:TweenTextColor3(NewColor, Tween, Duration); end);
							AltObject :TweenTextColor3(NewColor, Tween, Duration);
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

return cTextInstance;
