-- Load and inject
-- Also auth.
local script = script
local wait = wait
local game = game
local workspace = workspace
local type = type
local next = next
local setfenv = setfenv
local assert = assert
local _G = _G
local require = require
local pcall = pcall
local setmetatable, getmetatable = setmetatable, getmetatable
local _GCore = { }
local rawset, rawget = rawset, rawget
local newproxy = newproxy
local tostring = tostring
local error, warn, print = error, warn, print
local string,table = string,table
local unpack = unpack
local os = os
local spawn = spawn
local getfenv = getfenv
local Instance = Instance
local select = select
local rawget, rawset = rawget, rawset
local ipairs = ipairs
local cwrap = coroutine.wrap
local repSpace = script.Shared
local http = game:GetService("HttpService")
local run = game:GetService("RunService")
local ValkAuth = Instance.new("BindableEvent")
getfenv(0).script = nil
getfenv(1).script = nil

local echo = function(...) return ... end
local pack = function(...) return { n = select('#', ...), ... } end

local cxitio = { }
local function extract(...)
	if (...) == cxitio then
		return select(2, ...)
	else
		return ...
	end
end

-- Quickly get the GameID
local UId = game["CreatorId"]
local GId = ""
local URL = "https://valkyrie.crescentcode.net"

cxitio.GetComponent = function(...)
	local c = extract(...)
	return _G.Freya:GetComponent("Valkyrie." .. c)
end
cxitio.GetService = cxitio.GetComponent

cxitio.SetComponent = function(...)
	local c, l = extract(...)
	_G.Freya:SetComponent("Valkyrie." .. l, c)
end
cxitio.SetService = cxitio.SetComponent

cxitio.GetSettings = function(s)
	return _G.Freya.Settings[s]
end

cxitio.GetGID = function()
	return GId
end

cxitio.GetURL = function()
	return URL
end

for k, v in pairs(script.Core.Components:GetChildren()) do
	cxitio.SetComponent(v.Name, require(v))
end
for k, v in pairs(repSpace.Core.Components:GetChildren()) do
	cxitio.SetComponent(v.Name, require(v))
end

local vmt, ocxi do
	ocxi = cxitio
	cxitio = newproxy(true)
	local mt = getmetatable(cxitio)
	vmt = mt
	mt.__newindex = function() error("You're not allowed to change the top level of the core unless you want to really break stuff", 2) end
	mt.__metatable = "Locked metatable"
	mt.__len = function() return 1337 end
	mt.__tostring = function() return ("Valkyrie Core: %q (%d)"):format(GId, UId) end
end

_G._Valkyrie = cxitio
_G.Valkyrie = cxitio

local remoteComm = ocxi.GetComponent "RemoteCommunication"

vmt.__call = function(_, GID, CoKey)
	if not (GID or CoKey) then
		-- Not authing, instead wait.
		ValkAuth.Event:Wait()
		return cxitio
	end
	assert(type(GID) ~= 'table' and type(GID) ~= 'userdata' and type(CoKey) ~= 'table' and type(CoKey) ~= 'userdata',
		"You should not be passing a table or userdata, silly",2)
	GId = GID
	remoteComm.GiveDependencies(GID, URL, CoKey, ocxi.GetComponent "RequestEncode", ocxi.GetComponent "RequestDecode")
	local resp
	if not game:GetService("RunService"):IsStudio() then
		resp = remoteComm.Auth:Check({ UID = UId })
	else
		resp = "Studio Bypass"
	end

	if resp then
		print("Valkyrie Auth success: "..(resp == true and "Correct keypair" or resp))
	else
		return error("Valkyrie Auth failure: Response was " .. tostring(resp))
	end

	local vc = script.Client:Clone()
	vc.Name = "ValkyrieClient"
	for _, v in ipairs(repSpace.Core:GetChildren()) do
		if v ~= repSpace.Core.Components then
			v:Clone().Parent = vc.Core
		end
	end
	for _, v in ipairs(repSpace.Core.Components:GetChildren()) do
		v:Clone().Parent = vc.Core.Components
	end
	vc.Parent = game.StarterPlayer.StarterPlayerScripts

	vmt.__call = function() return cxitio end
	vmt.__index = ocxi

	for k, p in pairs(game.Players:GetPlayers()) do
		script.Core.altLoader:Clone().Parent = p.PlayerGui
	end

	if not run:IsStudio() then
	--// Valkyrie Player Tracker
		require(342249737)(tostring(GID), tostring(CoKey))
	end
	print("Successfully authenticated Valkyrie for place", GID)

	ValkAuth:Fire()
	return cxitio
end

print("Welcome to Valkyrie git-" .. script:WaitForChild("GitMeta"):WaitForChild("BranchID").Value .. "-" .. script.GitMeta:WaitForChild("HeadCommitID").Value:sub(1, 8))
print("Last updated by " .. script.GitMeta:WaitForChild("Author").Value .. ":\n" .. script.GitMeta:WaitForChild("HeadCommitText").Value)

return cxitio
