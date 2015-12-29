local Player = game.Players.LocalPlayer;
local c = Player.Character or Player.CharacterAdded:wait();
print("Loading Valkyrie Client");
require(script.Parent:WaitForChild("ValkyrieClient").Valkyrie);
wait();
local ch = script.Parent.ValkyrieClient:GetChildren();
script.Parent.ValkyrieClient.Parent = Player:WaitForChild("PlayerScripts")
for i=1,#ch do
	ch[i].Parent = Player.PlayerScripts.ValkyrieClient;
end
print("Loaded Valkyrie Client");