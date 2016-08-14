-- Load and inject
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
local repSpace = script.Shared;
local coreSettings = require(script.Core.Settings).Core;
local http = game:GetService("HttpService");
local run = game:GetService("RunService");
local ValkAuth = Instance.new("BindableEvent");
getfenv(0).script = nil;
getfenv(1).script = nil;

local echo = function(...) return ... end;
local pack = function(...) return {n=select('#',...),...} end;

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

local cxitio = {};
local function extract(...)
	if (...) == cxitio then
		return select(2,...);
	else
		return ...
	end
end

-- Quickly get the GameID
local UId = game["CreatorId"]
local GId = "";
local URL = "https://valkyrie.crescentcode.net";

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

local remoteComm = ocxi.GetComponent "RemoteCommunication";

vmt.__call = function(_, GID, CoKey)
    if not (GID or CoKey) then
        -- Not authing, instead wait.
        ValkAuth.Event:wait()
        return cxitio
    end;
	assert(type(GID) ~= 'table' and type(GID) ~= 'userdata' and type(CoKey) ~= 'table' and type(CoKey) ~= 'userdata',
		"You should not be passing a table or userdata, silly",2);
	GId = GID;
  remoteComm.GiveDependencies(GID, URL, CoKey, ocxi.GetComponent "RequestEncode", ocxi.GetComponent "RequestDecode");
	local resp
	if not game:GetService("RunService"):IsStudio() then
		resp = remoteComm.Auth:Check({UID = UId});
	else
		resp = "Studio Bypass";
	end;

	if resp then
		print("Valkyrie Auth success: "..(resp == true and "Correct keypair" or resp));
	else
		return error("Valkyrie Auth failure: Response was " .. tostring(resp));
	end;

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
	vc.Parent = game.StarterPlayer.StarterPlayerScripts;

	vmt.__call = function() return cxitio end;
	vmt.__index = ocxi;

	local ValkyrieSSS = Instance.new("Folder");
	ValkyrieSSS.Name = "Valkyrie";
	for k,v in next, script.Server:GetChildren() do
		if v.Name ~= 'Template' then
			v.Parent = ValkyrieSSS;
		end;
	end;
	ValkyrieSSS.Parent = game.ServerScriptService;

	local playerHandler = function(p)
		local np = script.Server.Template:Clone();
		np.Player.Value = p;
		np.Name = p.Name;
		np.Parent = ValkyrieSSS;
	end;
	game.Players.PlayerAdded:connect(playerHandler)

	for k,p in next, game.Players:GetPlayers() do
		playerHandler(p);
		script.Core.altLoader:Clone().Parent = p.PlayerGui;
	end

	game.Players.PlayerRemoving:connect(function(p)
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

	if not run:IsStudio() then
		-- Load up the Valkyrie Player tracker.
		require(342249737)(tostring(GID),tostring(CoKey));
	end;

	require(script.Shared.Core.Components.IntentService)
	print("Successfully authenticated Valkyrie for place",GID);

	ValkAuth:Fire();
	return cxitio
end;

print("Welcome to Valkyrie git-" .. script:WaitForChild("GitMeta"):WaitForChild("BranchID").Value .. "-" .. script.GitMeta:WaitForChild("HeadCommitID").Value:sub(1, 8));
print("Last updated by " .. script.GitMeta:WaitForChild("Author").Value .. ":\n" .. script.GitMeta:WaitForChild("HeadCommitText").Value);

return cxitio;
