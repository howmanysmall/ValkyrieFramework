local Player = game.Players.LocalPlayer
local c = Player.Character or Player.CharacterAdded:Wait()
print("Loading Valkyrie Client")
require(script.Parent:WaitForChild("Valkyrie"))
print("Loaded Valkyrie Client")
