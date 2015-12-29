local c = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:wait();
print("Loading Valkyrie Client");
require(script.Parent:WaitForChild("Valkyrie"));
wait();
script.Parent.ValkyrieClient.Parent = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
print("Loaded Valkyrie Client");