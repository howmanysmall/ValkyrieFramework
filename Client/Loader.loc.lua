--game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(0);
local oprint	= print;
require(script.Parent:WaitForChild("Valkyrie"));
_G.ValkyrieC:LoadLibrary "Design";
oprint(table.insert);
local a = _G.ValkyrieC:GetComponent"DataTypes";
game.StarterGui:SetCoreGuiEnabled("All", false);
local is ={
	{Text = "Hello", BackgroundColor = Color3.Red};
	{Text = "World!", BackgroundColor = Color3.DeepOrange};
	{Text = "And all who", BackgroundColor = Color3.Amber};
};
for i = 1, 30 do
	table.insert(is, {Text = "Hello", BackgroundColor = Color3.Blue});
end
local sb = _G.ValkyrieC:GetComponent "SidebarModule":CreateSidebar({Items = is, BorderColor = Color3.Grey[300]});
local i  = sb:GetItem(1);
i:TweenOnX(100, 1, "inQuad", false);

i:TweenBackgroundColor(Color3.Green, 5, "inQuint", false);

sb:GetItem(3):TweenOnX(-100, 1, "inOutQuad", false);

game.StarterGui:SetCoreGuiEnabled("All", false);

require(script.HealthBar)();