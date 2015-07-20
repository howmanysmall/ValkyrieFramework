_G.ValkyrieC:LoadLibrary "Design";
local Core          		= _G.ValkyrieC;
local Scroller 				= {};
local RenderStepped			= game:GetService"RunService".RenderStepped;

local function DeltaWait()
	local Tick 				= tick();
	RenderStepped:wait();
	return tick() - Tick;
end

function Scroller:BindScrolling(Sidebar)
	local Last, Origin, TouchLocation, Esc, Current, ContentFrameY, TouchDown, TouchChanged = nil, nil, nil, nil, nil, false, false;
	local ContentFrame 		= Sidebar.ItemContainer;
	
	RenderStepped:connect(function()
		if TouchDown then
			Origin 				= TouchLocation;
			Current				= TouchLocation;
			Last 				= TouchLocation;
			
			if TouchChanged then
				TouchChanged 	= false;
				Last 		 	= Current;
				Current 		= TouchLocation;
				Esc 			= Current;
				
				ContentFrameY 	= ContentFrame.Position.Y.Offset;
				ContentFrame.Position 	= UDim2.new(0,0,0, ContentFrameY + (Current.Y - ContentFrameY) * 0.9);
				
				RenderStepped:wait();
				
				if Esc.Y.Offset == Current.Y.Offset then
					ContentFrame.Position = UDim2.new(0,0,0, ContentFrameY + (Current.Y - ContentFrameY) * 0.99)
					RenderStepped:wait();
					if Esc.Y.Offset == Current.Y.Offset then
						ContentFrame.Position = UDim2.new(0,0,0, ContentFrameY);
						Last 	= Current;
					end
				end
			end
		end
	end);

	Sidebar.InputChanged:connect(function(InputObject)
		InputObject = wrapper(InputObject);
		if InputObject.UserInputType == Enum.UserInputType.Touch then
			TouchChanged 		= true;
			TouchLocation 		= InputObject.Position;
			if InputObject.UserInputState == Enum.UserInputState.Begin then
				TouchDown 		= true;
			elseif InputObject.UserInputState == Enum.UserInputState.End then
				TouchDown 		= false;
				local Velocity 	= Current.Y - Last.Y;
				local Delta;
				
				while Velocity > 1 and not TouchDown do
					Delta 		= DeltaWait();
					ContentFrame.Position 	= ContentFrame.Position + UDim2.new(0,0,0, Velocity * Delta);
					Velocity  	= Velocity - (5) * Delta;
				end
			end
		end
	end);
end


return Scroller; -- Don't return userdata; only used internally