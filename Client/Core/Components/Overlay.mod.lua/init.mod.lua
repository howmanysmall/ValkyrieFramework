-- Init

_G.Valkyrie:LoadLibrary("Util");
_G.Valkyrie:LoadLibrary("Design");

local GUI = _G.Valkyrie:GetOverlay();
local FontRender = _G.Valkyrie:GetComponent("Fonts");

return function()
	-- Init the actual Overlay
	local ButtonsContainerFrame = new "Frame":Instance {
		Name = "ButtonsContainer";
		BackgroundTransparency = 1;
		Size = new "UDim2" (1,0,0,48);
		Children = {
			new "Frame":Instance {
				Name = "Friends";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0,0,1,-48);
				BackgroundColor3 = Color3.Blue;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Friends")
					.FontSize(24)();
				};
			};
			new "Frame":Instance {
				Name = "Games";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0.2,0,1,-48);
				BackgroundColor3 = Color3.Green;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Games")
					.FontSize(24)();
				};
			};
			new "Frame":Instance {
				Name = "Profile";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0.4,0,1,-48);
				BackgroundColor3 = Color3.Orange;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Profile")
					.FontSize(24)();
				};
			};
			new "Frame":Instance {
				Name = "Stats";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0.6,0,1,-48);
				BackgroundColor3 = Color3.Red;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Stats")
					.FontSize(24)();
				};
			};
			new "Frame":Instance {
				Name = "Preferences";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0.8,0,1,-48);
				BackgroundColor3 = Color3.Purple;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Preferences")
					.FontSize(24)();
				};
			};
		};
	}
end;