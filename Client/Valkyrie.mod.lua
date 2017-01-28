local function pack(...) return {n=select('#',...),...} end;

local cxitio = {};
local r;

local function extract(...)
	if (...) == r then
		return select(2,...)
	else
		return ...
	end
end

local function echo(...) return ... end;

script.Parent:WaitForChild("Core"):WaitForChild("Components");
script.Parent.Core.Parent = script;
local coreSettings = require(script.Core:WaitForChild("Settings")).Core;

local Components = {};
cxitio.GetComponent = function(...)
	local c = extract(...)
	return _G.Freya.GetComponent("Valkyrie."..c)
end
cxitio.GetService = cxitio.GetComponent;

cxitio.SetComponent = function(...)
	local l,c = extract(...);
	_G.Freya.SetComponent("Valkyrie."..l, c)
end
cxitio.SetService = cxitio.SetComponent;

cxitio.GetSettings = function(...)
	return _G.Freya.Settings[...]
end;

local overlay = script.Parent.ValkyrieOverlay;
overlay = overlay:Clone();
local Player = game.Players.LocalPlayer;
local CharBind = function(c)
	if not Player.PlayerGui:FindFirstChild("ValkyrieOverlay") then
		overlay.Parent = Player.PlayerGui;
		overlay.Name = "ValkyrieOverlay";
	end;
	local humanoid = c:FindFirstChild("Humanoid")
	if not humanoid then
		-- Look for a Humanoid class
		local int = c:GetChildren();
		for i=1,#int do
			local v = int[i];
			if v:IsA("Humanoid") then
				humanoid = v;
				break;
			end;
		end;
		while not humanoid do
			-- Start listening
			local v = c.ChildAdded:wait();
			if v:IsA("Humanoid") then
				humanoid = v;
				break;
			end;
		end;
	end;
	humanoid.Died:wait();
	overlay.Parent = script;
end
Player.CharacterAdded:connect(CharBind);
if Player.Character then coroutine.wrap(CharBind)(Player.Character) end;
overlay.Parent = Player:WaitForChild("PlayerGui");
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
