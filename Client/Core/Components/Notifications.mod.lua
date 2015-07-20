local import = _G.Valkyrie.LoadLibrary;
import "Design"
import "Util"
local LocalPlayer = LocalPlayer;
local Valkyrie = _G.Valkyrie;
local IntentService = Valkyrie:GetComponent "IntentService";
local NotifOverlay = new "ScreenGui":Instance {
	Parent = LocalPlayer:WaitForChild "PlayerGui";
	Name = "Valkyrie Notification Overlay";
};
local DefaultTime;
do
	local Settings = Valkyrie:GetSettings("Notifications");
	DefaultTime = 1;
	Settings:RegisterSetting("DefaultTime", {
		set = function(t)
			if type(t) == 'number' then
				DefaultTime = math.max(t,0);
			end;
		end;
		get = function()
			return DefaultTime;
		end;
		});
end;

local deb = false;
LocalPlayer.PlayerGui.ChildAdded:connect(function(o)
	if not deb then
		deb = true
		if o ~= NotifOverlay then
			NotifOverlay.Parent = nil;
			NotifOverlay.Parent = LocalPlayer.PlayerGui;
		end;
		wait();
		deb = false;
	end;
end);
local notifications = setmetatable({},{__mode = 'v'});

local recalculatePositions = function()
	for i,v in ipairs(notifications) do
		spawn(function()
			v:VTweenPosition(
				new 'UDim2' (0,0,0,(i-1)*32),
				'outQuad',
				0.12
			);
		end);
	end;
end;

local newNotification = function()
	local newNotif = new "Frame":Instance {
		Size = new "UDim2" (1,0,0,32);
		BackgroundColor3 = Color3.Black;
		BackgroundTransparency = 0.5;
		Parent = NotifOverlay;
	};
	table.insert(notifications, newNotif);
	recalculatePositions();
	return newNotif;
end;

local removeNotif = function(n)
	for i,v in ipairs(notifications) do
		if v == n then table.remove(notifications,i) break end;
	end;
	n:TweenPosition(new UDim2 (0,0,0,-36), nil, nil, 0.12, nil, function()
		n:Destroy()
	end);
	recalculatePositions();
end;

local HandleNotification = function(data)
	assert(type(data) == 'table', "You must supply a table with the data", 2);
	local notif = newNotification();
	local Text = rawget(data, 'Text');
	assert(type(Text) == 'string', "['Text'] must be a string", 2);
	local Image = rawget(data, 'Image');
	local Callback = rawget(data, 'Callback');
	local Time = rawget(data, 'Time') or DefaultTime;
	new "TextLabel":Instance {
		Parent = notif;
		Size = new 'UDim2' (1, Image and -42 or -10, 1, 0);
		Position = new 'UDim2' (0, Image and 42 or 10, 0, 0);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Text = Text;
		TextColor3 = Color3.White;
		TextXAlignment = Enum.TextXAlignment.Left;
		FontSize = Enum.FontSize.Size18;
	};
	if Image then
		new "ImageLabel":Instance {
			Image = Image;
			Size = new 'UDim2' (0,32,0,32);
			Position = new 'UDim2' (0,10,0,0);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		};
	end;
	if Callback then
		new "TextButton":Instance {
			Text = '';
			Parent = notif;
			ZIndex = 2;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Size = new 'UDim2' (1,0,1,0);
		}.MouseButton1Click:connect(Callback);
	end;

	notif.Position = new 'UDim2' (0,0,0,-32);
	spawn(function() notif:VTweenPosition(new 'UDim2' (),'inQuad',0.12); end);

	delay(Time,function()
		removeNotif(notif)
	end);
end;

local HandlePlain = function(text, img)
	local notif = newNotification();
	local tl = new 'TextLabel':Instance {
		Parent = notif;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
	};
	if img then
		tl.Size = new 'UDim2' (1,-32,1,0);
		tl.Position = new 'UDim2' (0,32,0,0);
		new 'ImageLabel':Instance {
			Parent = notif;
			Size = new 'UDim2' (0,32,0,32);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		};
	else
		tl.Size = new 'UDim2' (1,0,1,0);
	end
	delay(DefaultTime,function()
		removeNotif(notif);
		recalculatePositions();
	end);
end;

IntentService:RegisterRPCIntent("ValkyrieNotification", HandlePlain);
IntentService:RegisterIntent("ValkyrieNotification", HandleNotification);

local NotificationController = newproxy(true);
local mt = getmetatable(NotificationController);
local ControllerProxy = {};

local extract = function(...)
	if (...) == NotificationController then
		return select(2,...);
	else
		return ...
	end;
end;

ControllerProxy.new = function(...)
	return HandleNotification(extract(...));
end;
ControllerProxy.newPlain = function(...)
	return HandlePlain(extract(...));
end;

mt.__index = ControllerProxy;
mt.__tostring = function()
	return "Valkyrie Notifications Controller"
end;
mt.__metatable = "Locked Metatable: Valkyrie";

return NotificationController;
