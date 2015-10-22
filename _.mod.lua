-- Load and inject me woo
-- Also auth.
local script = script;
local wait = wait;
local game = game;
local workspace = workspace;
local type = type;
local next = next;
local setfenv = setfenv;
local assert = assert;
local _G = _G;
local require = require;
local pcall = pcall;
local setmetatable,getmetatable = setmetatable,getmetatable;
local _GCore = {};
local rawset,rawget = rawset,rawget;
local newproxy = newproxy;
local tostring = tostring;
local error,warn,print = error,warn,print;
local string,table = string,table;
local unpack = unpack;
local os = os;
local spawn = spawn;
local getfenv = getfenv;
local Instance = Instance;
local select = select;
local rawget, rawset = rawget, rawset;
local ipairs = ipairs;
local cwrap = coroutine.wrap;
setfenv(0,{})
setfenv(1,{})
local repSpace = script.Shared;
local coreSettings = require(script.Core.Settings).Core;
local wviis = setmetatable({},{__mode = 'k'});

local echo = function(...) return ... end;
local pack = function(...) return {n=select('#',...),...} end;

do
	local useGlobalLib = true;
	coreSettings:RegisterSetting('UseGlobalLib',{
		get = function()
			return useGlobalLib;
		end;
		set = function(v)
			if type(v) == 'bool' then
				useGlobalLib = v;
			end
		end;
	})
end;

do
	local suc = pcall(setmetatable, _G, {
	__index = _GCore;
	__newindex = function(t,k,v)
		if not _GCore[k] then
		rawset(t,k,v);
		end
	end;
	__metatable = "Please do not try and modify _G after Valkyrie has modded it";
	});
	if not suc then
	warn("Valkyrie was unable to mod _G, so some things may not work");
	end
end

local Libraries = {};
local cxitio = {};
local function extract(...)
	if (...) == cxitio or wviis[...] then
	return select(2,...);
	else
	return ...
	end
end

-- Quickly get the GameID
local UId = game["CreatorId"]
local GId = "";
local URL = "http://gskw.noip.me:5678";

-- Script or its children must never be exposed directly,
-- as a result, they must be proxied.

local Components = {};
cxitio.GetComponent = function(...)
	local c = extract(...);
	assert(c, "You need to supply a component to get", 2);
	assert(type(c) == 'string' , "You did not supply a valid component type: Arg#2 must be a string", 2);
	assert(script.Core.Components:FindFirstChild(c) or repSpace.Core.Components:FindFirstChild(c) or Components[c], c.." is not a valid component!", 2);
	return script.Core.Components:FindFirstChild(c) and require(script.Core.Components[c]) or (repSpace.Core.Components:FindFirstChild(c) and require(repSpace.Core.Components[c]) or Components[c]);
end
cxitio.GetService = cxitio.GetComponent;

cxitio.SetComponent = function(...)
	local c,l = extract(...);
	assert(c, "You must supply a component to set", 2);
	assert(l, "You must supply a name to set the component as", 2);
	Components[l] = Components[l] or c;
end
cxitio.SetService = cxitio.SetComponent;

cxitio.GetSettings = function(...)
	local component = extract(...);
	if component then
		if component == "Core" then
			return coreSettings;
		elseif component == true then
			return require(script.Core.Settings).User;
		else
			return require(script.Core.Settings).Components[component];
		end;
	end
	return require(script.Core.Settings).Custom;
end;

cxitio.GetGID = function()
	return GId;
end

cxitio.GetURL = function()
	return URL;
end

do
	local loaded = setmetatable({},{__mode = 'k'});
	local libSpace = script.Libraries;
	local rlibSpace = repSpace.Libraries;
	local newWrapper = require(repSpace.Core.BaseLib);
	local gs = game.GetService;
	local ll;
	cxitio.LoadLibrary = function(...)
	local l = extract(...);
	assert(type(l) == 'string', "You must provide a string library name", 2);
	local lib = libSpace:FindFirstChild(l) or rlibSpace:FindFirstChild(l);
	if lib then
		lib = require(lib)
	elseif Libraries[l] then
		lib = Libraries[l];
	else
		error("You didn't supply a valid library to load.", 2);
	end;
	local _ENV = getfenv(2);
	if loaded[_ENV] then
		setfenv(lib, _ENV)(loaded[_ENV]);
	else
		local Wrapper = newWrapper(not coreSettings:GetSetting('UseGlobalLib'));
		Wrapper.wlist.ref[ll] = ll;
		wviis[Wrapper(cxitio)] = true;
		local newEnv = setmetatable({},{
			__index = function(_,k)
				local v = Wrapper.Overrides.Glob[k] or _ENV[k];
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
		setfenv(lib, newEnv)(Wrapper);
	end
	pcall(print,"Loaded library",l,"into",_ENV,"successfully");
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
		local private = extract(...)
		return newWrapper(type(private) == 'bool' and private or false);
	end;
end;
for k,v in next, cxitio do
	if type(v) == 'function' then
		setfenv(v,{})
	end
end

local vmt,ocxi do
	ocxi = cxitio;
	cxitio = newproxy(true);
	local mt = getmetatable(cxitio);
	vmt = mt;
	mt.__newindex = function() error("You're not allowed to change the top level of the core unless you want to really break stuff", 2) end;
	mt.__metatable = "Locked metatable";
	mt.__len = function() return 1337 end;
	mt.__tostring = function() return string.format("Valkyrie Core: %q (%d)",GId,UId); end;
end

_GCore._ValkyrieCores = cxitio;
_G._ValkyrieCores = cxitio;
_GCore._Valkyrie = cxitio;
_G._Valkyrie = cxitio;
_GCore.Valkyrie = cxitio;
_G.Valkyrie = cxitio;

local remoteComm = cxitio:GetComponent "RemoteCommunication";

vmt.__call = function(_, GID, CoKey)
	assert(type(GID) ~= 'table' and type(GID) ~= 'userdata' and type(CoKey) ~= 'table' and type(CoKey) ~= 'userdata',
		"You should not be passing a table or userdata, silly",2);
	GId = GID;
	require(script.Core.SecureStorage).Key = CoKey;
	local resp
	if not game:GetService("RunService"):IsStudio() then
		resp = remoteComm.auth:check({uid = UId}, GID, URL, CoKey, cxitio:GetComponent "RequestEncode", cxitio:GetComponent "RequestDecode");
	else
		resp = "Studio Bypass";
	end;

	if resp then
		print("Valkyrie Auth success: "..(resp == true and "Correct keypair" or resp));
	else
		return error("Valkyrie Auth failure!");
	end;

	local characterHandler = function(c)
		local p = game.Players:GetPlayerFromCharacter(c);
		if not p.PlayerGui:FindFirstChild("ValkyrieClient") then
			local vc = script.Client:Clone();
			vc.Name = "ValkyrieClient";
			for _,v in ipairs(repSpace.Core:GetChildren()) do
				if v ~= repSpace.Core.Components then
					v:Clone().Parent = vc.Core;
				end
			end
			for _,v in ipairs(repSpace.Core.Components:GetChildren()) do
				v:Clone().Parent = vc.Core.Components
			end
			for _,v in ipairs(repSpace.Libraries:GetChildren()) do
				v:Clone().Parent = vc.Libraries;
			end
			script.Server.ActivePlayers[c.Name].Overlay.Value = vc.ValkyrieOverlay;
			vc.Parent = p.PlayerGui;
		end
	end;
	local playerHandler = function(p)
		remoteComm.friends:setOnlineGame({id = p.userId, game = GID});
		local np = script.Server.Template:Clone();
		np.Player.Value = p;
		np.Parent = script.Server.ActivePlayers;
		np.Name = p.Name;
		np.Joined.Value = os.time();
		for k,v in next, np:GetChildren() do
			if v:IsA("ModuleScript") then cwrap(function(...) return require(...) end)(v) end;
		end
		p.CharacterAdded:connect(characterHandler);
		if p.Character then
			characterHandler(p.Character);
		end
	end;

	game.Players.PlayerAdded:connect(playerHandler)

	for k,p in next, game.Players:GetPlayers() do
		playerHandler(p)
	end

	game.Players.PlayerRemoving:connect(function(p)
		remoteComm.friends:goOffline({id = p.userId, time_ingame = os.time() - script.Server.ActivePlayers[p.Name].Joined.Value});
		script.Server.ActivePlayers[p.Name]:Destroy()
	end)

	do
		local gpn = Instance.new("RemoteFunction");
		gpn.Name = "GetPN";
		gpn.OnServerInvoke = function()
			return GID
		end
		gpn.Parent = game.ReplicatedStorage;
	end

	require(script.Shared.Core.Components.IntentService)
	print("Successfully authenticated Valkyrie for place",GID);
	vmt.__call = function() return cxitio end;
	vmt.__index = ocxi;
	return cxitio
end;

return cxitio;
