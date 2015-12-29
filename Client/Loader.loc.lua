local c = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:wait();
script.Parent.ValkyrieClient.Parent = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
print("Loading Valkyrie Client");
require(script.Parent:WaitForChild("Valkyrie"));
print("Loaded Valkyrie Client");