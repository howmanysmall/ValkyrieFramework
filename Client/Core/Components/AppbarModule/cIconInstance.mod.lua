_G.ValkyrieC:LoadLibrary "Design";
_G.ValkyrieC:LoadLibrary "Util";
local Core          		= _G.ValkyrieC;
local cIconInstance 		= {};
local InstanceFunctions 	= {};
local SharedVariables 		= Core:GetComponent "References";

local CommonMetatable 		= {
	__index 				= InstanceFunctions;
	__metatable 			= "\3\117\224\9";
	__len 					= function() return 26208; end;
	__tostring				= function(self) return string.format("Valkyrie Appbar %s Icon", SharedVariables[self].Side); end;
	__newindex 				= function(self,k,v)
		if SharedVariables[self][k] ~= nil then
			SharedVariables[self][k] = v;
		else
			error("\1\1\7\2\2\4", 2);
		end
	end
};

local function spawn(f)
	coroutine.wrap(f)();
end

function cIconInstance.new(Side, Icon, AltIcon, AppbarInstance)
	local Appbar 			= AppbarInstance:GetRaw();
	local IconInstance 		= newproxy(true);

	CopyMetatable(IconInstance, CommonMetatable);
	SharedVariables[IconInstance] 	= {
		Appbar 			= AppbarInstance;
		MainIcon 		= Icon;
		AltIcon 		= AltIcon;
		Side 			= Side;
	};

	return IconInstance;
end

function InstanceFunctions:TweenIconColor(NewColor, Tween, Duration, Async)
	AssertType("Argument #1", NewColor, "Color3");
	AssertType("Argument #2", Tween, 	"string", 	true);
	AssertType("Argument #3", Duration, "number", 	true);
	AssertType("Argument #4", Async, 	"boolean", 	true);

	local MainIcon 		= self:GetMainIcon();
	local AltIcon 		= self:GetAltIcon();
	-- Again, wonder if I should make a debounce
	local function Runner()
		-- Two need to run at the same time
		spawn(function() 	MainIcon:TweenImageColor3(NewColor, Tween, Duration); end);
							AltIcon	:TweenImageColor3(NewColor, Tween, Duration);
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

function InstanceFunctions:ChangeIcon(NewIcon, Tween, Duration, Async)
	AssertType("Argument #1", 		NewIcon, 			"table");
	AssertType("NewIcon.Tileset", 	NewIcon.Tileset,	"string");
	AssertType("NewIcon.Name", 		NewIcon.Name, 		"string");
	AssertType("Argument #2", 		Tween, 				"string", 	true);
	AssertType("Argument #3", 		Duration, 			"number", 	true);
	AssertType("Argument #4", 		Async, 				"boolean", 	true);

	local MainIcon 		= self:GetMainIcon();
	local AltIcon 		= self:GetAltIcon();
	local Connections = self:GetCallback();
	local Duration 		= Duration or 0.27

	local CenterPoint, Alt, Main;
	if self.Side == "Left" then
		CenterPoint 	= UDim2.new(0, -15, 0, 10);
		Alt 			= {180, 360};
		Main 			= {0, 180};
	else
		CenterPoint 	= UDim2.new(1, -15, 0, 10);
		Alt 			= {360, 180};
		Main 			= {180, 0};
	end

	local function Runner()
		spawn(function() 	AltIcon	:TweenCircularly(Alt[1],  Alt[2],  Tween, Duration, CenterPoint, 25); end);
						 	MainIcon:TweenCircularly(Main[1], Main[2], Tween, Duration, CenterPoint, 25);
	end

	AltIcon:LoadIcon(NewIcon.Tileset, NewIcon.Name);
	-- Since they will be switched around, do this!
	MainIcon.Name 		= string.format("Top%sButton_alt", 	self.Side);
	AltIcon.Name		= string.format("Top%sButton", 		self.Side);
	self.MainIcon 		= AltIcon;
	self.AltIcon 		= MainIcon;
	if Connections[self] then
		local OldMain 	= Connections[self].Main;
		local OldAlt 	= Connections[self].Alt;
		Connections[self].Main = OldAlt;
		Connections[self].Alt  = OldMain;
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

function InstanceFunctions:GetMainIcon()
	return SharedVariables[self].MainIcon;
end

function InstanceFunctions:GetAltIcon()
	return SharedVariables[self].AltIcon;
end

function InstanceFunctions:GetAppbar()
	return SharedVariables[self].Appbar;
end

function InstanceFunctions:GetSide()
	return SharedVariables[self].Side;
end

function InstanceFunctions:GetCallback()
	return SharedVariables[self].Connections;
end

function InstanceFunctions:DisconnectCallback()
	local Connections = SharedVariables[self].Connections;
	if Connections then
		Connections.Main:disconnect();
		Connections.Alt:disconnect();
	end
	SharedVariables[self].Connections = nil;
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

	SharedVariables[self].Connections = {
		Main	 			= self.MainIcon.InputEnded:connect(Connection);
		Alt					= self.AltIcon.InputEnded:connect(Connection);
	};
end

return cIconInstance;
