local CanScrollDown			= {};
local NextAbsPos 			= {};

_G.ValkyrieC:LoadLibrary "Design";
local Core          		= _G.ValkyrieC;
local cSidebarInstance     	= {};
local InstanceFunctions 	= {};

local Util 					= require(script.Parent.Util);
local Scrolling 			= require(script.Parent.Scrolling);
local AssertType, RunAsync 	= Util.AssertType, Util.RunAsync;

local SidebarTemplate 		= script.Parent.Sidebar;
local ItemTemplate 			= SidebarTemplate.Item;

local cItemInstance 		= require(script.Parent.cItemInstance);

local IntentService 		= Core:GetComponent "IntentService";

local function spawn(f)
	coroutine.wrap(f)();
end


local function TweenSidebarIn(self, ContentFrame, Tween, Duration, Async)
	IntentService:BroadcastIntent("SidebarTweeningIn", Tween, Duration, self);

	local Sidebar 			= self.Raw;
	Sidebar.Position 		= UDim2.new(0, -Sidebar.AbsoluteSize.X, 0, 0);

	local function Runner()
		spawn(function() Sidebar 		:VTweenPosition(UDim2.new(0, 0, 0, 0), 							 Tween, Duration); end);
		spawn(function() ContentFrame 	:VTweenPosition(UDim2.new(0, Sidebar.AbsoluteSize.X + 2, 0, 0),  Tween, Duration); end);
						 ContentFrame  	:VTweenSize    (UDim2.new(1, -Sidebar.AbsoluteSize.X - 2, 0, 0), Tween, Duration);
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

local function TweenSidebarOut(self, ContentFrame, Tween, Duration, Destroy, Async)
	IntentService:BroadcastIntent("SidebarTweeningOut", Tween, Duration, Destroy, Sidebar);

	local Sidebar 			= self.Raw;
	local ContentFrame 		= self.ContentFrame;

	local function Runner()
		spawn(function() Sidebar 		:VTweenPosition(UDim2.new(0, -Sidebar.AbsoluteSize.X - 2, 0, 0), 	Tween, Duration); end);
		spawn(function() ContentFrame 	:VTweenPosition(UDim2.new(0, 0, 0, 0),  							Tween, Duration); end);
						 ContentFrame  	:VTweenSize    (UDim2.new(1, 0, 0, 0),								Tween, Duration);

		if Destroy then
			Core:SetContentFrame(Core:GetContentFrame().Parent);
			Sidebar:Destroy();
			ContentFrame:Destroy();
		end
	end

	if Async then
		return RunAsync(Runner);
	else
		Runner();
	end
end

local function ForwardAnimate(self)
	local start = tick();
	local Start 			= self:GetShownItemIndices();
	CanScrollDown[self]		= true;
	if self.FirstItem == 1 then
		return; -- Don't want to tween if we're as high as you can go.
	end
	self.FirstItem 			= self.FirstItem - 1;

	NextAbsPos[self]		= NextAbsPos[self] + 30 + (NextAbsPos[self] % 30 ~= 0 and 30 - NextAbsPos[self] % 30 or 0);
	self.Raw.ItemContainer:TweenPosition(UDim2.new(0, 0, 0, 30 * -self.FirstItem + 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1/6, true);
end

local function BackwardAnimate(self)
	local start = tick();
	local Start, End 		= self:GetShownItemIndices();
	local Modifier 			= 30;

	local ItemContainer 	= self.Raw.ItemContainer;
	if not CanScrollDown[self] then
		return;
	end

	if NextAbsPos[self] and NextAbsPos[self] - 30 <= self.Raw.AbsoluteSize.Y then
		Modifier			= self.Raw.AbsoluteSize.Y % 30;
		CanScrollDown[self]	= false;
	else
		self.FirstItem 		= self.FirstItem + 1;
	end
	NextAbsPos[self] 		= (NextAbsPos[self] or self.Items[#self.Items].AbsolutePosition.Y + Modifier) - Modifier;

	self.Raw.ItemContainer:TweenPosition(UDim2.new(0, 0, 0, 30 * -self.FirstItem + Modifier), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1/6, true);
end

local function CreateItemWithSettings(Settings, Index, Sidebar)
	AssertType("Argument #1", Settings, "table");
	AssertType("Argument #2", Index, "number");
	local Item	 			= ItemTemplate:Clone();

	if Settings.BackgroundColor then
		AssertType("Settings.BackgroundColor", Settings.BackgroundColor, "Color3");

		Item.BackgroundColor3 			= Settings.BackgroundColor;
		Item.Extend1.BackgroundColor3	= Settings.BackgroundColor;
	end

	if Settings.TextColor then
		AssertType("Settings.TextColor", Settings.TextColor, "Color3");

		Item.TextColor3 				= Settings.TextColor;
	end

	if Settings.Text then
		Item.Text 						= tostring(Settings.Text);
	end

	Item.Position 						= UDim2.new(0, 10, 0, 30 * Index);
	Item.Name 							= "Item" .. Index;
	Item.Parent 						= Sidebar.ItemContainer;

	return Item;
end

function cSidebarInstance.new(Settings, Tween, Duration, Async)
	local Sidebar 						= SidebarTemplate:Clone();
	local FakeIndex 					= setmetatable({Raw = Sidebar, Items = {}, FirstItem = 1}, {__index = InstanceFunctions});

	Sidebar.Item:Destroy();

	if Settings then
		AssertType("Argument #1", Settings, "table");

		if Settings.Items then
			AssertType("Settings.Items", Settings.Items, "table");

			for i = 1, #Settings.Items do
				AssertType(string.format("Settings.Items[%d]", i), Settings.Items[i], "table");

				table.insert(FakeIndex.Items, CreateItemWithSettings(Settings.Items[i], i - 1, Sidebar));
			end
		end

		if Settings.BackgroundColor then
			AssertType("Settings.BackgroundColor", Settings.BackgroundColor, "Color3");

			Sidebar.BackgroundColor3 	= Settings.BackgroundColor;
		end

		if Settings.BorderColor then
			AssertType("Settings.BorderColor", Settings.BorderColor, "Color3");

			Sidebar.Border.BackgroundColor3	= Settings.BorderColor;
		end
	end

	Sidebar.AncestryChanged:connect(function(_, NewParent)
		if NewParent == nil then
			IntentService:BroadcastIntent("SidebarDestroyed");
		end
	end);

	IntentService:RegisterIntent("AppbarTweeningIn", function()
		Sidebar.Parent 					= Core:GetOverlay():FindFirstChild("ContentFrame");
	end);
	IntentService:RegisterIntent("AppbarDestroyed",  function()
		Sidebar.Parent 					= Core:GetOverlay();
	end); -- NOT AppbarTweeningOut because need to go with the animation till the end

	local SidebarInstance;

	Sidebar.MouseWheelForward:connect(function()
		ForwardAnimate(SidebarInstance);
	end);
	Sidebar.MouseWheelBackward:connect(function()
		BackwardAnimate(SidebarInstance);
	end);

	Sidebar.Parent 						= Core:GetContentFrame();

	Sidebar.AncestryChanged:connect(function(_, NewParent)
		if NewParent == nil then
			IntentService:BroadcastIntent("SidebarDestroyed", SidebarInstance);
		end
	end);

	local ContentFrame 						= Instance.new("Frame", Core:GetContentFrame());
	ContentFrame.BorderSizePixel			= 0;
	ContentFrame.BackgroundTransparency		= 1;
	ContentFrame.Size 						= UDim2.new(1, 0, 1, 0);
	ContentFrame.Name 						= "ContentFrame";

	Core:SetContentFrame(ContentFrame, Sidebar);
	FakeIndex.ContentFrame 					= ContentFrame;

	SidebarInstance	 					= newproxy(true);
	CanScrollDown[SidebarInstance]		= true;
	Scrolling:BindScrolling(Sidebar);

	do
		local Metatable 				= getmetatable(SidebarInstance);
		Metatable.__tostring 			= function() return "Valkyrie Sidebar Instance"; end;
		Metatable.__metatable 			= Settings;
		Metatable.__newindex 			= function(_, k, v)
			if SidebarInstance[k] then
				rawset(FakeIndex, k, v); -- Why does this not set anything without rawset()?
			else
				error("I can't allow you to.", 2);
			end
		end;
		Metatable.__index 				= FakeIndex;
		Metatable.__len 				= function() return 0x224; end;
	end

	return SidebarInstance, TweenSidebarIn(SidebarInstance, ContentFrame, Tween, Duration, Async);
end

function InstanceFunctions:GetNumItems()
	return #self.Items;
end

local Overlay = Core:GetOverlay();
function InstanceFunctions:GetShownItemIndices()
	local Start 						= self.FirstItem;
	local End 							= nil;
	local didStart 						= false;

	local Items = self.Items;
	local resY = Overlay.AbsoluteSize.Y;
	for i=math.max(1,self.FirstItem-1), #Items do
		local absY = Items[i].AbsolutePosition.Y;
		if absY > -30 then
			Start = i;
			didStart = true;
		elseif absY > resY then
			End = i;
			break;
		end;
	end;

	if not End then
		End 							= #self.Items - 1;
	end

	return Start, End;
end

function InstanceFunctions:GetItem(Index)
	return cItemInstance.new(self.Items[Index]);
end

function InstanceFunctions:Destroy(Tween, Duration, Async)
	return TweenSidebarOut(self, self.ContentFrame, Tween, Duration, true, Async);
end

function InstanceFunctions:Show(Tween, Duration, Async)
	return TweenSidebarIn(self, self.ContentFrame, Tween, Duration, Async);
end

function InstanceFunctions:Hide(Tween, Duration, Async)
	return TweenSidebarOut(self, self.ContentFrame, Tween, Duration, false, Async);
end

return cSidebarInstance;
