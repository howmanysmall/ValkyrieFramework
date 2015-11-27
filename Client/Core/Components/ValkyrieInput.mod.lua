-- Unified input
-- Create actions, bind input.

local Controller = {};
local this = newproxy(true);
local IntentService = _G.Valkyrie:GetComponent "IntentService";

local function extract(...) -- Dynamic methods are pretty much standard now
	if (...) == this then
		return select(2,...);
	else
		return ...;
	end;
end;

local Actions = setmetatable({},{__mode = 'v'});
local ActionLinks = setmetatable({},{__mode = 'k'});
local ActionBinds = setmetatable({},{__mode = 'k'});
local ActionClass = {};
local ActionMt = {
	__tostring = function(this)
		return ActionLinks[this].Name;
	end;
	__call = function(this,...)
		return ActionLinks[this].Action(...);
	end;
	__index = function(this,k)
		return ActionClass[k];
	end;
	__metatable = "Locked metatable: Valkyrie";
	__len = function(this)
		return ActionLinks[this].FireCount;
	end;
	__gc = function(this) -- Is __gc enabled in Roblox?
		ActionBinds[this]:disconnect();
	end;
};
local UserActions = setmetatable({},{__mode = 'v'});

local InputSources, LinkedTypes, LinkedNames do
	LinkedTypes = {};
	LinkedNames = {};
	local function make(sourceType, BindingName)
		local nop = newproxy(false);
		LinkedTypes[nop] = sourceType;
		LinkedNames[nop] = BindingName;
	end;
	InputSources = {
		Mouse = {
			Mouse1 = make("Mouse1", "Mouse1");
			Mouse2 = make("Mouse2", "Mouse2");
			Mouse3 = make("Mouse3", "Mouse3");
			Moved = make("MouseMoved", "Moved");
			Scrolled = make("MouseScrolled", "Scrolled");
		};
		Keyboard = {
			-- There's got to be a better way of doing this, surely.
			A = make("Keyboard", "A");
			B = make("Keyboard", "B");
			C = make("Keyboard", "C");
			D = make("Keyboard", "D");
			E = make("Keyboard", "E");
			F = make("Keyboard", "F");
			G = make("Keyboard", "G");
			H = make("Keyboard", "H");
			I = make("Keyboard", "I");
			J = make("Keyboard", "J");
			K = make("Keyboard", "K");
			L = make("Keyboard", "L");
			M = make("Keyboard", "M");
			N = make("Keyboard", "N");
			O = make("Keyboard", "O");
			P = make("Keyboard", "P");
			Q = make("Keyboard", "Q");
			R = make("Keyboard", "R");
			S = make("Keyboard", "S");
			T = make("Keyboard", "T");
			U = make("Keyboard", "U");
			V = make("Keyboard", "V");
			W = make("Keyboard", "W");
			X = make("Keyboard", "X");
			Y = make("Keyboard", "Y");
			Z = make("Keyboard", "Z");
			make("Keyboard", "One");
			make("Keyboard", "Two");
			make("Keyboard", "Three");
			make("Keyboard", "Four");
			make("Keyboard", "Five");
			make("Keyboard", "Six");
			make("Keyboard", "Seven");
			make("Keyboard", "Eight");
			make("Keyboard", "Nine");
			[0] = make("Keyboard", "Zero");
			Shift = make("Keyboard", "LeftShift");
			Tab = make("Keyboard", "Tab");
			Esc = make("Keyboard", "Escape");
			Space = make("Keyboard", "Space");
			Ctrl = make("Keyboard", "LeftControl");
			Alt = make("Keyboard", "LeftAlt");
			Super = make("Keyboard", "LeftMeta");
		};
		Controller = {
			A = make("ControllerButton", "ButtonA");
			B = make("ControllerButton", "ButtonB");
			X = make("ControllerButton", "ButtonX");
			Y = make("ControllerButton", "ButtonY");
			L1 = make("ControllerButton", "ButtonL1");
			R1 = make("ControllerButton", "ButtonR1");
			L2 = make("ControllerTrigger", "ButtonL2");
			R2 = make("ControllerTrigger", "ButtonR2");
			L3 = make("ControllerButton", "ButtonL3");
			R3 = make("ControllerButton", "ButtonR3");
			Start = make("ControllerButton", "ButtonStart");
			Select = make("ControllerButton", "ButtonSelect");
			Up = make("ControllerButton", "DPadUp");
			Down = make("ControllerButton", "DPadDown");
			Left = make("ControllerButton", "DPadLeft");
			Right = make("ControllerButton", "DPadRight");
			Analogue1 = make("ControllerAxis", "Thumbstick1");
			Analogue2 = make("ControllerAxis", "Thumbstick2");
		};
		TouchActions = {
      Tapped = make("TouchAction", "Tapped");
      LongPressed = make("TouchAction", "LongPressed");
      Moved = make("TouchAction", "Moved");
      Panned = make("TouchAction", "Panned");
      Pinched = make("TouchAction", "Pinched");
      Rotated = make("TouchAction", "Rotated");
      Started = make("TouchAction", "Started");
      Swiped = make("TouchAction", "Swiped");
		};
		TouchScreen = {
			-- Generic touch input
			-- 1 finger down
			-- 2 fingers down
			-- Doesn't have to come directly from an input source; just has to be a valid input.
			-- TouchPoint1
			-- TouchPoint2
			-- etc.
		};
	};
	do
		-- ~ Keyboard input aliases
		local Keyboard = InputSources.Keyboard;
		Keyboard.One = Keyboard[1];
		Keyboard.Two = Keyboard[2];
		Keyboard.Three = Keyboard[3];
		Keyboard.Four = Keyboard[4];
		Keyboard.Five = Keyboard[5];
		Keyboard.Six = Keyboard[6];
		Keyboard.Seven = Keyboard[7];
		Keyboard.Eight = Keyboard[8];
		Keyboard.Nine = Keyboard[9];
		Keyboard.Zero = Keyboard[0];
		Keyboard.Control = Keyboard.Ctrl;
		Keyboard.LeftControl = Keyboard.Ctrl;
		Keyboard.LCtrl = Keyboard.Ctrl;
		Keyboard.LControl = Keyboard.Ctrl;
		Keyboard.Win = Keyboard.Super;
		Keyboard.LeftSuper = Keyboard.Super;
		Keyboard.LSuper = Keyboard.Super;
		Keyboard.LWin = Keyboard.Super;
		Keyboard.LeftWin = Keyboard.Super;
		Keyboard.WindowsKey = Keyboard.Super;
		Keyboard.Windows = Keyboard.Super;
	end;
	do
		-- ~ Gamepad input aliases
		local Controller = InputSources.Controller;
		Controller.ButtonA = Controller.A;
		Controller.ButtonB = Controller.B;
		Controller.ButtonX = Controller.X;
		Controller.ButtonY = Controller.Y;
		Controller.ButtonL1 = Controller.L1;
		Controller.ButtonL2 = Controller.L2;
		Controller.ButtonR1 = Controller.R1;
		Controller.ButtonR2 = Controller.R2;
		Controller.ButtonL3 = Controller.L3;
		Controller.ButtonR3 = Controller.R3;
		Controller.ButtonStart = Controller.Start;
		Controller.ButtonSelect = Controller.Select;
		Controller.Thumbstick1 = Controller.Analogue1;
		Controller.Thumbstick2 = Controller.Analogue2;
		Controller.Analog1 = Controller.Analogue1;
		Controller.Analog2 = Controller.Analogue2;
		Controller.DPadLeft = Controller.Left;
		Controller.DPadRight = Controller.Right;
		Controller.DPadUp = Controller.Up;
		Controller.DPadDown = Controller.Down;
		Controller.ThumbStick1 = Controller.Analogue1;
		Controller.ThumbStick2 = Controller.Analogue2;
	end;
	for k,v in next, InputSources do
		local np = newproxy(true);
		local mt = getmetatable(np);
		mt.__index = v;
		mt.__tostring = function()return k end;
		mt.__metatable = "Locked metatable: Valkyrie";
		InputSources[k] = np;
	end;
	InputSources.Touchscreen = InputSources.TouchScreen;
	InputSources.Touch = InputSources.TouchScreen;
	InputSources.Gamepad = InputSources.Controller;
	InputSources.GamePad = InputSources.Controller;
	local ni = InputSources;
	InputSources = newproxy(true);
	local mt = getmetatable(InputSources);
	mt.__index = ni;
	mt.__metatable = "Locked metatable: Valkyrie";
	mt.__tostring = function() return "Valkyrie Input Sources" end;
end;
local InputDirections = {
	Up = newproxy(false);
	Down = newproxy(false);
	DownUp = newproxy(false);
	Change = newproxy(false);
};
InputDirections.Click = InputDirections.DownUp;
InputDirections.Tap = InputDirections.DownUp;
InputDirections.Start = InputDirections.Down;
InputDirections.Begin = InputDirections.Down;
InputDirections.Finish = InputDirections.Up;
InputDirections.End = InputDirections.Up;
InputDirections.Changed = InputDirections.Change;
InputDirections.Update = InputDirections.Update;
do
	local id = InputDirections;
	InputDirections = newproxy(true);
	local mt = getmetatable(InputDirections);
	mt.__index = id;
	mt.__metatable = "Locked metatable: Valkyrie";
	mt.__tostring = function() return "Valkyrie Input Directions" end;
end;

-- Make input objects and bind at the same time if the input is not already bound.
-- If the input is bound, then that's all fine.
local UIS = game:GetService("UserInputService");
local Mouse = game:GetService("Players").LocalPlayer:GetMouse();
local CAS = game:GetService("ContextActionService");
local InputTracker = {};
local InputCache = {};
local BoundUnique = {};
local function CreateInputState(source)
	-- Create a generic input object for the target Source
	if InputCache[source] then return InputCache[source] end;
	local iType = LinkedTypes[source];
	local iName = LinkedNames[source];
	local ni = newproxy(true);
	local mt = getmetatable(ni);
	local Props = {};
	mt.__index = Props;
	InputTracker[ni] = Props;
	mt.__tostring = function()
		return "Valkyrie Input: "..iName.." ("..iType..")";
	end;
	if Type == 'Keyboard' then
		Props.Key = iName;
		-- Bound already
	elseif Type == 'Mouse1' then
		Props.Key = "Mouse1";
		Props.Target = Mouse.Target;
	elseif Type == 'Mouse2' then
		Props.Target = Mouse.Target;
		Props.Key = "Mouse2";
	elseif Type == 'Mouse3' then
		Props.Target = Mouse.Target;
		Props.Key = "Mouse3"
	elseif Type == 'MouseMoved' then
		Props.Target = Mouse.Target;
	elseif Type == 'MouseScrolled' then

	elseif Type == 'ControllerButton' then

	elseif Type == 'ControllerTrigger' then

	elseif Type == 'ControllerAxis' then

	elseif Type == 'TouchScreen' then

	end;
end;
-- Bind UIS outside of the function because of how it works
local UISEdge = function(i,p)
	local iType = i.UserInputType.Name;
	local sType = iType;		Props.Target = Mouse.Target;
	local sName;
	if sType == 'Keyboard' then
		sName = i.KeyCode;
	elseif sType == 'Touch' then
		-- Etc
	elseif sType == 'MouseButton0' then
		sType = 'Mouse';
		sName = 'Mouse1';
	elseif sType == 'MouseButton1' then
		sType = 'Mouse';
		sName = 'Mouse2';
	elseif sType == 'MouseButton2' then
		sType = 'Mouse';
		sName = 'Mouse3';
	elseif sType == 'MouseMovement' then
		sType = 'Mouse';
		sName = 'Moved';
	elseif sType:sub(1,-2) == 'Gamepad' then
		sType = 'Controller'
		sName = i.KeyCode;
	end;
	local source = InputSources[sType][sName];
	local dir = i.UserInputState == Enum.UserInputState.Begin and InputDirections.Up or InputDirections.Down;
	if i.UserInputState == Enum.UserInputState.Changed then
		dir = InputDirections.Change;
	end;
	local iobj = CreateInputState(source);
	local iprops = InputTracker[iobj];
	iprops.InputName = sName;
	iprops.InputType = sType;
	if sType == 'Mouse' and props.Target ~= Mouse.Target then
		props.OldTarget = props.Target;
		props.Target = Mouse.Target;
	end;
	if iType == 'MouseMovement' then
		iprops.Position = i.Position;
	elseif sType == 'MouseScrolled' then
		dir = i.Delta.Y > 0 and InputDirections.Up or InputDirections.Down;
	elseif sType == 'ControllerTrigger' then

	else

	end;
	IntentService:FireIntent("VInputEdge", source, dir, i, p);
end;
UIS.InputBegan:connect(UISEdge);
UIS.InputEnded:connect(UISEdge);
UIS.InputChanged:connect(UISEdge);

-- Create actions
function Controller.CreateAction(...)
	local actionname,defaultaction = extract(...);
	assert(
		type(actionname) == 'string',
		"[Error][Valkyrie Input] (in CreateAction): Supplied action name was not a string",
		2
	);
	assert(
		type(defaultaction) == 'function',
		"[Error][Valkyrie Input] (in CreateAction): Supplied action callback was not a function",
		2
	);
	if Actions[actionname] then
		return error(
			"[Error][Valkyrie Input] (in CreateAction): Supplied action name is already bound to an Action ("..actionname..")",
			2
		);
	end;
	local newAction = newproxy(true);
	local newContent = {
		Name = actionname;
		Action = defaultaction;
		self = newAction;
	};
	local newMt = getmetatable(newAction);
	for k,v in next, ActionMt do
		newMt[k] = v;
	end;
	Actions[actionname] = newAction;
	ActionLinks[newAction] = newContent;
	return newAction;
end;

Controller.Mouse = Mouse;
Controller.CAS = CAS;
Controller.UIS = UIS;

function ActionClass:UnbindAll()
	local binds = ActionBinds[self];
	for i=#binds,1,-1 do
		binds[i]:disconnect();
		binds[i] = nil;
	end;
end;

function ActionClass:SetFlag(flag, value)
	if flag == 'User' then
		value = (not not value) or nil;
		IntentService:FireIntent("SetUserAction", self, value or false);
		UserActions[self] = value;
	else
		return error(
			"[Error][Valkyrie Input] (in Action:SetFlag()): "..flag.." is not a valid flag.",
			2
		);
	end;
end;
do
	local CustomConnection do
		-- Constructor for custom Connection objects
		local finishers = setmetatable({},{__mode = 'k'});
		local disconnectAction = function(self)
			if finishers[self] then
				finishers[self](self);
				finishers[self] = nil;
			else
				warn("Unable to disconnect disconnected action for ValkyrieInput");
			end;
		end;
		local cmt = {
			__index = function(t,k)
				if k == 'disconnect' then
					return disconnectAction;
				end;
			end;
			__metatable = "Locked metatable: Valkyrie";
			__tostring = function()
				return "Connection object for ValkyrieInput";
			end;
		};
		CustomConnection = function(disconnectFunc)
			local newConnection = newproxy(true);
			local newMt = getmetatable(newConnection);
			for e,m in next, cmt do
				newMt[e] = m;
			end;
			finishers[newConnection] = disconnecFunc;
			return newConnection;
		end;
	end;
	-- @source: Valkyrie Input type
	-- @dir: Input direction (Up, Down, UpDown/Click)
	-- @func: Binding function
	function ActionClass:BindControl(source, dir, func)
		-- ~ UIS/Mouse style input sources to bind from
		assert(source, "You need to supply an Input source as #1", 2);
		local Type, Name = LinkedTypes[source],LinkedNames[source];
		assert(
			Type and Name,
			"You need to supply a valid Valkyrie Input as #1, did you supply a string by accident?",
			2
		);

		--> Connection
	end;
	function ActionClass:BindSource(source, dir, object, func)
		-- ~ Binding actions for Instances with input sources
		-- @object: Binding target

		--> Connection
	end;
	function ActionClass:BindContext(keyboard, controller, touchscreen, dir, makebutton, func)
		-- ~ Extra content binding, CAS style
		-- @keyboard: Keyboard input type
		-- @controller: Controller input type
		-- @touchscreen: Touchscreen input type
		-- @dir: ::@dir
		-- @makebutton: Create an onscreen button for this input source?

		--> Connection, ?Button
	end;
	function ActionClass:CreateButton(source, dir, name, color, position, func)
		-- @name: Name of the button, and the text displayed. Can be nil.
		-- @color: Color3 of the button. Can be nil.
		-- | Color can also be a name of a Material Color for a [500] Color
		-- @position: UDim2 of the button Position. Can be nil (automatic positioning)

		--> Connection, Button
	end;
	function ActionClass:BindCombo(sources, func)
		-- @sources: Table array of Valkyrie Input Sources
		-- | Sources are to be checked with a DownUp/Click

		--> Connection
	end;
	function ActionClass:BindSequence(sources, func)
		-- @sources: Table array of Valkyrie Input Sources
		-- | Sources are to be checked in order. No tree building here.

		--> Connection
	end;
	function ActionClass:BindTouchAction(source, func)
		-- ~ Specific touch events like tapping, pinching, scrolling etc
	end;
end;


do
	local mt = getmetatable(this);
	mt.__index = Controller;
	mt.__tostring = function()
		return "Valkyrie Input controller";
	end;
	mt.__metatable = "Locked metatable: Valkyrie";
end;

return this;
