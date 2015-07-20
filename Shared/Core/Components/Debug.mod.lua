local debug = {};
local r = newproxy(true);
local mt = getmetatable(r);
mt.__index = debug;

local print = print;
local error = error;
local warn = warn;

local isInstance = function(obj)
	if type(obj) == 'userdata' then
		local s,e = pcall(game.GetService, game, obj);
		return s and not e;
	end;
	return false;
end;

local logList = {};

local logLevel = 0;
-- Debug levels:
-- <1 Error only
-- -1 Warn
-- 0 Echo
-- 1 Info level 1
-- 2 Info level 2
-- 3 Verbose logging
-- 4+ Super verbose.

debug.error = function(e,l)
	local source = {};
	local i = l+1;
	while pcall(getfenv,i) do
		local fsource = setfenv(i,getfenv(i));
		local scriptsource = rawget(fsource,'script');
		if scriptsource and isInstance(scriptsource) then
			if scriptsource:IsA("Script") then
				scriptsource = ' in '..scriptsource:GetFullName();
			else
				scriptsource = '';
			end;
		else
			scriptsource = '';
		end;
		table.insert(source, tostring(fsource)..scriptsource);
	end;
	if i == 2 then
		source[1] = "C function";
	end;
	source = table.concat(source, "\n\tat ").."\n-------------------------------";
	print("[ERROR]",e,"\n",source);
	error(e,l);
end;

debug.warn = function(w)
	if logLevel <= -1 then
		warn("[WARN]"..tostring(w));
	end;
end;

debug.echo = function(...)
	if logLevel <= 0 then
		print("[ECHO]", ...);
	end;
end;

debug.log = function(...)
	
end

return r;