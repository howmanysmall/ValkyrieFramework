-- Handlers for individual players. Joy.
repeat wait() until _G.Valkyrie;
local Valkyrie = _G.Valkyrie;
local IntentService = Valkyrie:GetComponent("IntentService");
local Settings = Valkyrie:GetSettings("AntiCheat");
local Player = script.Parent.Player.Value;
local Decoder = Valkyrie:GetComponent("RequestDecode");
local ACHandle;
local count = 0;

local r = game:GetService("HttpService"):PostAsync(
    string.format(
        "%s/bans/isBanned/%s/%s",
        Valkyrie:GetURL(),
        Valkyrie:GetGID(),
        require(script.Parent.Parent.Parent.Parent.Core.SecureStorage).Key
    ),
    string.format("player=%d",Player.userId)
);
local resp = Decoder(r);
if resp.success then
    if resp.result[1] then
        Player:Kick(resp.result[2]);
    end;
else
    warn("Valkyrie could not get the ban status:"..resp.error,2);
end;
r=nil;

local function checkCount()
    if count >= Settings:GetSetting("KickLimit") then
        game:GetService("HttpService"):PostAsync(
            string.format(
                "%s/bans/createBan/%s/%s",
                Valkyrie:GetURL(),
                Valkyrie:GetGID(),
                require(script.Parent.Parent.Parent.Parent.Core.SecureStorage).Key
            ),
            ('player=%d;reason="You have been caught cheating"'):format(Player.userId)
        );
        Player:Kick(Settings:GetSetting("KickMessage") or "You have been kicked for cheating");
    end;
end;


do
    local CharacterHandler = function(c)
        if not Player.PlayerGui:FindFirstChild("ACHandle") then
            ACHandle = script.ACHandle:Clone();
            ACHandle.Parent = Player.PlayerGui;
            ACHandle.RPC.OnServerEvent:connect(function(p,r,...)
                if r == 'ValueChanged' then
                    local v,val = ...
                    if v.Value ~= val then
                        count = count+1;
                        checkCount();
                    end;
                elseif r == 'PhysicsFps' then
                    count = count+1;
                    checkCount();
                end;
            end);
        end;
    end;
    Player.CharacterAdded:connect(CharacterHandler);
    if Player.Character then CharacterHandler(Player.Character) end;
end;


IntentService:RegisterIntent("ACProtect", function(val)
    ACHandle.RPC:FireClient("ProtectValue", val);
end);

return true;
