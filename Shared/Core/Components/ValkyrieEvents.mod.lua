-- Supply custom events
local Event = {};

local Events = setmetatable({},{__mode = 'k'});
local InstantEvents = setmetatable({},{__mode = 'k'});
local Intents = setmetatable({},{__mode = 'k'});
local Intercept = setmetatable({},{__mode = 'k'});
local Listeners = setmetatable({},{__mode = 'k'});
local TempHolders = setmetatable({},{__mode = 'k'});
local IntentService

local connection do
	-- Constructor for custom Connection objects
	local finishers = setmetatable({},{__mode = 'k'});
	local disconnectAction = function(self)
		if not self then
			error("[Error][Valkyrie Events] (in connection:disconnect()): No connection given. Did you forget to call this as a method?", 2);
		end
		if finishers[self] then
			finishers[self](self);
			finishers[self] = nil;
		else
			warn("[Warn][Valkyrie Events] (in connection:disconnect()): Unable to disconnect disconnected connection for ValkyrieEvents");
		end;
	end;
	local cmt = {
		__index = function(t,k)
			if k == 'disconnect' then
				return disconnectAction;
			end;
		end;
		__metatable = "Locked metatable: Valkyrie";
		__tostring = function()
			return "Connection object for ValkyrieEvents";
		end;
	};
	connection = function(disconnectFunc)
		local newConnection = newproxy(true);
		local newMt = getmetatable(newConnection);
		for e,m in next, cmt do
			newMt[e] = m;
		end;
		finishers[newConnection] = disconnectFunc;
		return newConnection;
	end;
end;

local eClass = {
	fire = function(self, ...)
		local e = Events[self];
		local ar = {...};
		for i=1,#e do
			local f = e[i] -- e i o
			-- And old McDonald had a sheep
			local tmp;
			if Intercept[self] then
				tmp = Intercept[self](...)
			end;
			if not tmp then
				TempHolders[self] = ar;
				Listeners[self]:Fire();
				spawn(function() f(unpack(ar)) end);
			else
				return tmp
			end;
		end;
	end;
	connect = function(self, f)
		local e = Events[self];
		e[#e+1] = f;
		return connection(function()
			local didfind = false;
			for i=1, #e do
				if e[i] == f then
					e[i] = nil;
					didfind = true;
				elseif didfind then
					e[i-1] = e[i];
					e[i] = nil;
				end;
			end;
		end);
	end;
	wait = function(self)
		Listeners[self].Event:wait();
		return unpack(TempHolders[self]);
	end;
	intercept = function(self, f)
		local old = Intercept[self];
		IntentService:BroadcastIntent("Event.InterceptChanged", self, old, f);
		Intercept[self] = f;
		return old;
	end;
};
eClass.Fire = eClass.fire;
eClass.Intercept = eClass.intercept;
local ieClass = {
	fire = function(self, ...)
		local e = InstantEvents[self];
		for i=1,#e do
			local f = e[i] -- e i o
			-- And old McDonald had a sheep
			local tmp;
			if Intercept[self] then
				tmp = Intercept[self](...);
				-- Some time later, prevent yields in intercepts
			end;
			if not tmp then
				TempHolders[self] = ar;
				Listeners[self]:Fire();
				coroutine.wrap(f)(...);
			else
				return tmp
			end;
		end;
	end;
	connect = function(self, f)
		local e = InstantEvents[self];
		e[#e+1] = f;
		return connection(function()
			local didfind = false;
			for i=1, #e do
				if e[i] == f then
					e[i] = nil;
					didfind = true;
				elseif didfind then
					e[i-1] = e[i];
					e[i] = nil;
				end;
			end;
		end);
	end;
	wait = function(self)
		Listeners[self].Event:wait();
		return unpack(TempHolders[self]);
	end;
};
ieClass.Fire = ieClass.fire
ieClass.Intercept = eClass.intercept;
ieClass.intercept = eClass.intercept;
local iClass = {
	Fire = function(self,...)
		return IntentService:FireIntent(Intents[self],f);
	end;
	connect = function(self,f)
		return IntentService:RegisterIntent(Intents[self],f);
	end;
	Invoke = function(self,...)
		return IntentService:InvokeIntent(Intents[self],f);
	end;
};

local BaseMt = {
	__tostring = function()
		return "Valkyrie event object";
	end;
	__metatable = "Locked metatable: Valkyrie";
};

Event.new = function(type,iname)
	local ni = newproxy(true);
	local mt = getmetatable(ni);
	for e,m in next, BaseMt do
		mt[e] = m;
	end;
	if type == 'Event' then
		mt.__index = eClass;
		Events[ni] = {};
	elseif type == 'InstantEvent' then
		mt.__index = ieClass;
		InstantEvents[ni] = {};
	elseif type == 'Intent' then
		mt.__index = iClass;
		if not iname then
			return error("[Error][Valkyrie Input] (in Event.new()): No valid Intent name was supplied as #2", 2);
		end;
		Intents[ni] = iname;
	else
		return error("[Error][Valkyrie Input] (in Event.new()): No valid event type was given", 2);
	end;
	Listeners[ni] = Instance.new("BindableEvent");
	return ni;
end;

local ni = newproxy(true);
local mt = getmetatable(ni);
mt.__index = function(t,k)
	IntentService = _G.Valkyrie:GetComponent "IntentService";
	mt.__index = Event;
	return t[k];
end;
mt.__metatable =	"Locked metatable: Valkyrie";
mt.__tostring = function()
	return "Valkyrie event controller";
end;

return ni;
