-- Init
local import = _G.ValkyrieC.LoadLibrary;
import("Design");
import("Util");
local wait = wait;

local GUI = _G.ValkyrieC:GetOverlay();
local FontRender = _G.ValkyrieC:GetComponent("Fonts");
local Input = _G.ValkyrieC:GetComponent("ValkyrieInput");
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
				ZIndex = 9;
			};
		};
	};
	SplashFrame:TweenPosition(
		new "UDim2" (0,0,0,0),
		nil, nil, 0.6, true
	);
	coroutine.wrap(function()
		local i = 0;
		while i < 1 do
			i = i + wait()/0.6
			SplashFrame.BackgroundTransparency = 1+i*(i-2);
		end;
		SplashFrame.BackgroundTransparency = 0;
	end)();
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
			SplashImage.ImageTransparency = 1-i*(i-2);
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
					Label = Chain(FontRender.Label("Roboto"))
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
					Label = Chain(FontRender.Label("Roboto"))
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
					Label = Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Profile")
					.BorderSizePixel(0)
					.FontSize(7)
					.BackgroundTransparency(1)
					.TextColor3(Color3.White)
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
					Label = Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Stats")
					.BorderSizePixel(0)
					.FontSize(7)
					.BackgroundTransparency(1)
					.TextColor3(Color3.White)
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
					Label = Chain(FontRender.Label("Roboto"))
					.Size(new "UDim2" (1,-48,0,48))
					.Position(new "UDim2" (0,48,0,0))
					.TextXAlignment("Left")
					.Text("Preferences")
					.BorderSizePixel(0)
					.FontSize(7)
					.BackgroundTransparency(1)
					.TextColor3(Color3.White)
					._obj;
				};
			};
		};
	};
	
	ButtonsContainerFrame.Friends.Img:LoadIcon("Social", "People");
	ButtonsContainerFrame.Games.Img:LoadIcon("Hardware", "Gamepad");
	ButtonsContainerFrame.Profile.Img:LoadIcon("Action1","Account_box");
	ButtonsContainerFrame.Preferences.Img:LoadIcon("Action2", "Settings");
	ButtonsContainerFrame.Stats.Img:LoadIcon("Content", "Sort");
	
	local ContentContainerFrame = new "Frame":Instance {
		BackgroundColor3 = Color3.White;
		Size = new "UDim2" (1,0,1,-48);
		BorderSizePixel = 0;
		Parent = GUI;
		Children = {
			Clock = Chain(FontRender.Label("Roboto"))
			.FontSize(8)
			.Position(new "UDim2" (0.5,0,0,48))
			.Size(new "UDim2" (0.5,-48,0,96))
			.TextXAlignment("Right")
			.TextYAlignment("Top")
			.BackgroundTransparency(1)
			.BorderSizePixel(0)
			.Text("00:00")
			.TextColor3(Color3.Amber[400])
			._obj;
			new "Frame":Instance {
				Name = "NotificationSeparator";
				Size = new "UDim2" (1,-96,0,2);
				Position = new "UDim2" (0,48,0,96);
				BackgroundColor3 = Color3.BlueGrey[50];
				BorderSizePixel = 0;
			};
			new "ScrollingFrame":Instance {
				Name = "NotificationContainer";
				Size = new "UDim2" (1,-96,1,-144);
				Position = new "UDim2" (0,48,0,96);
				BackgroundTransparency = 1;
				CanvasSize = new "UDim2" (1,-6,0,0);
				ScrollBarThickness = 5;
				ClipsDescendants = true;
				BorderSizePixel = 0;
			};
			NotificationTop = Chain(FontRender.Label("Roboto"))
			.FontSize(8)
			.Position(new "UDim2" (0,48,0,48))
			.TextXAlignment("Left")
			.Text("Notifications")
			.BackgroundTransparency(1)
			.BorderSizePixel(0)
			.Size(new "UDim2" (0.5,-48,0,48))
			.TextTransparency(0.14)
			._obj;
		};
	};
	
	do local clock = ContentContainerFrame.Clock;
		spawn(function()
			while wait(60) do
				clock.Text = string.format("%.2d:%.2d",(tick()/3600)%24,(tick()/60)%60);
			end;
		end);
	end;
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
			SplashFrame.Transparency = -i*(i-2);
			SplashImage.Transparency = -i*(i-2);
		end;
		SplashFrame.Transparency = 1;
		SplashImage.Transparency = 1;
	end;
	
	-- Set the ZIndex of everything.
	for k,v in next, ButtonsContainerFrame:GetChildren() do
		v.ZIndex = 10;
		v.Label.ZIndex = 10;
		v.Img.ZIndex = 10;
	end;
	return true;
end;