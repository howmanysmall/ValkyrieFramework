local function pack(...)
  return {n=select('#',...),...};
end;
local API = _G.Valkyrie:GetComponent"ValkyrieAdmin";
local Permissions = _G.Valkyrie:GetComponent"ValkyriePermissions";

Permissions:CreatePermission("Admin.Target.Kill");

return {
  kill = function(as, ...)
    local p = pack(...);
    for i=1,p.n do
      for player in API.GetMatching(as,p[i]) do
        if player.Character and Permissions:GetUserPermission(player, "Admin.Target.Kill") ~= false then
          player.Character:BreakJoints();
        end;
      end
    end;
  end;
  tp = function(as, who, where)
    local p;
    for player in API.GetMatching(where) do
      p = player; break;
    end;
    if (not p) or not (p.Character and p.Character:FindFirstChild("Torso")) then return end;
    for player in API.GetMatching(who) do
      if player.Character and player.Character:FindFirstChild("Torso") then
        player.Character.Torso.CFrame = p.Character.Torso;
      end
    end;
  end;
  kick = function(as, who)
    for player in API.GetMatching(who) do
      player:Kick();
    end;
  end;
}
