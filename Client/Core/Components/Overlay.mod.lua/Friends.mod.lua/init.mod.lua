local import = _G.ValkyrieC.LoadLibrary;
import("Design");
import("Util");
local wait = wait;
local cache = {};

return function(FriendsController)
	local playerId = game.Players.LocalPlayer.UserId;
	local intent = _G.ValkyrieC:GetComponent("IntentService");
	local overlay = _G.ValkyrieC:GetOverlay();
	local content = game:GetService("ContentProvider");
	local ready = false;
	local cacheReady = false;
	local loading = false;

	-- This should already exist
	local frame = overlay.FriendsContentFrame;
	
	local Container = new "Frame":Instance {
		Name = "Container";
		BackgroundColor3 = Color3.Blue;
		Position = new "UDim2" (0.2, 0, 0, 0);
		Size = new "UDim2" (0.6, 0, 1, 0);
		BorderSizePixel = 0;
		Parent = frame;
		Children = {
			new "ScrollingFrame":Instance {
				Name = "FriendsList";
				BackgroundColor3 = Color3.Blue;
				Position = new "UDim2" (0, 0, 0, 0);
				Size = new "UDim2" (1, 0, 1, 0);
				BorderSizePixel = 0;
				CanvasSize = new "UDim2" (0, 0, 0, 0);
				ScrollBarThickness = 0;
			};
			new "ImageLabel":Instance {
				Name = "Shadow";
				Image = "rbxassetid://367588725";
				BackgroundTransparency = 1;
				ImageTransparency = 0.8;
				ImageColor3 = Color3.Black;
				Rotation = 180;
				BorderSizePixel = 0;
				ZIndex = 4;
				Visible = false;
				Position = new "UDim2" (0.96, 0, 0, 0);
				Size = new "UDim2" (0, 12, 1, 0);
			};
		};
	};
	
	local Preloader = new "Frame":Instance {
		Name = "Preloader";
		BackgroundTransparency = 1;
		ZIndex = 8;
		Active = true;
		BorderSizePixel = 0;
		BackgroundColor3 = Color3.White;
		Size = new "UDim2" (1, 0, 1, 0);
		Parent = frame;
		Children = {
			new "Frame":Instance {
				Name = "LoadingSquare";
				BackgroundTransparency = 1;
				
				Size = new "UDim2" (0, 100, 0, 100);
				Position = new "UDim2" (0.5, -50, 0.5, -50);
				BorderSizePixel = false;
				ZIndex = 8;
				BackgroundColor3 = Color3.Blue;
			}
		}
	};	
	
	local FriendsInfo = new "Frame":Instance {
		Name = "FriendInfo";
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Size = new "UDim2" (0.7, 0, 1, 0);
		Position = new "UDim2" (1, 0, 0, 0);
		Parent = frame;
		Children = {
			-- Popup
			new "ScrollingFrame":Instance {
				Name = "Popup";
				Size = new "UDim2" (1, 0, 1, 0);
				ZIndex = 4;
				Active = true;
				BorderSizePixel = 0;
				BackgroundColor3 = Color3.Black;
				BackgroundTransparency = 0.5;
				Visible = false;
				Children = {
					new "Frame":Instance {
						Name = "Info";
						Size = new "UDim2" (1, -140, 1, -120);
						Position = new "UDim2" (0, 80, 0, 60);
						BorderSizePixel = 0;
						BackgroundColor3 = Color3.White;
						ZIndex = 4;
						Active = true;
					};
				};
			};
			
			-- Detailed Info of the friends info
			new "ScrollingFrame":Instance {
				Name = "DetailedInfo";
				BackgroundTransparency = 1;
				Size = new "UDim2" (1, 0, 1, 0);
				ZIndex = 2;
				ScrollBarThickness = 0;
				CanvasSize = new "UDim2" (0, 0, 0, 1000);
				Children = {
					new "Frame":Instance {
						BackgroundColor3 = Color3.Grey[50];
						BorderSizePixel = 0;
						Size = new "UDim2" (1, 0, 1, -128);
						Position = new "UDim2" (0, 0, 0, 128);
						ZIndex = 2;
						Children = {
							new "Frame":Instance {
								Name = "Flash";
								Size = new "UDim2" (1, 0, 1, 0);
								BorderSizePixel = 0;
								BackgroundColor3 = Color3.White;
								BackgroundTransparency = 1;
								ZIndex = 3;
							};
							new "ImageLabel":Instance {
								Name = "Shadow";
								Image = "rbxasset://textures/ui/TopBar/dropshadow.png";
								BackgroundTransparency = 1;
								ImageColor3 = Color3.Black;
								BorderSizePixel = 0;
								ZIndex = 4;
								Rotation = 180;
								Position = new "UDim2" (0, 0, 0, -12);
								Size = new "UDim2" (1, 0, 0, 12);
							};
						}
					};
				};
			};
			
			-- Top container holding the main header of the friends info
			new "Frame":Instance {
				Name = "TopContainer";
				Size = new "UDim2" (1, 0, 0, 128);
				BorderSizePixel = 0;
				BackgroundColor3 = Color3.Blue;
				Children = {
					new "Frame":Instance {
						Name = "Flash";
						Size = new "UDim2" (1, 0, 1, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = Color3.Blue;
						BackgroundTransparency = 1;
						ZIndex = 3;
					};
					new "ImageLabel":Instance {
						Name = "ProfilePicture";
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Size = new "UDim2" (0, 100, 0, 100);
						Position = new "UDim2" (0, 10, 0, 10);
					};
					new "TextLabel":Instance {
						Name = "PlayerName";
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Size = new "UDim2" (1, -450, 0, 25);
						Position = new "UDim2" (0, 120, 0, 40);
						Font = Enum.Font.SourceSans;
						FontSize = Enum.FontSize.Size36;
						TextColor3 = Color3.White;
						TextXAlignment = Enum.TextXAlignment.Left;
					};
					new "TextLabel":Instance {
						Name = "Status";
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Size = new "UDim2" (1, -130, 0, 15);
						Position = new "UDim2" (0, 120, 0, 65);
						Font = Enum.Font.SourceSans;
						Text = "Offline";
						FontSize = Enum.FontSize.Size18;
						TextColor3 = Color3.White;
						TextTransparency = 0.5;
						TextXAlignment = Enum.TextXAlignment.Left;
					};
					new "TextLabel":Instance {
						Name = "Level";
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Size = new "UDim2" (1, -608, 0, 25);
						Position = new "UDim2" (1, -140, 0, 35);
						Font = Enum.Font.SourceSansBold;
						Text = "Level 1";
						FontSize = Enum.FontSize.Size36;
						TextColor3 = Color3.White;
					};
					new "TextButton":Instance {
						Name = "SendMessage";
						BorderSizePixel = 0;
						Size = new "UDim2" (1, -608, 0, 25);
						Position = new "UDim2" (1, -140, 0, 70);
						Font = Enum.Font.SourceSans;
						Text = "Send Message";
						FontSize = Enum.FontSize.Size14;
						Style = Enum.ButtonStyle.RobloxRoundDropdownButton;
					};
				};
			};
		};
	}
	
	--[[ TODO: Probably remove these functions
	local function centerAlignList()
		Container.Position = new "UDim2" (0.2, 0, 0, 0);
		Container.Size = new "UDim2" (0.6, 0, 1, 0);
		Container.Shadow.Visible = false;
	end;
	
	local function leftAlignList()
		Container.Position = new "UDim2" (0, 0, 0, 0);
		Container.Size = new "UDim2" (0.3, 0, 1, 0);
		Container.Shadow.Visible = true;
	end;
	]]--
	
	local function FadeFriendsInfo(switch)
		local function RecursiveChangeTransparency(object, value)
			for _,v in next, object:GetChildren() do
				if v.Name == "Flash" then
					v.BackgroundTransparency = value;
				end;
				if #v:GetChildren() > 0 then
					RecursiveChangeTransparency(v, value);
				end;
			end;
		end;
		
		if switch then
			for i = 1,0,-0.3 do
				RecursiveChangeTransparency(FriendsInfo, i);
				wait(1/30);
			end;
		else
			for i = 0,1,0.3 do
				RecursiveChangeTransparency(FriendsInfo, i);
				wait(1/30);
			end;
		end;
	end;
	
	local function SetPlayerInfo(id)
		if cache[id]["Online"] then
			FriendsInfo.TopContainer.Status.TextColor3 = Color3.LightGreen["A700"];
			FriendsInfo.TopContainer.Status.TextTransparency = 0;
			if cache[id]["GID"] ~= nil and cache[id]["Game"] ~= nil then
				FriendsInfo.TopContainer.Status.Text = "In-Game " .. cache[id]["Game"];
			else
				FriendsInfo.TopContainer.Status.Text = "Online";
			end
		else
			FriendsInfo.TopContainer.Status.TextColor3 = Color3.White;
			FriendsInfo.TopContainer.Status.TextTransparency = 0.5;
			FriendsInfo.TopContainer.Status.Text = "Offline";
		end
	end;
	
	local function GetPlayerInfo(id)
		if cache[id] == nil then
			-- Thanks eLunate for the loading code
			loading = true;
			
			-- Reset color
			Preloader.LoadingSquare.BackgroundColor3 = Color3.Blue;
			
			spawn(function()
				while loading do
					local i = 0;
					while i<1 do
				 		Preloader.LoadingSquare.Rotation = -90*i*(i-2);
				 		i = i+wait(); -- If you have util, this defaults back to a renderstep in most cases.
					end;
					Preloader.LoadingSquare.Rotation = 0;
				end;
			end);
			
			for i = 1,0,-0.2 do
				Preloader.BackgroundTransparency = i;
				Preloader.LoadingSquare.BackgroundTransparency = i;
				wait(1/30);
			end;
			
			intent:BroadcastRPCIntent('FriendsController', 'GetPlayerInfo', id);
			
			repeat wait() until cacheReady;
			cacheReady = false;
			loading = false;
			
			-- Just helps organize
			SetPlayerInfo(id);
			
			Preloader.LoadingSquare:TweenBackgroundColor3(Color3.Green, "linear", 0.6, true);
			
			for i = 0,1,0.2 do
				Preloader.BackgroundTransparency = i;
				Preloader.LoadingSquare.BackgroundTransparency = i;
				wait(1/30);
			end;
		else
			if os.time() - cache[id]["LastCheck"] >= 300 then
				cache[id] = nil;
				GetPlayerInfo(id);
			end
		end;
	end;
	
	local friendsInfoOpen = false;	
	
	local function selectFriend(friend, gui)
		local id = friend[1];
		local name = friend[2];
		
		if not friendsInfoOpen then
			-- So it's set and ready when it slides in
			FriendsInfo.TopContainer.ProfilePicture.Image = "http://assetgame.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username=" .. name;
			FriendsInfo.TopContainer.PlayerName.Text = name;
			
			GetPlayerInfo(id);
			
			FriendsInfo:TweenPosition(new "UDim2" (0.8, 0, 0, 0), nil, nil, 0.6, true);
			wait(0.56);
			Container:TweenPosition(new "UDim2" (0, 0, 0, 0), nil, nil, 0.6, true);
			Container:TweenSize(new "UDim2" (0.3, 0, 1, 0), nil, nil, 0.6, true);
			FriendsInfo:TweenPosition(new "UDim2" (0.3, 0, 0, 0), nil, nil, 0.6, true);
			Container.Shadow.Visible = true;
		else
			GetPlayerInfo(id);
			FadeFriendsInfo(true);
		end;
		
		FriendsInfo.TopContainer.ProfilePicture.Image = "http://assetgame.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username=" .. name;
		FriendsInfo.TopContainer.PlayerName.Text = name;
		
		if friendsInfoOpen then
			FadeFriendsInfo(false);
		end;
		
		-- Needed for above if statement (False trigger)
		if not friendsInfoOpen then
			friendsInfoOpen = true;
		end;
	end;
	
	-- Probably need a better IntentService name
	local listQueue;
	intent:RegisterRPCIntent("FriendsController", function(command, result, error)
		if command == "GetFriends" then
			if result == false then
				local errorMessage = new "TextLabel":Instance {
					Position = new "UDim2" (0, 210, 0, 0);
					Size = new "UDim2" (1, -404, 1, 0);
					ZIndex = 2;
					BackgroundTransparency = 1;
					FontSize = Enum.FontSize.Size14;
					TextWrapped = true;
					TextColor3 = Color3.White;
					Text = "We couldn't load your friends list (" .. error .. ")";
					Parent = frame;
				}
				return
			end
			local offset = 0;
			listQueue = #result;
			ready = true;
			
			spawn(function()
				for i,v in next, result do
					local id = v[1];
					local name = v[2];
					
					spawn(function()
						content:Preload("http://assetgame.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username=" .. name);
					end);
					
					local Friend = new "TextButton":Instance {
						Name = id;
						BackgroundColor3 = Color3.White;
						Position = new "UDim2" (0, 0, 0, offset);
						Size = new "UDim2" (1, 0, 0, 48);
						BorderSizePixel = 0;
						Parent = Container.FriendsList;
						Text = "";
						Active = true;
						ClipsDescendants = true;
						Children = {
							new "ImageLabel":Instance {
								Name = "ProfilePicture";
								BackgroundTransparency = 1;
								BorderSizePixel = 0;
								Size = new "UDim2" (0,100,0,100);
								Position = new "UDim2" (0,-10,0,-6);
								Image = "http://assetgame.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username=" .. name;
							};
							-- Would use Custom Font Render but we can tell everyone gg (Freezes game)
							new "TextLabel":Instance {
								Name = "PlayerName";
								BackgroundTransparency = 1;
								BorderSizePixel = 0;
								Size = new "UDim2" (1, -98, 0, 12);
								Position = new "UDim2" (0, 98, 0, 2);
								TextColor3 = Color3.Black;
								Text = name;
								TextWrapped = false;
								Font = Enum.Font.SourceSans;
								FontSize = Enum.FontSize.Size24;
								TextXAlignment = Enum.TextXAlignment.Left;
							}
						};
					};
					
					spawn(function()
						Friend.MouseButton1Click:connect(function()
							selectFriend({id, name}, Friend);
						end);
					end);
					
					offset = offset + 50;
					if i < #result then
						Container.FriendsList.CanvasSize = new "UDim2" (0, 0, 0, offset);	
					else
						Container.FriendsList.CanvasSize = new "UDim2" (0, 0, 0, offset - 2);	
					end
					listQueue = listQueue - 1;
				end;
			end);
		elseif command == "GetPlayerInfo" then
			if result == false then
				-- REVISE ERROR MESSAGE				
				
				--[[
				local errorMessage = new "TextLabel":Instance {
					Position = new "UDim2" (0, 210, 0, 0);
					Size = new "UDim2" (1, -404, 1, 0);
					ZIndex = 2;
					BackgroundTransparency = 1;
					FontSize = Enum.FontSize.Size14;
					TextWrapped = true;
					TextColor3 = Color3.White;
					Text = "We couldn't load your friends list (" .. error .. ")";
					Parent = frame;
				}]]--
				return
			end
			
			-- GID (GameID), Game (Game Name)
			-- Not all values are expected to be not nil
			cache[result[2][1]] = {
				LastCheck = os.time();
				Online = result[2][3];
				GID = result[2][4] or nil;
				Game = result[2][5] or nil;
			}
			cacheReady = true;
		end
	end);
	
	intent:BroadcastRPCIntent('FriendsController', 'GetFriends');
	
	repeat wait() until ready == true;
	repeat wait() until listQueue == 0;
	repeat wait() until content.RequestQueueSize == 0;
	
	return true;
end;