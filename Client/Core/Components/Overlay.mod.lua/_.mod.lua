local OverlayController = {};

local extract;
local Overlay = _G.ValkyrieC:GetOverlay();
local IntentService = _G.Valkyrie:GetComponent "IntentService";

local didInit = false;
local Init = require(script.init);
local isOpen = false;
local HomeContentFrame;
OverlayController.Open = function()
	isOpen = true;
	game.StarterGui:SetCoreGuiEnabled('All', false);
	game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(0);
	if not didInit then
		Init(OverlayController);
		didInit = true;
		HomeContentFrame = Overlay.ActiveContentFrame;
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
