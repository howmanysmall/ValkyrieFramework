-- Init

_G.ValkyrieC:LoadLibrary("Util");
_G.ValkyrieC.LoadLibrary("Design");

local GUI = _G.ValkyrieC:GetOverlay();
local FontRender = _G.ValkyrieC:GetComponent("Fonts");
local ContentProvider = ContentProvider;

return function(OverlayController)
	local SplashFrame = new "Frame":Instance {
		Name = "SplashFrame";
		ZIndex = 9;
		Size = new "UDim2" (1,0,1,0);
		Position = new "UDim2" (0,0,1,0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Parent = GUI;
		BackgroundColor3 = Color3.White;
		Children = {
			new "ImageLabel":Instance {
				Name = "SplashImage";
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Size = new "UDim2" (0,256,0,256);
				Position = new "UDim2" (0.5,-128,0.5,-128);
				ImageTransparency = 1;
				ZIndex = 10;
			};
		};
	};
	SplashFrame:TweenPosition(
		new "UDim2" (0,0,0,0),
		nil, nil, 0.6, true
	);
	spawn(function()
		local i = 0;
		while i < 1 do
			i = i + wait()/0.6
			SplashFrame.BackgroundTransparency = 1-i^2;
		end;
		SplashFrame.BackgroundTransparency = 0;
	end);
	ContentProvider:PreloadAsync({VALKYRIEICONID});
	do
		local PreloadSet = {
			"rbxassetid://242376879";
			"rbxassetid://242376668";
			"rbxassetid://242376304";
			"rbxassetid://242376228";
			"rbxassetid://242376482";
		}
		for i=1,#PreloadSet do
			ContentProvider:Preload(PreloadSet[i]);
		end;
		local SplashImage = SplashFrame.SplashImage;
		local i = 0;
		while i < 1 do
			i = i + wait()*2;
			SplashImage.ImageTransparency = 1-i^2;
		end;
		SplashImage.ImageTransparency = 0;
	end;

	-- Init the actual Overlay
	local ButtonsContainerFrame = new "Frame":Instance {
		Name = "ButtonsContainer";
		BackgroundTransparency = 1;
		Size = new "UDim2" (1,0,0,48);
		Position = new "UDim2" (0,0,1,-48);
		BorderSizePixel = 0;
		Parent = GUI;
		Children = {
			new "Frame":Instance {
				Name = "Friends";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0,0,0,0);
				BackgroundColor3 = Color3.Blue;
				BorderSizePixel = 0;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Friends")
					.BorderSizePixel(0)
					.FontSize(7)
					.BackgroundTransparency(1)
					.TextColor3(Color3.White)
					._obj;
				};
			};
			new "Frame":Instance {
				Name = "Games";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0.2,0,0,0);
				BackgroundColor3 = Color3.Green;
				BorderSizePixel = 0;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Games")
					.BorderSizePixel(0)
					.FontSize(7)
					.BackgroundTransparency(1)
					.TextColor3(Color3.White)
					._obj;
				};
			};
			new "Frame":Instance {
				Name = "Profile";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0.4,0,0,0);
				BackgroundColor3 = Color3.Orange;
				BorderSizePixel = 0;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Profile")
					.BorderSizePixel(0)
					.FontSize(7)
					.BackgroundTransparency(1)
					._obj;
				};
			};
			new "Frame":Instance {
				Name = "Stats";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0.6,0,0,0);
				BackgroundColor3 = Color3.Red;
				BorderSizePixel = 0;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Stats")
					.BorderSizePixel(0)
					.FontSize(7)
					.BackgroundTransparency(1)
					._obj;
				};
			};
			new "Frame":Instance {
				Name = "Preferences";
				Size = new "UDim2" (0.2,1,0,48);
				Position = new "UDim2" (0.8,0,0,0);
				BackgroundColor3 = Color3.Purple;
				BorderSizePixel = 0;
				Children = {
					new "ImageLabel":Instance {
						Name = "Img";
						Size = new "UDim2" (0,48,0,48);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					};
					Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Preferences")
					.BorderSizePixel(0)
					.FontSize(7)
					.BackgroundTransparency(1)
					._obj;
				};
			};
		};
	};
	
	
	repeat wait() until ContentProvider.RequestQueueSize == 0;
	
	SplashFrame:TweenPosition(
		new "UDim2" (0,0,1,0),
		nil, nil, 0.3, true
	);
	do
		local SplashImage = SplashFrame.SplashImage;
		local i = 0; 
		while i < 1 do
			i = i + wait()*3;
			SplashFrame.Transparency = i;
			SplashImage.Transparency = i;
		end;
		SplashFrame.Transparency = 1;
		SplashImage.Transparency = 1;
	end;
	return true;
end;