_G.ValkyrieC:LoadLibrary("Design");
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false);
local templateStor      = script.Template:Clone();
local healthBarTemplate = templateStor.HealthBar;
local coloredBar        = healthBarTemplate.ColoredBar;
local healthText        = healthBarTemplate.HealthText;
local localPlayer       = game.Players.LocalPlayer;
local rstep				= game:GetService("RunService").RenderStepped;
local scheduler			= require(script.Scheduler);
local calcFunctions		= require(script.CalculationFunctions);

local function updateBar(newHealth)
    local duration      = 1 / 3;
	local maxHealth		= localPlayer.Character.Humanoid.MaxHealth;
    local oldHealth     = coloredBar.Size.X.Scale * maxHealth;
	local oldMaxHealth	= coloredBar.OldMaxHealth.Value;
	
	
	if maxHealth 		== math.huge or newHealth == math.huge then
		healthText.Text = "Infinite";
		local oldColor	= coloredBar.BackgroundColor3;
		for elapsed = 0, duration, 1 / 60 do
	        coloredBar.BackgroundColor3 = calcFunctions.C3easing(elapsed, oldColor, Color3.Blue[500], duration);
	        coloredBar.Size             = UDim2.new(1, coloredBar.Size.X.Offset, coloredBar.Size.Y.Scale, coloredBar.Size.Y.Offset);
	        rstep:wait();
	    end
	else
	    for elapsed = 0, duration, 1 / 60 do
			local oldPercent, newPercent, changePercent, passBegin, passEnd, passChange, newColor, oldColor, changeColor = calcFunctions.computeNewVals(oldHealth, newHealth, calcFunctions.easing(elapsed, oldMaxHealth, maxHealth - oldMaxHealth, duration), coloredBar);
			local sizeStep				= calcFunctions.easing(elapsed, oldPercent, changePercent, duration);
	        coloredBar.BackgroundColor3 = calcFunctions.C3easing(elapsed, oldColor, newPercent > 1 and Color3.Blue[500] or newColor, duration);
	        coloredBar.Size             = UDim2.new(sizeStep, coloredBar.Size.X.Offset, coloredBar.Size.Y.Scale, coloredBar.Size.Y.Offset);
			if coloredBar.Size.X.Scale > 1 then
				coloredBar.Size = UDim2.new(1, coloredBar.Size.X.Offset, coloredBar.Size.Y.Scale, coloredBar.Size.Y.Offset);
			end
	        healthText.Text             = ("%.1f %%"):format(100 * calcFunctions.easing(elapsed, oldPercent, changePercent, duration));
	        rstep:wait();
	    end
	end
    
    coloredBar.OldMaxHealth.Value		= localPlayer.Character.Humanoid.MaxHealth;
	calcFunctions.clearCache();
end

local function defaultHealthHandler(newHealth)
   scheduler.scheduleTask(updateBar, false, newHealth);
end

localPlayer.Character.Humanoid.HealthChanged:connect(function(newHealth)
	defaultHealthHandler(newHealth);
end);

local last = localPlayer.Character.Humanoid.MaxHealth;

return function()
	localPlayer.Character.Humanoid.Changed:connect(function()
		if localPlayer.Character.Humanoid.MaxHealth ~= last then
			last = localPlayer.Character.Humanoid.MaxHealth;
			scheduler.scheduleTask(updateBar, false, localPlayer.Character.Humanoid.Health);
		end
	end);
	
	healthBarTemplate.Parent 		= _G.ValkyrieC:GetOverlay();
	coloredBar.OldMaxHealth.Value	= localPlayer.Character.Humanoid.MaxHealth;
	scheduler.scheduleTask(updateBar, false, localPlayer.Character.Humanoid.Health);
end;