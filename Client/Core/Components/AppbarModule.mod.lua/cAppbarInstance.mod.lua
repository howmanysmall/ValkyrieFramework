local import = _G.ValkyrieC.LoadLibrary;
import "Design";
import "Util";

local Core          		= _G.ValkyrieC;
local cAppbarInstance       = wrapper({});
local InstanceFunctions 	= {};

local IconInstance 			= require(script.Parent.cIconInstance);
local TextInstance 			= require(script.Parent.cTextInstance);

local AppbarTemplate 		= script.Parent.Appbar;
local IntentService 		= Core:GetComponent "IntentService";
local SharedVariables 		= Core:GetComponent "References";

local SharedMetatable 		= {
	__index 				= InstanceFunctions;
	__metatable 			= "I'm a fake metatable and you're a person who will step on LEGO bricks next night!";
	__len 					= function() return 224; end;
	__tostring			 	= function() return "Valkyrie Appbar Instance"; end;
	__newindex 				= function(_,k,v)
		pcall(function() rawset({}, k, v); end);
		error("I set an index somewhere. Where? Who knows.", 2);
	end
};

local function spawn(f)
	coroutine.wrap(f)();
end

local function ApplySettingsToIcon(self, Side, Icon, Settings)
	AssertType("Argument #1", Icon, "Instance");
	AssertType("Argument #2", Settings, "table");

	if Settings.Color then
		AssertType("Settings.Color", Settings.Color, "Color3");

		Icon.ImageColor3 	= Settings.Color;
	end

	if Settings.Icon then
		AssertType("Settings.Icon", 		Settings.Icon, 			"table");
		AssertType("Settings.Icon.Tileset", Settings.Icon.Tileset, 	"string");
		AssertType("Settings.Icon.Name", 	Settings.Icon.Name,		"string");

		Icon:LoadIcon(Settings.Icon.Tileset, Settings.Icon.Name);
	end

	if Settings.Callback and Side then -- If Side == nil don't set callback. Effiency.
		AssertType("Settings.Callback", 	Settings.Callback, 		"function");

		self["Get" .. Side .. "Icon"](self):SetCallback(Settings.Callback);
	end
end

local function TweenAppbarIn(self, ContentFrame, Tween, Duration, Async)
	IntentService:BroadcastIntent("AppbarTweeningIn", Tween, Duration, self);

	local Appbar 				= self:GetRaw();
	Appbar.Position 			= UDim2.new(0, 0, 0, -Appbar.AbsoluteSize.Y - 36);

	local function Runner()
		spawn(function() Appbar		 :VTweenPosition(UDim2.new(0,0,0,0), 							Tween, Duration); end);
		spawn(function() ContentFrame:VTweenPosition(UDim2.new(0,0,0,Appbar.AbsoluteSize.Y + 2), 	Tween, Duration); end);
						 ContentFrame:VTweenSize 	(UDim2.new(1,0,1,-Appbar.AbsoluteSize.Y - 2), 	Tween, Duration);
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

local function TweenAppbarOut(self, Tween, Duration, Destroy, Async)
	IntentService:BroadcastIntent("AppbarTweeningOut", Tween, Duration, self);

	local Appbar 				= self:GetRaw();
	local ContentFrame 			= self:GetRealContentFrame();

	local function Runner()
		spawn(function() Appbar		 :VTweenPosition(UDim2.new(0,0,0,-Appbar.AbsoluteSize.Y - 36), Tween, Duration); end);
		spawn(function() ContentFrame:VTweenPosition(UDim2.new(0,0,0,0), 					  Tween, Duration); end);
						 ContentFrame:VTweenSize	(UDim2.new(1,0,1,0),					  Tween, Duration);
		if Destroy then
			Core:SetContentFrame(Core:GetOverlay());
			self:GetRaw():Destroy();
			self:GetRealContentFrame():Destroy();
		end
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

local function GetAppbarHeight()
	return GetScreenResolution().X < 1024 and 48 or 64; -- Phone -> 48, tablet/PC -> 64
end

function cAppbarInstance.new(Settings, Tween, Duration, Async)
	AssertType("Argument #2", Tween, 	"string",  true);
	AssertType("Argument #3", Duration, "number",  true);
	AssertType("Argument #4", Async,	"boolean", true);

	local Appbar 							= AppbarTemplate:Clone();

	local ContentFrame 						= Instance.new("Frame", Core:GetOverlay());
	ContentFrame.BorderSizePixel			= 0;
	ContentFrame.BackgroundTransparency		= 1;
	ContentFrame.Size 						= UDim2.new(1, 0, 1, 0);
	ContentFrame.Name 						= "ContentFrame_Appbar";

	local Height 							= GetAppbarHeight();

	local AppbarInstance 					= newproxy(true);
	SharedVariables[AppbarInstance]			= {Raw = Appbar, ContentFrame = ContentFrame, Height = Height};

	CopyMetatable(AppbarInstance, SharedMetatable);

	if Settings then
		if Settings.Color then
			AssertType("Settings.Color", Settings.Color, "Color3");

			Appbar.BackgroundColor3 				= Settings.Color;
			Appbar.TopbarColorizer.BackgroundColor3 = Settings.Color;
			Appbar.TopHeader.BackgroundColor3 		= Settings.Color;
			Appbar.TopHeader_alt.BackgroundColor3 	= Settings.Color;
		end

		if Settings.LeftIcon then
			ApplySettingsToIcon(AppbarInstance, "Left", Appbar.TopLeftButton, 		Settings.LeftIcon);
			ApplySettingsToIcon(AppbarInstance, nil, 	Appbar.TopLeftButton_alt, 	Settings.LeftIcon); -- nil == don't set callback
		end
		if Settings.RightIcon then
			ApplySettingsToIcon(AppbarInstance, "Right", Appbar.TopRightButton, 	Settings.RightIcon);
			ApplySettingsToIcon(AppbarInstance, nil, 	Appbar.TopRightButton_alt, Settings.RightIcon); -- nil == don't set callback
		end

		if Settings.Header then
			AssertType("Settings.Header", Settings.Header, "table");

			if Settings.Header.Color then
				AssertType("Settings.Header.Color", Settings.Header.Color, "Color3");
				Appbar.TopHeader.TextColor3 = Settings.Header.Color;
			end

			if Settings.Header.Text then
				-- No checks here because it might be a number, a Color3 value, we will never know.
				Appbar.TopHeader.TextColor3 = tostring(Settings.Header.Text);
			end
		end

		if Settings.BorderColor then
			AssertType("Settings.BorderColor", Settings.BorderColor, "Color3");

			Appbar.Border.BackgroundColor3 	= Settings.BorderColor;
		end
	end

	-- Applying height-dependent metrics
	local LeftIcon 							= Appbar.TopLeftButton;
	local RightIcon 						= Appbar.TopRightButton;
	local LeftAltIcon 						= Appbar.TopLeftButton_alt;
	local RightAltIcon						= Appbar.TopRightButton_alt;

	LeftIcon.Size 							= UDim2.new(0, Height - 32, 0, Height - 32);
	RightIcon.Size 							= UDim2.new(0, Height - 32, 0, Height - 32);
	LeftAltIcon.Size 						= UDim2.new(0, Height - 32, 0, Height - 32);
	RightAltIcon.Size						= UDim2.new(0, Height - 32, 0, Height - 32);

	--LeftIcon.Position 					= UDim2.new(0, 16, 0, 16); -- Not height-dependent
	RightIcon.Position 						= UDim2.new(1, -16 - Height + 32, 0, 16);
	LeftAltIcon.Position 					= UDim2.new(0, -16 - Height + 32, 0, 16);
	RightAltIcon.Position					= UDim2.new(1,  16 + Height - 32, 0, 16);

	Appbar.Size 							= UDim2.new(0, 1, 0, Height);

	Appbar.Parent 							= Core:GetOverlay();

	Core:SetContentFrame(ContentFrame, Appbar);
	Core:LockParent(Appbar);

	Appbar.AncestryChanged:connect(function(_, NewParent)
		if NewParent == nil then
			IntentService:BroadcastIntent("AppbarDestroyed", AppbarInstance);
		end
	end);

	return AppbarInstance, TweenAppbarIn(AppbarInstance, ContentFrame, Tween, Duration, Async);
end



function InstanceFunctions:TweenBarColor(NewColor, NewBorderColor, Tween, Duration, Async)
	AssertType("Argument #1", NewColor, "Color3");
	AssertType("Argument #2", NewBorderColor, "Color3");
	AssertType("Argument #3", Tween, 	"string", 	true);
	AssertType("Argument #4", Duration, "number", 	true);
	AssertType("Argument #5", Async, 	"boolean", 	true);

	local TextObject 		= self:GetTextObject();
	local MainTextObject	= TextObject:GetMainObject();
	local AltTextObject 	= TextObject:GetAltObject();
	local BorderFrame 		= self:GetRaw().Border;

	-- Wonder if I should do a debounce here or let the user handle it.
	local function Runner()
		spawn(function() 	self:GetRaw() :TweenColor3(	NewColor,	Tween,	Duration); end);
		spawn(function() 	MainTextObject:TweenColor3( NewColor,	Tween,	Duration); end);
		spawn(function() 	AltTextObject :TweenColor3( NewColor,	Tween,	Duration); end);
							BorderFrame   :TweenColor3( NewBorderColor, Tween, 	Duration);
	end
	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

function InstanceFunctions:GetRaw()
	return SharedVariables[self].Raw;
end

function InstanceFunctions:GetRealContentFrame()
	return SharedVariables[self].ContentFrame;
end

local ir,il,to = setmetatable({},{__mode = 'k'}),setmetatable({},{__mode = 'k'}),setmetatable({},{__mode = 'k'});

function InstanceFunctions:GetLeftIcon()
	if not il[self] then
		local Appbar 			= self:GetRaw();
		local Icon 				= Appbar.TopLeftButton;
		local AltIcon 			= Appbar.TopLeftButton_alt;

		il[self] = IconInstance.new("Left", Icon, AltIcon, self);
	end
	return il[self];
end

function InstanceFunctions:GetRightIcon()
	if not ir[self] then
		local Appbar 			= self:GetRaw();
		local Icon 				= Appbar.TopRightButton;
		local AltIcon 			= Appbar.TopRightButton_alt;

		ir[self] = IconInstance.new("Right", Icon, AltIcon, self);
	end
	return ir[self];
end

function InstanceFunctions:GetTextObject()
	if not to[self] then
		local Appbar 			= self:GetRaw();
		local MainObject 		= Appbar.TopHeader;
		local AltObject 		= Appbar.TopHeader_alt;

		to[self] 				= TextInstance.new(MainObject, AltObject, self);
	end
	return to[self];
end

function InstanceFunctions:Destroy(Tween, Duration, Async)
	return TweenAppbarOut(self, Tween, Duration, true, Async);
end

function InstanceFunctions:Show(Tween, Duration, Async)
	return TweenAppbarIn(self, Tween, Duration, Async);
end

function InstanceFunctions:Hide(Tween, Duration, Async)
	return TweenAppbarOut(self, Tween, Duration, false, Async);
end

function InstanceFunctions:GetHeight()
	return SharedVariables[self].Height;
end

return cAppbarInstance; -- I don't return userdata because the thing is only used in AppbarModule
