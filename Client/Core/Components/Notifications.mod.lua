local import = _G.Valkyrie.LoadLibrary;
import "Design"
import "Util"
local LocalPlayer = LocalPlayer;
local Valkyrie = _G.Valkyrie;
local IntentService = Valkyrie:GetComponent "IntentService";
local NotifOverlay = new "ScreenGui":Instance {
	Parent = LocalPlayer:WaitForChild "PlayerGui";
	Name = "Valkyrie Notificaiton Overlay";
};
local Settings = {
	DefaultTime = 1;
};

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
	n:Destroy();
	recalculatePositions();
end;

local HandleNotification = function(data)
	assert(type(data) == 'table', "You must supply a table with the data", 2);
	local notif = newNotification();
	local Text = rawget(data, 'Text');
	assert(type(Text) == 'string', "['Text'] must be a string", 2);
	local Image = rawget(data, 'Image');
	local Callback = rawget(data, 'Callback');
	local Time = rawget(data, 'Time') or Settings.DefaultTime;
	new "TextLabel":Instance {
		Parent = notif;
		Size = new 'UDim2' (1, Image and -32 or 0, 1, 0);
		Position = new 'UDim2' (0, Image and 32 or 0, 0, 0);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
	};
	if Image then
		new "ImageLabel":Instance {
			Image = Image;
			Size = new 'UDim2' (0,32,0,32);
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
	delay(Time,function()
		removeNotif(notif)
		recalculatePositions();
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
	delay(Settings.DefaultTime,function()
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

mt.__index = ControllerProxy;
mt.__newindex = function(t,k,v)
	assert(v ~= nil, "You can't set the values to nil :c", 2);
	Settings[k] = v;
end;
mt.__tostring = function()
	return "Valkyrie Notifications Controller"
end;
mt.__metatable = "Locked Metatable: Valkyrie";
mt.

return NotificationController;