-- Yes thank you for taking the time to look at the clientside stuff
-- I hope you're proud of yourself.

local function pack(...) return {n=select('#',...),...} end;

local cxitio = {};
local r;
local wviis = setmetatable({},{__mode = 'k'});

local function extract(...)
	if (...) == r or wviis[...] then
		return select(2,...)
	else
		return ...
	end
end

local function echo(...) return ... end;

script.Parent:WaitForChild("Core"):WaitForChild("Components");
script.Parent.Core.Parent = script;
script.Parent:WaitForChild("Libraries").Parent = script;
local coreSettings = require(script.Core.Settings).Core;

do
	local useGlobalLib = true;
	coreSettings:RegisterSetting('UseGlobalLib', {
		get = function()
			return useGlobalLib;
		end;
		set = function(v)
			if type(v) == 'bool' then
				useGlobalLib = v;
			end;
		end;
	})
end
local Components = {};
cxitio.GetComponent = function(...)
	local c = extract(...)
	assert(c, "You need to supply a component to get", 2);
	assert(type(c) == 'string' , "You did not supply a valid component type: Must be a string", 2);
	assert(script.Core.Components:FindFirstChild(c) or Components[c], c.." is not a valid component!", 2);
	return script.Core.Components:FindFirstChild(c) and require(script.Core.Components[c]) or Components[c]
end
cxitio.GetService = cxitio.GetComponent;

cxitio.SetComponent = function(...)
	local l,c = extract(...);
	assert(c, "You must supply a component to set", 2);
	assert(l, "You must supply a name to set the component as", 2);
	Components[l] = Components[l] or c;
end
cxitio.SetService = cxitio.SetComponent;

cxitio.GetSettings = function(...)
	local component = extract(...);
	if component then
		if component == "Core" then
			return coreSettings
		else
			return require(script.Core.Settings).Components[component];
		end;
	end
	return require(script.Core.Settings).Custom;
end;

local overlay = script.Parent.ValkyrieOverlay;
overlay.Parent = script.Parent.Parent;
cxitio.GetOverlay = function() return overlay	end;

local CurrentContentFrame = nil;
cxitio.GetContentFrame = function() return CurrentContentFrame or overlay; end;
local LockedParents = {};
cxitio.SetContentFrame = function(...)
	local new, owner = extract(...);
	for _, Instance in next, (CurrentContentFrame and CurrentContentFrame.Parent or overlay):GetChildren() do
		if Instance ~= new and Instance ~= owner and not LockedParents[Instance] then
			pcall(function() Instance.Parent = new; end); -- Don't tell anybody and it should be fine...
		end
	end
	CurrentContentFrame = new;
end;
cxitio.LockParent = function(...)
	local Instance = extract(...);
	LockedParents[Instance] = true;
end

do
	local Libraries = {};
	local loaded = setmetatable({},{__mode = 'k'});
	local libSpace = script.Libraries;
	local newWrapper = require(script.Core.BaseLib);
	local gs = game.GetService;
	local ll;
	cxitio.LoadLibrary = function(...)
		local l = extract(...);
		assert(type(l) == 'string', "You must provide a string library name", 2);
		local lib = libSpace:FindFirstChild(l);
		if lib then
			lib = require(lib)
		elseif Libraries[l] then
			lib = Libraries[l];
		else
			error("You didn't supply a valid library to load.", 2);
		end;
		local _ENV = getfenv(2);
		if loaded[_ENV] then
			lib(loaded[_ENV]);
		else
			local Wrapper = newWrapper(not coreSettings:GetSetting('UseGlobalLib'));
			Wrapper.wlist.ref[ll] = ll;
			wviis[Wrapper(r)] = true;
			local newEnv = setmetatable({},{
				__index = function(_,k)
					local v = Wrapper.Overrides.Globals[k] or _ENV[k];
					if v then return v end;
					local s,v = pcall(game.GetService,game,k);
					if s then return v end;
				end;
				__newindex = function(_,k,v)
					warn("Settings global",k,"as",v);
					_ENV[k] = v;
				end;
				__metatable = "Locked metatable: Valkyrie Library Environment";
			});
			_ENV.wrapper = Wrapper;
			newEnv = Wrapper(newEnv);
			loaded[_ENV] = Wrapper;
			loaded[newEnv] = Wrapper;
			setfenv(2, newEnv);
			lib(Wrapper);
		end
		--pcall(print,"Loaded library",l,"into",_ENV,"successfully");
	end;
	ll = cxitio.LoadLibrary;
	cxitio.AddLibrary = function(...)
		local l,n = extract(...);
		assert(l, "You need to supply a library to add", 2);
		assert(n, "You need to supply a name to load the library as", 2);
		if type(l) == 'function' then
			Libraries[n] = l;
		elseif type(l) == 'userdata' and pcall(gs,game,l) and l:IsA("ModuleScript") then
			local s,e = pcall(cxitio.AddLibrary, require(l), n);
			if e and not s then error(e, 2) end;
		else
			error("Supplied library was not a function or ModuleScript", 2);
		end
	end;
	cxitio.GenerateWrapper = function(...)
		local private = extract(...);
		return newWrapper(type(private) == 'bool' and private or false)
	end;
end;

r = newproxy(true);
do
	local mt = getmetatable(r);
	mt.__metatable = "No thanks";
	mt.__index = cxitio;
	mt.__tostring = function() return "Valkyrie client API" end;
	mt.__len = function() return 1337 end;
end
_G._Valkyrie = r;
_G.Valkyrie  = r;
_G.ValkyrieC = r;
return r;
