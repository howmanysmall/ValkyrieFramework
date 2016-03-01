local import = _G.ValkyrieC.LoadLibrary;
import("Design");
import("Util");

local OverlayController = {};

local extract;
local Overlay = _G.ValkyrieC:GetOverlay();
local IntentService = _G.ValkyrieC:GetComponent "IntentService";
local Colour = _G.Valkyrie:GetComponent "Colour";

local didInit = false;
local Init = require(script.init);
local isOpen = false;
local HomeContentFrame,SplashFrame;
OverlayController.Open = function()
	isOpen = true;
	game.StarterGui:SetCoreGuiEnabled('All', false);
	game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(0);
	if not didInit then
		Init(OverlayController);
		didInit = true;
		HomeContentFrame = Overlay.ActiveContentFrame;
		SplashFrame = Overlay.SplashFrame
	else
		-- Anim in
		Overlay.ButtonsContainer:TweenPosition(
			UDim2.new(0,0,1,-48),
			nil, nil, 0.3, true
		);
		Overlay.ActiveContentFrame:TweenPosition(
			UDim2.new(0,0,0,0),
			nil, nil, 0.2, true
		);
	end;
end;

OverlayController.Close = function()
	isOpen = false;
	-- Anim out
	Overlay.ButtonsContainer:TweenPosition(
		UDim2.new(0,0,1,0),
		nil, nil, 0.2, true
	);
	Overlay.ActiveContentFrame:TweenPosition(
		UDim2.new(0,0,-1,0),
		nil, nil, 0.3, true
	);
end;

OverlayController.ReturnHome = function()
	if Overlay.ActiveContentFrame ~= HomeContentFrame then
		local old = Overlay.ActiveContentFrame
		old.Name = Overlay.ActiveContentFrame.DefaultName.Value;
		old:TweenPosition(
			UDim2.new(0,0,-1,0),
			nil, nil, 0.2, true
		);
		HomeContentFrame.Name = "ActiveContentFrame";
		HomeContentFrame:TweenPosition(
			UDim2.new(0,0,0,0),
			nil, nil, 0.3, true
		);
		IntentService:BroadcastIntent("OverlayContentChanged")
	end;
end;

do local Friends = require(script.Friends);
local proxy = newproxy(true);
OverlayController.Friends = proxy;
local OldOpen = Friends.Open
Friends.Open = function()
	local ReadyHook = Instance.new("BoolValue");
	ReadyHook.Value = false;
	if not isOpen then
		OverlayController.Open();
	end;
	SplashFrame.BackgroundColor3 = Color3.Blue[500];
	SplashFrame.Size = UDim2.new(1,0,1,0);
	-- BIGFRIENDSIMAGEID is not available and it's ".Image" not ".ImageId"
	--SplashFrame.SplashImage.Image = BIGFRIENDSIMAGEID;
	SplashFrame.Position = UDim2.new(0,0,1,0);
	SplashFrame:TweenPosition(
		UDim2.new(0,0,0,0),
		nil, nil, 0.2, true,
		function() ReadyHook.Value = true end
	);
	OldOpen();
	if not ReadyHook.Value then
		ReadyHook.Changed:wait();
	end;
	Overlay.ActiveContentFrame.Position = UDim2.new(0,0,1,0);
	Overlay.ActiveContentFrame.Name = Overlay.ActiveContentFrame.DefaultName.Value;
	Friends.ContentFrame.Name = "ActiveContentFrame";
	Friends.ContentFrame.Position = UDim2.new(0,0,0,0);
	SplashFrame:TweenPosition(
		UDim2.new(0,0,1,0),
		nil, nil, 0.3, true
	);
end;
Friends.ContentFrame.Parent = Overlay;
Friends.ContentFrame.Position = UDim2.new(0,0,-1,0);
Friends.ContentFrame.Size = UDim2.new(1,0,1,-48);
local default = new "StringValue":Instance {
	Name = "DefaultName";
	Value = "Friends";
	Parent = Friends.ContentFrame;
};
local mt = getmetatable(proxy);
mt.__index = Friends;
mt.__metatable = "Locked Metatable: Valkyrie"
end;

local ni = newproxy(true);
local mt = getmetatable(ni);
mt.__metatable = "Locked metatable: Valkyrie";
mt.__index = OverlayController;
mt.__tostring = function()
	return "Valkyrie Overlay Controller";
end;

extract = function(...)
	if (...) == ni or (...) == OverlayController then
		return select(2,...);
	else
		return ...
	end;
end;

return ni;
