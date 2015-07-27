--game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(0);
warn("Alright.");
require(script.Parent:WaitForChild("Valkyrie"));
_G.ValkyrieC:LoadLibrary "Design";

_G.ValkyrieC:GetComponent 
	"Logger"
	:Tag "AnimationManager"
	:Info "Playing 'walking' animation!"
	-- I thought it looked fun to do it like that

local Items = {};

for i = 1, 40 do
	table.insert(Items, {Text = "Hello", BackgroundColor = Color3.new(math.random(), math.random(), math.random())});
end
table.insert(Items, {Text = "Hello2"});

game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(0);

local sb = _G.ValkyrieC:GetComponent"SidebarModule":CreateSidebar{Items = Items};
sb:Hide("inQuad", 0.5, false);
sb:Show("outQuad", 0.5, false);
_G.ValkyrieC:GetComponent"Notifications".new{Text = "Testy Text", Time = 3};

--print(Color3.Red);

local appbar = _G.ValkyrieC:GetComponent "AppbarModule":CreateAppbar(
	{
		Color = Color3.Orange, -- If I uncomment the above print, this will crash while checking the type.
		BorderColor = Color3.Orange[600], 
		Header = {
			Color = Color3.White
		}, 
		LeftIcon = {
			Color = Color3.White,
			Callback = function() print"LeftCLICK"; end;
		},
		RightIcon = {
			Color = Color3.White,
			Callback = function() print"RightCLICK"; end;
		}
	}
);

appbar:TweenBarColor(Color3.Blue, Color3.Blue[600], "inquad", 1, true);
appbar:GetLeftIcon():TweenIconColor(Color3.Black, "incirc", 0.5, false);
appbar:GetTextObject():ChangeText("Hello", "inquint", .3, false);