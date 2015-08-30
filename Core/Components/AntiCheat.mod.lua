local cxitio = {};
local Settings = _G.Valkyrie:GetSettings("AntiCheat");
local IntentService = _G.Valkyrie:GetComponent("IntentService");
local r = newproxy(true);
local type = type;
local game = game;
local assert = assert;
local error = error;
local math = math;

local function extract(...)
	if (...) == r then
		return select(2,...);
	else
		return ...
	end
end;

do
	local kickmsg;
	Settings:RegisterSetting("KickMessage",{
		get = function() return kickmsg end;
		set = function(v)
			if type(v) == 'string' then
				kickmsg = v;
			else
				error("You should be supplying a string as the kick message", 3)
			end;
		end;
	});
	local kicklimit = 1;
	Settings:RegisterSetting("KickLimit",{
		get = function() return kicklimit end;
		set = function(v) 
			if type(v) == 'number' and v > 0 then
				kicklimit = math.ceil(v);
			else
				error("You must be supplying a number above 0 for the limit", 3);
			end;
		end;
	});
end;


cxitio.Protect = function(...)
	local Val = extract(...);
	assert(
		type(Val) == 'userdata' and pcall(game.GetService,game,Val),
		"You should be supplying an Instance as #1", 2
		);
	assert(
		Val.ClassName:find("Value$"),
		"You should be supplying a Value type Instance to protect", 2
		);
	IntentService:BroadcastIntent("ACProtect", Val);
end;

local mt = getmetatable(r);
mt.__index = cxitio;
mt.__tostring = function(a)
	return "Valkyrie Anticheat interface";
end;
mt.__metatable = "Locked metatable: Valkyrie";
mt.__len = function() return 6664201337 end;

return r;