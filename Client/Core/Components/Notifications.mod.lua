-- Notifications Module
local NotificationCache = {};
local NotificationLinks = setmetatable({},{__mode = 'k'});
local NotificationMt = {};

local IntentService = _G.Valkyrie:GetComponent("IntentService");

local extract;
local Controller = {};

-- When a new notification is made, add it to NotificationCache
-- Group similar Notifications
-- Add the ability to add buttons to the notifications.
-- On that note, you need callbacks for the buttons.
-- Make sure that you remove notifications when they are dismissed.

Controller.CreateNotification = function(...)
	local Settings = extract(...);
	assert(
		type(Settings) == 'table',
		"[Error][Notifications] (in CreateNotification): You need to supply a Settings table as argument #2"
		2
	);

	local Notification = newproxy(true);
	local mt = getmetatable(Notification);
	for e,m in next, NotificationMt do
		mt[e] = m;
	end;

	-- => NotificationCreated (Notification newNotification)
	IntentService:BroadcastIntent("NotificationCreated", Notification)

	-- -> Notification newNotification
	return Notification
end;

Controller.DismissNotification = function(...)
	local Notification = extract(...);
	assert(
		Notification and NotificationLinks[Notification],
		"[Error][Notifications] (in DismissNotification): You need to supply a Notification as argument #1",
		2
	);

	-- => RedrawNotifications ()
	IntentService:BroadcastIntent("RedrawNotifications");
end;

local r = newproxy(true);
local _mt = getmetatable(r);
_mt.__index = Controller;
_mt.__metatable = "Locked metatable: Valkyrie";
_mt.__tostring = function() return "Valkyrie Notifications Controller" end;

extract = function(...)
  if ... == r then
    return select(2, ...);
  else
    return ...
  end;
end;

return r
