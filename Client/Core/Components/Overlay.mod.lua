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
local activeAppbar = Appbar:CreateAppbar({
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
},
	nil,
	0,
	true
	);
activeAppbar:GetRightIcon():SetCallback(function()
	Overlay.Close();
end)
activeAppbar:GetLeftIcon():SetCallback(function()
	Overlay.OpenActivity(DashboardActivity);
end);
local activeSidebar = Sidebar:CreateSidebar(
	{
		BackgroundColor = Colour.White;
		BorderColor = Colour.Grey[200];
	},
	nil,
	0,
	true
);
spawn(function()
activeAppbar:Hide(nil,0);
activeSidebar:Hide(nil,0);
end);

local activeActivity, activeScreen;
local Controller = newproxy(true);
local Player = game:GetService("Players").LocalPlayer;
local mt = getmetatable(Controller);
local Activities = setmetatable({},{__mode = 'k'});
local ActivityLinks = setmetatable({},{__mode = 'kv'});
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
	return -(i^4-1)
end;
local easeIn = function(i)
return i^4
end

local isInstance = function(v)
	if type(v) == 'userdata' then
		local s,e = pcall(game.GetService, game, v);
		return s and not e
	end;
	return false;
end;

Overlay.Open = function()
	Overlay.Appbar = activeAppbar;
	Overlay.Sidebar = activeSidebar;
	activeAppbar:Show("outQuad", 0.1, true);
	do
		local d = Valkyrie:GetOverlay();
		d.Parent = nil;
		d.Parent = Player.PlayerGui;
	end;
	local Activity, Screen;
	if activeActivity then
		Activity = Activities[activeActivity];
		Activity.Frame:TweenPosition(UDim2.new(0,0,0,36),nil,nil,0.1);
	end;
	if activeScreen then
		Screen = ActivityLinks[activeScreen].Screens[activeScreen];
		Screen.Frame:TweenPosition(UDim2.new(0,0,0,36),nil,nil,0.18);
		local later = tick()+0.18;
		spawn(function()
			local Shade = Activity.Shade;
			Shade.Transparency = 1;
			Shade.Parent = Activity.Frame;
			while tick() < later do
				RenderStepped:wait();
				Shade.Transparency = 1-easeOut((later - tick())*5.5)*0.4;
			end;
			Shade.Transparency = 0.6;
		end);
	end;
	IntentService:BroadcastIntent("OverlayOpened");
end;
Overlay.Close = function()
	activeAppbar:Hide("inQuad", 0.2, true);
	activeSidebar:Hide("inQuad", 0.2, true);
	local Activity, Screen;
	if activeActivity then
		Activity = Activities[activeActivity];
		Activity.Frame:TweenPosition(UDim2.new(0,0,1,0),"In",nil,0.2);
	end;
	if activeScreen then
		Screen = ActivityLinks[activeScreen].Screens[activeScreen];
		Screen.Frame:TweenPosition(UDim2.new(0,0,1,0),"In",nil,0.1);
		local later = tick()+0.1;
		local Shade = Activity.Shade;
		spawn(function()
			while tick() < later do
				RenderStepped:wait();
				Shade.Transparency = 0.6+easeIn((later - tick())*10)*0.4;
			end;
		Shade.Transparency = 1;
		end);
	end;
	IntentService:BroadcastIntent("OverlayClosed");
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
	aFrame.Size = UDim2.new(1,0,1,0);
	aFrame.BorderSizePixel = 0;
	aFrame.BackgroundColor3 = Color3.new(1,1,1);
	aFrame.Name = data.Name or "Activity"
	IntentService:BroadcastIntent("ActivityCreated", newactivity);
	return newactivity;
end;
Overlay.OpenActivity = function(Activity)
	local activity = Activity and Activities[Activity];
	assert(activity, "You need to supply a valid Activity as #1", 2);
	if not activity then return end -- Bail out time
	local aFrame = activity.Frame;
	aFrame:TweenPosition(UDim2.new(0,0,0,36),nil,nil,0.2);
	if activeActivity then
		activeActivity:Close();
	end;
	activeActivity = Activity;
	local r = activeAppbar:GetRightIcon();
	r:DisconnectCallback();
	r:ChangeIcon({
		Tileset = 'Navigation';
		Name = 'close'
	},0.24,nil,true)
	r:SetCallback(function()
		Activity:Close();
		activeActivity = nil;
		Overlay.ShowMain();
	end);
	local l = activeAppbar:GetLeftIcon();
	l:DisconnectCallback();
	l:ChangeIcon({
		Tileset = 'Navigation';
		Name = 'menu'
	},0.24,nil,true);
	local lbind;
	lbind = function()
		l:DisconnectCallback();
		activeSidebar:Show("outQuad", 0.2, false);
		l:SetCallback(function()
			l:DisconnectCallback();
			activeSidebar:Hide("outQuad", 0.2, false);
			l:SetCallback(lbind);
		end);
	end;
	l:SetCallback(lbind);
	activeAppbar:TweenBarColor(Activity.Color,0.3,nil,true);
	activeAppbar:GetTextObject():ChangeText(
		activity.Name,
		0.24,
		nil,
		true
	);
	IntentService:BroadcastIntent("ActivityOpened", Activity);
end;
Overlay.ShowMain = function()
	local RBind = function()
		Overlay.Close();
	end;
	local LBind = function()
		Overlay.OpenActivity(DashboardActivity);
	end;
	local l = activeAppbar:GetLeftIcon();
	local r = activeAppbar:GetRightIcon()
	l:DisconnectCallback();
	r:DisconnectCallback();
	l:ChangeIcon({
		Tileset = 'Action',
		Name = 'dashboard'
	},0.24,nil,true);
	l:SetCallback(LBind);
	r:ChangeIcon({
		Tileset = 'Navigation',
		Name = 'close'
	},0.24,nil,true);
	r:SetCallback(RBind);
	ABStatus.Header.Text = '';
	activeAppbar:GetTextObject():ChangeText('',0.24,nil,true);
	activeAppbar:TweenBarColor(Colour.Blue[500],0.24,nil,true)
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
		Name = data.Name or 'Screen;
	};
	sFrame.ZIndex = 6;
	sFrame.Size = UDim2.new(1,0,1,0);
	sFrame.BorderSizePixel = 0;
	sFrame.BackgroundColor3 = Color3.new(1,1,1);
	sFrame.Name = data.Name or "Screen";
	ActivityLinks[newScreen] = self;
	return newScreen;
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
	if activeScreen then
		activeScreen:Close();
	end;
end;
ActivityClass.OpenScreen = function(self, screen)
	local Activity = self and Activities[self];
	assert(Activity, "You should be supplying an Activity as self", 2);
	if not Activity then return end;
	local Screen = screen and Activity.Screens[screen];
	assert(Screen, "You should be supplying a Screen to open", 2);
	activeScreen = screen;
	local LBind = function()
		screen:Close();
	end;
	local l = activeAppbar:GetLeftIcon();
	local r = activeAppbar:GetRightIcon();
	l:DisconnectCallback();
	l:ChangeIcon({
		Tileset = 'Navigation',
		Name = 'close'
	},0.16,nil,true);
	l:SetCallback(LBind);
	r:Disable();
	Screen.Frame:TweenPosition(UDim2.new(0,0,0,36),nil,nil,0.2);
end;
ActivityClass.SetSidebarContent = function(self, content)

end;

ScreenClass.Close = function(self)
	local Activity = self and ActivityLinks[self];
	assert(Activity, "You should be supplying a screen with an active activity as self", 2);
	local Screen = Activity.Screens[self];
	local sFrame = Screen.Frame;
	local shade = Activity.Shade;
	activeAppbar:GetRightIcon():Enable();
	sFrame:TweenPosition(UDim2.new(0,0,1,0), "In", nil, 0.2);
	spawn(function()
		local later = tick() + 0.2;
		while tick() < later do
			RenderStepped:wait();
			activeActivity.Shade.Transparency = 0.6+easeIn((later - tick())*10)*0.4;
		end;
		shade.Transparency = 1;
		shade.Parent = nil;
	end);
end;
ScreenClass.SetContent = function(self)
	local Screen = ActivityLinks[self].Screens[self];
	local sFrame = Screen.Frame;
	for _,v in ipairs(sFrame:GetChildren()) do
		v:Destroy();
	end;
	for i=1, #content do
		local content = content[i];
		assert(isInstance(content), "There should be no non-Instance values", 2);
		content.Parent = aFrame;
		if content:IsA("GuiObject") then
			content.ZIndex = 7;
			spawn(function()
				while content.Changed:wait() and content.Parent do -- No disconnecting c:
					if content.ZIndex ~= 7 then
						content.ZIndex = 7;
					end;
				end;
			end);
		end;
	end;
end;

do
	DashboardActivity = Overlay.CreateActivity {
		Name = "";
		Colour = Colour.Blue[500];
	};
	local DashboardContent = {};
	IntentService:RegisterIntent("ActivityCreated", function(activity)
		local newLauncher = Instance.new("Frame");
		table.insert(DashboardContent, newLauncher);
		local tcbind = function()
			Overlay.OpenActivity(activity);
		end;

	end);
	DashboardActivity:SetContent(DashboardContent);
end;

mt.__index = Overlay;

return Controller;
