local VCore = _G._ValkyrieCores
local DS = game:GetService("DataStoreService"):GetDataStore(VCore:GetGID())
local http = game:GetService("HttpService")
local Secure = require(script.Parent.Parent.SecureStorage)
local assert,print,error = assert,print,error;
local type = type;
local string = string;
local setfenv, getmetatable = setfenv, getmetatable;
local game = game;
local requester = VCore:GetComponent "RemoteCommunication";

local AchievementsManager = {};

local function assertMethod(self)
    assert(self == ret, "You should call this as a method of AchievementsManager.", 3); 
end

local function assertType(expected, value, arg)
    assert(type(value) == expected, ("Argument %q should be a %s"):format(arg, expected), 3);
end

function AchievementsManager:RegisterAchievement(reward, identification, name, description) -- Lemon.
    assertMethod(self);
    assertType("number", reward, "reward");
    assertType("string", identification, "identification");
    assertType("string", name, "name");
    assertType("string", description, "description");
    if not DS:GetAsync(identification) then
        -- If it's not here according to this game, register it!
        requester.achievements:register({reward = reward, id = identification, name = name, description = description});
		print("Registered:", reward, identification, name, description);
		DS:SetAsync(identification, true);
	else
		print("Already registered:", identification);
	end
end;

function AchievementsManager:AwardAchievement(user, identification)
    -- Get the data from the supplied argument.
    local userType = type(user);
    assert(user, "You must supply a user as Arg#1", 2);
    assert(identification, "You must supply an achievement id as Arg#2", 2);
    assertMethod(self);
    assertType("string", identification, "identification");
    if userType == 'string' then
        assert(game.Players:FindFirstChild(user), user .. " is not a valid player!", 2);
        user = game.Players:FindFirstChild(user).userId;
    elseif userType == 'userdata' then
        assert(pcall(function() if user.Parent ~= game.Players then error() else user = user.userId end end),"Invalid player", 2);
    elseif userType ~= 'number' then
        error("Invalid datatype for the user", 2);
    end
    requester.achievements:award({playerid = user, id = identification});
    print("Awarded achievement id "..identification.." awarded to user:",user);
end

local ret;
do
ret = newproxy(true);
local mt = getmetatable(ret);
mt.__index = function(_,k)
    local v = AchievementsManager[k];
    if type(v) == 'function' then
        return setfenv(v,{});
    else
        return v;
    end
end;
mt.__newindex = error;
mt.__tostring = function() return "Valkyrie Achievements Manager" end;
mt.__metatable = "Nobody messes with Valkyrie";
end

return ret;