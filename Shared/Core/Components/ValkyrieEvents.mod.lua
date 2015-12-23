-- Supply custom events
local Event = {};

local Events = setmetatable({},{__mode = 'k'});
local InstantEvents = setmetatable({},{__mode = 'k'});
local Intents = setmetatable({},{__mode = 'k'});
local IntentService = _G.Valkyrie:GetComponent "IntentService";

local connection do
	-- Constructor for custom Connection objects
	local finishers = setmetatable({},{__mode = 'k'});
	local disconnectAction = function(self)
		if not self then
			error("[Error][Valkyrie Events] (in connection:disconnect()): No connection given. Did you forget to call this as a method?", 2);
		if finishers[self] then
			finishers[self](self);
			finishers[self] = nil;
		else
			warn("[Warn][Valkyrie Events] (in connection:disconnect()): Unable to disconnect disconnected action for ValkyrieInput");
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
			return "Connection object for ValkyrieInput";
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
		for i=1,#e do
			local f = e[i] -- e i o
			-- And old McDonald had a sheep
			spawn(function() f(...) end);
		end;
	end;
	connect = function(self, f)
		local e = Events[self];
		e[#e+1] = f;
		return connection(function()
			local didfind = false;
			for i=1, #e do
				if e[i] = f then
					e[i] = nil;
					didfind = true;
				elseif didfind then
					e[i-1] = e[i];
					e[i] = nil;
				end;
			end;
		end);
	end);
	wait = function(self)
		local done,ret = false;
		local c = self:connect(function(...)
			done = true;
			ret = {...};
		end);
		repeat wait() until done end;
		c:disconnect();
		return unpack(ret);
	end;
};
eClass.Fire = eClass.fire;
local ieClass = {
	fire = function(self, ...)
		local e = InstantEvents[self];
		for i=1,#e do
			local f = e[i] -- e i o
			-- And old McDonald had a sheep
			coroutine.wrap(f)(...);
		end;
	end;
	connect = function(self, f)
		local e = InstantEvents[self];
		e[#e+1] = f;
		return connection(function()
			local didfind = false;
			for i=1, #e do
				if e[i] = f then
					e[i] = nil;
					didfind = true;
				elseif didfind then
					e[i-1] = e[i];
					e[i] = nil;
				end;
			end;
		end);
	end);
	wait = function(self)
		local done,ret = false;
		local c = self:connect(function(...)
			done = true;
			ret = {...};
		end);
		repeat wait() until done end;
		c:disconnect();
		return unpack(ret);
	end;
};
ieClass.Fire = ieClass.fire
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
	return ni;
end;

local ni = newproxy(true);
local mt = getmetatable(ni);
mt.__index = Event;
mt.__metatable =  "Locked metatable: Valkyrie";
mt.__tostring = function()
  return "Valkyrie event controller";
end;
return ni;
