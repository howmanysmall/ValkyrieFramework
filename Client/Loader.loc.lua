local Player = game.Players.LocalPlayer;
local c = Player.Character or Player.CharacterAdded:wait();
print("Loading Valkyrie Client");
Player:WaitForChild("ValkyrieClient").Parent = Player:WaitForChild("PlayerScripts")
require(script.Parent:WaitForChild("ValkyrieClient").Valkyrie);
print("Loaded Valkyrie Client");