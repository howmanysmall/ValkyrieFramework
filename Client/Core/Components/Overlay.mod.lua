local Valkyrie = _G.Valkyrie;
local Appbar = Valkyrie:GetComponent("AppbarModule");
local Sidebar = Valkyrie:GetComponent("SidebarModule");
local Colour = Valkyrie:GetComponent("Colour");
local IntentService = Valkyrie:GetComponent("IntentService");
local RenderStepped = game:GetService("RunService").RenderStepped;
local DashboardActivity;
local Overlay = {};
local ActivityClass = {};
local ScreenClass = {};
local ABStatus = {
	Header = {};
	RightIcon = {
		Icon = {
			Tileset = 'Navigation';
			Name = 'Close'
		};
	};
	LeftIcon = {
		Icon = {
			Tileset = 'Action';
			Name = 'dashboard'
		};
	};
	RBind = function()
		Overlay.Close();
	end;
	LBind = function()
		Overlay.OpenActivity(DashboardActivity);
	end;
};
local activeAppbar, activeSidebar, activeActivity, activeScreen;
local Controller = newproxy(true);
local Player = game:GetService("Players").LocalPlayer;
local mt = getmetatable(Controller);
local Activities = setmetatable({},{__mode = 'k'});
local amt = {
	__index = ActivityClass;
	__tostring = function(t)
		return "Activity Element."
	end;
	__metatable = "Locked metatable: Valkyrie";
};
local smt = {
	__index = ScreenClass;
	__tostring = function(t)
		return Screens[t].Parent;
	end;
	__metatable = "Locked metatable: Valkyrie";
};
local OverlayFrame = Instance.new("Frame");
OverlayFrame.Position = UDim2.new(0,0,0,36);
OverlayFrame.Size = UDim2.new(1,0,1,-36);
OverlayFrame.Parent = Valkyrie:GetOverlay();
OverlayFrame.Transparency = 1;
local shadeTemplate = Instance.new("Frame");
shadeTemplate.BackgroundColor3 = Color3.new(0,0,0);
shadeTemplate.BorderSizePixel = 0;
shadeTemplate.Size = UDim2.new(1,0,1,0);
shadeTemplate.Position = UDim2.new(0,0,0,0);
shadeTemplate.ZIndex = 5;

-- Index range for Overlay is [1-2] Card, elements
-- Index range for Activities is [3-5] Card, elements, shade
-- Index range for Screens is [6-7] Card, elements

local easeOut = function(i)
	return -1*(i^4-1)
end;

local isInstance = function(v)
	if type(v) == 'userdata' then
		local s,e = pcall(game.GetService, game, v);
		return s and not e
	end;
	return false;
end;

Overlay.Open = function()
	activeAppbar = Appbar:CreateAppbar(
		ABStatus,
		"outCubic",
		0.3,
		true
	);
	activeAppbar:GetRightIcon():SetCallback(ABStatus.RBind);
	activeAppbar:GetLeftIcon():SetCallback(ABStatus.LBind);
	do 
		local d = Valkyrie:GetOverlay();
		d.Parent = nil;
		d.Parent = Player.PlayerGui;
	end;
	if activeActivity then
		activeActivity.Frame:TweenPosition(UDim2.new(0,0,0,36),nil,nil,0.1);
		local later = tick()+0.18;
		spawn(function()
			activeActivity.Screen.Transparency = 1;
			activeActivity.Screen.Parent = activeActivity.Frame;
			while tick() < later do
				RenderStepped:wait();
				activeActivity.Screen.Transparency = 1-easeOut((later - tick())*2.2);
			end;
			activeActivity.Screen.Transparency = 0.6;
		end);
	end;
	if activeScreen then
		activeScreen.Frame:TweenPosition(UDim2.new(0,0,0,36),nil,nil,0.18);
	end;
end;
Overlay.Close = function()
	activeAppbar:Destroy(0.2, "inQuad", true)
end;
Overlay.CreateActivity = function(...)
	local data;
	if (...) == Controller then
		data = select(2,...);
	else
		data = ...
	end;
	local newactivity = newproxy(true);
	local mt = getmetatable(newactivity);
	for e,m in pairs(amt) do
		mt[e] = m;
	end;
	local aFrame = Instance.new("Frame");
	local adata = {
		Frame = aFrame;
		Colour = data.Color or data.Colour or Colour.Blue[500];
		Name = data.Name or '';
		Screens = setmetatable({},{__mode = 'k'});
		Shade = shadeTemplate:Clone();
	};
	Activities[newactivity] = adata;
	aFrame.Size = UDim2.new(
	IntentService:BroadcastIntent("ActivityCreated", newactivity);
	return newactivity;
end;
Overlay.OpenActivity = function(Activity)
	local Activity = Activity and Activities[Activity];
	assert(Activity, "You need to supply a valid Activity as #1", 2);
	if not Activity then return end -- Bail out time
	local aFrame = Activity.Frame;
	aFrame:TweenPosition(UDim2.new(0,0,0,36),nil,nil,0.2);
	activeActivity:Close();
	activeActivity = Activity;
	local r = activeAppbar:GetRightIcon();
	r:DisconnectCallback();
	r:ChangeIcon({
		Tileset = 'Navigation';
		Name = 'close'
	},0.24,nil,true)
	ABStatus.RBind = function()
		Activity:Close();
		activeActivity = nil;
		Overlay.ShowMain();
	end
	r:SetCallback(ABStatus.RBind);
	local l = activeAppbar:GetLeftIcon();
	l:DisconnectCallback();
	l:ChangeIcon({
		Tileset = 'Navigation';
		Name = 'menu'
	},0.24,nil,true);
	ABStatus.LBind = function()
		-- Open the sidebar
	end
	l:SetCallback(ABStatus.LBind);
	ABStatus.Color = Activity.Color;
	activeAppbar:TweenBarColor(Activity.Color,0.3,nil,true);
	activeAppbar:GetTextObject():ChangeText(
		Activity.Name,
		0.24,
		nil,
		true
	);
	ABStatus.Header.Text = Activity.Name;
	IntentService:BroadcastIntent("ActivityOpened", Activity);
end;
Overlay.ShowMain = function()
	local RBind = function()
		Overlay.Close();
	end;
	local LBind = function()
		Overlay.OpenActivity(DashboardActivity);
	end;
	ABStatus.LBind = LBind;
	ABStatus.RBind = RBind;
	local l = activeAppbar:GetLeftIcon();
	local r = activeAppbar:GetRightIcon()
	l:SetCallback(LBind);
	r:SetCallback(RBind);
	l:ChangeIcon({
		Tileset = 'Action',
		Name = 'dashboard'
	},0.24,nil,true);
	r:ChangeIcon({
		Tileset = 'Navigation',
		Name = 'close'
	},0.24,nil,true);
	ABStatus.Header.Text = '';
	activeAppbar:GetTextObject():ChangeText('',0.24,nil,true);
	activeAppbar:TweenBarColor(Colour.Blue[500],)
	IntentService:BroadcastIntent "OverlayHome"
end;

ActivityClass.NewScreen = function(self,data)
	local newScreen = newproxy(true);
	local mt = getmetatable(newScreen);
	for e,m in pairs(smt) do
		mt[e] = m;
	end;
	local sFrame = Instance.new("Frame");
	self.Screens[newScreen] = {
		Frame = sFrame;
		Activity = self;
		
	};
	
end;
ActivityClass.SetContent = function(self,content)
	assert(type(content) == 'table', "You must provide a table!", 2);
	local Activity = self and Activities[self];
	assert(Activity, "Expected an Activity as self", 2);
	if not Activity then return end;
	local aFrame = Activity.Frame;
	for _,v in ipairs(aFrame:GetChildren()) do
		v:Destroy();
	end;
	for i=1, #content do
		local content = content[i];
		assert(isInstance(content), "There should be no non-Instance values", 2);
		content.Parent = aFrame;
		if content:IsA("GuiObject") then
			content.ZIndex = 4;
			spawn(function()
				while content.Changed:wait() and content.Parent do -- No disconnecting c:
					if content.ZIndex ~= 4 then
						content.ZIndex = 4;
					end;
				end;
			end);
		end;
	end;
end;
ActivityClass.Close = function(self)
	local Activity = self and Activities[self];
	assert(Activity, "You need to supply a valid Activity as self", 2);
	if not Activity then return end;
	local aFrame = Activity.Frame;
	aFrame:TweenPosition(UDim2.new(0,0,1,0), nil, nil, 0.2);
end;
ActivityClass.OpenScreen = function(self, screen)
	local Activity = self and Activities[self];
	assert(Activity, "You should be supplying an Activity as self", 2);
	if not Activity then return end;
	local Screen = screen and Activity.Screens[screen];
	local RBind = function()
		-- ?TODO
	end;
	local LBind = function()
		screen:Close();
	end;
	Screen.Frame:TweenPosition(UDim2.new(0,0,1,-36),nil,nil,0.2);
end;

mt.__index = Overlay;

return Controller;