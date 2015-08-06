_G.ValkyrieC:LoadLibrary "Design";
_G.ValkyrieC:LoadLibrary "Util";
local Core          		= _G.ValkyrieC;
local cSidebarInstance     	= wrapper({});
local InstanceFunctions 	= {};

local Scrolling 			= require(script.Parent.Scrolling);

local SidebarTemplate 		= script.Parent.Sidebar;
local ItemTemplate 			= SidebarTemplate.Item;

local cItemInstance 		= require(script.Parent.cItemInstance);

local IntentService 		= Core:GetComponent "IntentService";
local SharedVariables 		= Core:GetComponent "References";

local SharedMetatable 		= {
	__tostring 				= function() return "Valkyrie Sidebar Instance"; end;
	__metatable 			= Core;
	__newindex 				= function(self, k, v)
		if SharedVariables[self][k] ~= nil then
			SharedVariables[self][k] = v;
		else
			error("I can't allow you to.", 2);
		end
	end;
	__index 				= InstanceFunctions;
	__len 					= function() return 0x224; end;
};

local function spawn(f)
	coroutine.wrap(f)();
end


local function TweenSidebarIn(self, ContentFrame, Tween, Duration, Async)
	IntentService:BroadcastIntent("SidebarTweeningIn", Tween, Duration, self);

	local Sidebar 			= self:GetRaw();
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
	IntentService:BroadcastIntent("SidebarTweeningOut", Tween, Duration, Destroy, self);

	local Sidebar 			= self:GetRaw();

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
	self.CanScrollDown		= true;
	if self:GetFirstItem() == 1 then
		return; -- Don't want to tween if we're as high as you can go.
	end
	self.FirstItem 			= self:GetFirstItem() - 1;

	self.NextAbsPos			= self:GetNAP() + 30 + (self:GetNAP() % 30 ~= 0 and 30 - self:GetNAP() % 30 or 0); -- Could probably be optimize but I'm lazy
	self:GetRaw().ItemContainer:TweenPosition(UDim2.new(0, 0, 0, 30 * -self:GetFirstItem() + 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1/6, true);
end

local function BackwardAnimate(self)
	local start = tick();
	local Start, End 		= self:GetShownItemIndices();
	local Modifier 			= 30;

	local ItemContainer 	= self:GetRaw().ItemContainer;
	if not self:CanScrollDown() then
		return;
	end

	if self:GetNAP() and self:GetNAP() - 30 <= self:GetRaw().AbsoluteSize.Y then
		Modifier			= self:GetRaw().AbsoluteSize.Y % 30;
		self.CanScrollDown	= false;
	else
		self.FirstItem 		= self:GetFirstItem() + 1;
	end
	self.NextAbsPos 		= (self:GetNAP() or self:GetItems()[#self:GetItems()].AbsolutePosition.Y + Modifier) - Modifier;

	self:GetRaw().ItemContainer:TweenPosition(UDim2.new(0, 0, 0, 30 * -self:GetFirstItem() + Modifier), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1/6, true);
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
	AssertType("Argument #2", Tween, 	"string",  true);
	AssertType("Argument #3", Duration, "number",  true);
	AssertType("Argument #4", Async,	"boolean", true);

	local Sidebar 							= SidebarTemplate:Clone();
	local SidebarInstance	 				= newproxy(true);
	local ContentFrame 						= Instance.new("Frame", Core:GetContentFrame());
	ContentFrame.BorderSizePixel			= 0;
	ContentFrame.BackgroundTransparency		= 1;
	ContentFrame.Size 						= UDim2.new(1, 0, 1, 0);
	ContentFrame.Name 						= "ContentFrame_Sidebar";

	SharedVariables[SidebarInstance]		= {Raw = Sidebar, Items = {}, FirstItem = 1, ContentFrame = ContentFrame, NextAbsPos = false, CanScrollDown = true};
	CopyMetatable(SidebarInstance, SharedMetatable);

	Sidebar.Item:Destroy();

	if Settings then
		AssertType("Argument #1", Settings, "table");

		if Settings.Items then
			AssertType("Settings.Items", Settings.Items, "table");

			for i = 1, #Settings.Items do
				AssertType(string.format("Settings.Items[%d]", i), Settings.Items[i], "table");

				table.insert(SharedVariables[SidebarInstance].Items, CreateItemWithSettings(Settings.Items[i], i - 1, Sidebar));

				if Settings.Items[i].Callback then -- Need to do this AFTER the item has been inserted
					AssertType("Settings.Callback", Settings.Items[i].Callback, "function");

					SidebarInstance:GetItem(i):SetCallback(Settings.Items[i].Callback);
				end
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

	--[[IntentService:RegisterIntent("AppbarTweeningIn", function() Why was I doing this?
		Sidebar.Parent 					= Core:GetOverlay():FindFirstChild("ContentFrame");
	end);
	IntentService:RegisterIntent("AppbarDestroyed",  function()
		Sidebar.Parent 					= Core:GetOverlay();
	end); -- NOT AppbarTweeningOut because need to go with the animation till the end]]

	Sidebar.MouseWheelForward:connect(function()
		ForwardAnimate(SidebarInstance);
	end);
	Sidebar.MouseWheelBackward:connect(function()
		BackwardAnimate(SidebarInstance);
	end);
	Sidebar.AncestryChanged:connect(function(_, NewParent)
		if NewParent == nil then
			IntentService:BroadcastIntent("SidebarDestroyed", SidebarInstance);
		end
	end);

	Scrolling:BindScrolling(Sidebar);
	Sidebar.Parent 						= Core:GetContentFrame();
	Core:SetContentFrame(ContentFrame, Sidebar);

	return SidebarInstance, TweenSidebarIn(SidebarInstance, ContentFrame, Tween, Duration, Async);
end

function InstanceFunctions:GetNumItems()
	return #self:GetItems();
end

function InstanceFunctions:GetRaw()
	return SharedVariables[self].Raw;
end
function InstanceFunctions:GetNAP()
	return SharedVariables[self].NextAbsPos;
end
function InstanceFunctions:GetRealContentFrame()
	return SharedVariables[self].ContentFrame;
end
function InstanceFunctions:GetFirstItem()
	return SharedVariables[self].FirstItem;
end
function InstanceFunctions:GetItems()
	return SharedVariables[self].Items;
end
function InstanceFunctions:CanScrollDown()
	return SharedVariables[self].CanScrollDown;
end

local Overlay = Core:GetOverlay();
function InstanceFunctions:GetShownItemIndices()
	local Start 						= self:GetFirstItem();
	local End 							= nil;
	local didStart 						= false;

	local Items = self:GetItems();
	local resY = Overlay.AbsoluteSize.Y;
	for i = math.max(1, Start - 1), #Items do
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
		End 							= #Items - 1;
	end

	return Start, End;
end

local ItemCache = {};

function InstanceFunctions:GetItem(Index)
	if not ItemCache[self] then
		ItemCache[self] 	= {};
	end
	if not ItemCache[self][Index] then
		local ItemInstance 	= cItemInstance.new(self:GetItems()[Index]);
		ItemCache[self][Index] = ItemInstance;
		return ItemInstance;
	end
	return ItemCache[self][Index];
end

function InstanceFunctions:Destroy(Tween, Duration, Async)
	return TweenSidebarOut(self, self:GetRealContentFrame(), Tween, Duration, true, Async);
end

function InstanceFunctions:Show(Tween, Duration, Async)
	return TweenSidebarIn(self, self:GetRealContentFrame(), Tween, Duration, Async);
end

function InstanceFunctions:Hide(Tween, Duration, Async)
	return TweenSidebarOut(self, self:GetRealContentFrame(), Tween, Duration, false, Async);
end

return cSidebarInstance;
