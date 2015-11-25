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
	for k,v in next, InputSources do
		local np = newproxy(true);
		local mt = getmetatable(np);
		mt.__index = v;
		mt.__tostring = function()return k end;
		mt.__metatable = "Locked metatable: Valkyrie";
		InputSources[k] = np;
	end;
	InputSources.Touchscreen = InputSources.TouchScreen;
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
};
InputDirections.Click = InputDirections.DownUp;
InputDirections.Tap = InputDirections.DownUp;
InputDirections.Start = InputDirections.Down;
InputDirections.Begin = InputDirections.Down;
InputDirections.Finish = InputDirections.Up;
InputDirections.End = InputDirections.Up;
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

	elseif Type == 'Mouse1' then

	elseif Type == 'Mouse2' then

	elseif Type == 'MouseMoved' then

	elseif Type == 'MouseScrolled' then

	elseif Type == 'ControllerButton' then

	elseif Type == 'ControllerTrigger' then

	elseif Type == 'ControllerAxis' then

	elseif Type == 'TouchScreen' then

	end;
end;
-- Bind UIS outside of the function because of how it works
local UISEdge = function(i,p)
	local sType = i.UserInputType;
	local sName;
	if sType == 'Keyboard' then
		sName = i.KeyCode;
	elseif sType == 'Touchscreen' then
		-- Etc
	end;
	local source = InputSources[sType][sName];
	local iobj = CreateInputStats(source);
	local iprops = InputTracker[iobj];
	iprops.InputName = sName;
	iprops.InputType = sType;
	if sType == 'MouseMoved' then
		
	elseif sType == 'MouseScrolled' then
		
	elseif sType == 'ControllerTrigger' then
		
	else
		
	end;
	
end;
UIS.InputBegan:connect(UISEdge);
UIS.InputEnded:connect(UISEdge);

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
