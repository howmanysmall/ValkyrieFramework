local Overlay = script.Parent;
local BindsManager = require(script.Parent.Parent.BindsManager);
local Keys = BindsManager.Keys;
local pow = math.pow;
local vis = false;
local deb = true;

local function outQuint(t, b, c, d)
  t = t / d - 1
  return c * (pow(t, 5) + 1) + b
end

local function DoAction()
	print("Action")
	if vis and deb then
		deb = false;
		Overlay.InfoFrame:TweenPosition(UDim2.new(1,0,0,0), 0, 5, 0.3, false, function()
			deb = true;
			vis = false;
			Overlay.InfoFrame.Visible = false;
			Overlay.PlayersFrame.Visible = false;
			Overlay.Shade.Visible = false;
		end)
		Overlay.PlayersFrame:TweenPosition(UDim2.new(-0.125,0,0,0), 0, 5, 0.2);
		local i = 0;
		while i < 0.3 do
			Overlay.InfoFrame.Transparency = outQuint(i,0,0.6,0.3);
			Overlay.PlayersFrame.Transparency = outQuint(i,0,0.6,0.3);
			Overlay.Shade.Transparency = outQuint(i,0.6,0.4,0.3);
			i = i+wait();
		end
	elseif deb and not vis then
		deb = false;
		Overlay.Shade.Visible = true;
		Overlay.PlayersFrame:TweenPosition(UDim2.new(0,0,0,0), 1, 5, 0.4, false, function()
			deb = true;
			vis = true;
		end)
		local i = 0;
		Overlay.PlayersFrame.Visible = true;
		while i < 0.4 do
			Overlay.InfoFrame.Transparency = outQuint(i,1,-1,0.3);
			Overlay.PlayersFrame.Transparency = outQuint(i,1,-1,0.3);
			Overlay.Shade.Transparency = outQuint(i,1,-0.4,0.4);
			i = i+wait();
		end
	end
end

BindsManager:BindInputDown("Shift", function(iData)
	if Keys.Ctrl.Down then
		DoAction();
	end
end)
BindsManager:BindInputDown("Ctrl", function(iData)
	if Keys.Shift.Down then
		DoAction();
	end
end)