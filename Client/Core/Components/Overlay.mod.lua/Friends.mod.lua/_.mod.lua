local FriendsController = {};

local didInit = false;
local didPreInit = false;
local init = require(script.init);
-- Needed for preInit
local import = _G.ValkyrieC.LoadLibrary;
import("Design");
import("Util");

-- Generate container ahead of time
local function preInit()
	local GUI = _G.ValkyrieC:GetOverlay();	
	local ContentContainerFrame = new "Frame":Instance {
		Name = "FriendsContentFrame";
		BackgroundColor3 = Color3.Blue[500];
		Size = new "UDim2" (1, 0, 1, -48);
		Position = new "UDim2" (0, 0, 0, 0);
		BorderSizePixel = 0;
		Parent = GUI;
		
	};

	FriendsController.ContentFrame = ContentContainerFrame;
end;

-- Just run the function (Too lazy to remove it from the function
preInit();

FriendsController.Open = function()
	if not didInit then
		init(FriendsController);
		didInit = true;
	end;
end

return FriendsController
