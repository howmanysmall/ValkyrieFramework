local Player = game:GetService"Players".LocalPlayer;

-- Init
local commandHistory = {};

-- Create the console
local consoleContainer = Instance.new("ScreenGui", Player:WaitForChild"PlayerGui");
consoleContainer.Name = "VAConsole";
local lowerFrame = Instance.new('Frame', consoleContainer);
lowerFrame.Name = 'Container';
lowerFrame.Size = UDim2.new(1,0,0.4,0);
lowerFrame.BackgroundTransparency = 1;
local inputBox = Instance.new('TextBox', lowerFrame);
inputBox.Size = UDim2.new(1,-60,0,20);
inputBox.Position = UDim2.new(0,0,0,-20);
inputBox.BackgroundColor = Color3.new(0.07,0.07,0.07);
inputBox.BorderSizePixel = 0;
inputBox.ZIndex = 2;
local sendButton = Instance.new('TextButton', lowerFrame);
sendButton.Size = UDim2.new(0,60,0,0);
sendButton.Position = UDim2.new(0,60,0,20);
sendButton.ZIndex = 2;
local historyContainer = Instance.new('Frame', lowerFrame);
historyContainer.Size = UDim2.new(1,0,1,-20);
historyContainer.Position = UDim2(0,0,0,0);
historyContainer.BackgroundTransparency = 0.4;
historyContainer.BackgroundColor = Color3.new(0.1,0.1,0.1);
historyContainer.ZIndex = 2;

-- Bind to user input to pull up the terminal/console


-- Bind the console
sendButton.MouseButton1Click:connect(function()
	
end);