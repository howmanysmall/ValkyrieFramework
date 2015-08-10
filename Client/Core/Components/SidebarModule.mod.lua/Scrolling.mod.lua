_G.ValkyrieC:LoadLibrary "Design";
local Core          		= _G.ValkyrieC;
local Scroller 				= wrapper({});
local RenderStepped			= game:GetService"RunService".RenderStepped;

local function DeltaWait()
	local Tick 				= tick();
	RenderStepped:wait();
	return tick() - Tick;
end

function Scroller:BindScrolling(Sidebar)
	local origin, current, last, TouchLocation, down;
	local ContentFrame 		= Sidebar.ItemContainer;

	Sidebar.InputEnded:connect(function(InputObject)
		if InputObject.UserInputType == Enum.UserInputType.Touch then
			print"end"
			TouchLocation 	= InputObject.Position;
			down 		= false;
			local Velocity 	= Current.Y - Last.Y;
			local Delta;
			while math.abs(Velocity) > 1 and not down do
				Delta 		= DeltaWait();
				ContentFrame.Position 	= ContentFrame.Position + UDim2.new(0,0,0,ContentFrame.Position.Y.Offset+Velocity * Delta);
				Velocity  	= Velocity - (5) * Delta;
			end
		end
	end);

	Sidebar.InputBegan:connect(function(InputObject)
		if InputObject.UserInputType == Enum.UserInputType.Touch then
			print"begin"
			TouchLocation 	= InputObject.Position;
			origin, current, last = TouchLocation, TouchLocation, TouchLocation;
			down = true;
		end;
	end);


	Sidebar.InputChanged:connect(function(InputObject)
		if InputObject.UserInputType == Enum.UserInputType.Touch then
			print"change"
			TouchChanged 		= true;
			TouchLocation 		= InputObject.Position;
			local esc = TouchLocation;
			local ldiff = 0;
			local cy = ContentFrame.Y.Offset;
			local cydiff = current.Y - origin.Y;
			while ldiff < 1 and esc == TouchLocation and down do
				ldiff = ldiff + DeltaWait()*8;
				ContentFrame.Position = UDim2.new(0,0,0,cy+cydiff*ldiff);
			end
			if esc == TouchLocation then
				ContentFrame.Position = UDim2.new(0,0,0,cy+cydiff);
				last = current;
			end;
		end;
	end);
end


return Scroller; -- Don't return userdata; only used internally
