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
		local binds = ActionBinds[this];
		for i=1,#binds do
			binds[i]:disconnect();
		end;
	end;
};
local UserActions = setmetatable({},{__mode = 'v'});

local iBinds = {};
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
		Controller1 = {
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
		Controller2 = {
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
		Controller3 = {
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
		Controller4 = {
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
		Application = {
			Focus = make("ApplicationFocus", "Focus");
		};
		ClickDetector = {
			Click = make("ClickDetector", "Click");
			Hover = make("ClickDetector", "Hover");
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
		for i=1,4 do
			local Controller = InputSources["Controller"..tostring(i)];
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
InputDirections.Update = InputDirections.Change;
InputDirections.Updated = InputDirections.Change;
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
local CreateInputState, UISEdge, UISProxy;
CreateInputState = function(source, meta)
	-- Create a generic input object for the target Source
	if not source then return end;
	if not meta then
		if InputCache[source] then return InputCache[source] end;
	else
		if InputCache[meta] and InputCache[meta][source] then return InputCache[meta][source] end;
	end;
	local iType = LinkedTypes[source];
	local iName = LinkedNames[source];
	if not (iType or iName) then return end;
	local ni = newproxy(true);
	local mt = getmetatable(ni);
	local Props = {};
	mt.__index = Props;
	InputTracker[ni] = Props;
	mt.__tostring = function()
		return "Valkyrie Input: "..iName.." ("..iType..")";
	end;
	if iType == 'Keyboard' then
		Props.Key = iName;
		-- Bound already
	elseif iType == 'Mouse1' then
		Props.Key = "Mouse1";
		Props.Target = Mouse.Target;
	elseif iType == 'Mouse2' then
		Props.Target = Mouse.Target;
		Props.Key = "Mouse2";
	elseif iType == 'Mouse3' then
		Props.Target = Mouse.Target;
		Props.Key = "Mouse3"
	elseif iType == 'MouseMoved' then
		Props.Target = Mouse.Target;
	elseif iType == 'MouseScrolled' then
		Props.ScrollY = 0;
	elseif iType == 'ControllerButton' then
		Props.Key = iName;
		Props.Button = iName;
		for i=1,4 do
			if InputSources["Controller"..tostring(i)][iName] == source then
				Props.Controller = i;
				break;
			end;
		end;
	elseif iType == 'ControllerTrigger' then
		Props.Key = iName;
		Props.Button = iName;
		Props.Trigger = iName;
		for i=1,4 do
			if InputSources["Controller"..tostring(i)][iName] == source then
				Props.Controller = i;
				break;
			end;
		end;
		-- It's happening.
	elseif iType == 'ControllerAxis' then
		for i=1,4 do
			if InputSources["Controller"..tostring(i)][iName] == source then
				Props.Controller = i;
				break;
			end;
		end;
		Props.Key = iName;
		Props.Stick = iName;
		Props.Analogue = iName;
	elseif iType == 'TouchScreen' then
		-- No idea how to configure this one.
		-- Location::Position
	end;
	if meta:IsA("GuiObject") then
		BoundUnique[meta] = true;
		meta.InputBegan:connect(UISProxy(meta));
		meta.InputEnded:connect(UISProxy(meta));
		meta.InputChanged:connect(UISProxy(meta));
	end;
	local iBind = Instance.new("BindableEvent");
	if not meta then
		InputCache[source] = ni;
	else
		InputCache[meta] = InputCache[meta] or {};
		InputCache[meta][source] = ni;
	end;
	iBinds[ni] = iBind;
end;
-- Bind UIS outside of the function because of how it works
UISEdge = function(i,p,m)
	local iType = i.UserInputType.Name;
	local sType = iType;
	local sName;
	if sType == 'Keyboard' then
		sName = i.KeyCode.Name;
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
		sName = i.KeyCode.Name;
	elseif sType == 'Focus' then
		sType = 'Application';
		sName = 'Focus';
	end;
	local source = InputSources[sType][sName];
	if not source then return end;
	local vType = LinkedTypes[source];
	local dir = i.UserInputState == Enum.UserInputState.Begin and InputDirections.Up or InputDirections.Down;
	if i.UserInputState == Enum.UserInputState.Changed then
		dir = InputDirections.Change;
	end;
	local iobj = CreateInputState(source, m);
	local iprops = InputTracker[iobj];
	iprops.InputName = sName;
	iprops.InputType = sType;
	if sType == 'Mouse' and iprops.Target ~= Mouse.Target then
		iprops.OldTarget = iprops.Target;
		iprops.Target = Mouse.Target;
		iprops.Hit = Mouse.Hit;
	end;
	if iType == 'MouseMovement' then
		iprops.Position = i.Position;
	elseif sType == 'MouseScrolled' then
		dir = i.Delta.Y > 0 and InputDirections.Up or InputDirections.Down;
		iprops.ScrollY = iprops.ScrollY + i.Delta.Y; -- Not sure about Pos
	elseif vType == 'ControllerTrigger' then
		iprops.Position = i.Position;
		iprops.Axis = i.Position.Y;
		iprops.Var = i.Position.Y;
	elseif vType == 'ApplicationFocus' then
		iprops.Focused = dir == InputDirections.Down;
	else
		iprops.Down = dir == InputDirections.Down
	end;
	iBinds[iobj]:Fire(iobj, dir, p, i);
end;
UIS.InputBegan:connect(UISEdge);
UIS.InputEnded:connect(UISEdge);
UIS.InputChanged:connect(UISEdge);
UISProxy = function(m)
	return function(i,p)
		return UISEdge(i,p,m);
	end;
end;

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
	ActionBinds[newAction] = {};
	return newAction;
end;

function Controller.GetAction(...)
	local actionname = extract(...);
	assert(
		type(actionname) == 'string',
		"[Error][Valkyrie Input] (in GetAction): Supplied action name was not a string",
		2
	);
	return Actions[actionname];
end;

Controller.Mouse = Mouse;
Controller.CAS = CAS;
Controller.UIS = UIS;

Controller.InputDirections = InputDirections;
Controller.InputSources = InputSources;
Controller.GetInputState = CreateInputState;

function ActionClass:UnbindAll()
	local binds = ActionBinds[self];
	for i=#binds,1,-1 do
		if binds[i] then
			binds[i]:disconnect();
			binds[i] = nil;
		end;
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
			if not self then
				error("[Error][Valkyrie Input] (in connection:disconnect()): No connection given. Did you forget to call this as a method?", 2);
			if finishers[self] then
				finishers[self](self);
				finishers[self] = nil;
			else
				warn("[Warn][Valkyrie Input] (in connection:disconnect()): Unable to disconnect disconnected action for ValkyrieInput");
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
			finishers[newConnection] = disconnectFunc;
			return newConnection;
		end;
	end;
	-- @source: Valkyrie Input type
	-- @dir: Input direction (Up, Down, UpDown/Click)
	function ActionClass:BindControl(source, dir)
		-- ~ UIS/Mouse style input sources to bind from
		assert(source, "[Error][Valkyrie Input] (in ActionClass:BindControl()): You need to supply an Input source as #1", 2);
		local Type, Name = LinkedTypes[source],LinkedNames[source];
		assert(
			Type and Name,
			"[Error][Valkyrie Input] (in ActionClass:BindControl()): You need to supply a valid Valkyrie Input as #1, did you supply a string by accident?",
			2
		);
		assert(dir, "[Error][Valkyrie Input] (in ActionClass:BindControl()): You need to supply an Input direction as #2", 2);
		do local suc = false;
			for k,v in next, InputDirections do
				if v == dir then
					suc = true;
					break;
				end;
			end;
			if not suc then
				error("[Error][Valkyrie Input] (in ActionClass:BindControl()): You need to supply a valid Valkyrie Input direction object as #2", 2);
			end;
		end;
		
		-- Grab the input object for the source
		local iobj = CreateInputState(source);
		
		-- Wrap the function in a binding
		local func,bfunc = self.Action
		if d == InputDirections.UpDown then
			local down = false;
			bfunc = function(i,d,p,r)
				if d == InputDirections.Up then
					if down then
						down = false;
						return func(i,p,r);
					end;
					down = false
				elseif d == InputDirections.Down then
					down = true;
				end;
			end;
		else
			bfunc = function(i,d,p,r)
				if d == dir then
					return func(i,p,r);
				end;
			end;
		end;
		
		--> Connection
		local bind = iBinds[iobj].Event:connect(bfunc);
		ActionBinds[self][#ActionBinds[self]+1] = bind;
		return bind;
	end;
	function ActionClass:BindSource(source, dir, object)
		-- ~ Binding actions for Instances with input sources
		-- ~ Similar to BindControl
		-- @object: Binding target
		assert(source, "[Error][Valkyrie Input] (in ActionClass:BindSource()): You need to supply an Input source as #1", 2);
		local Type, Name = LinkedTypes[source],LinkedNames[source];
		assert(
			Type and Name,
			"[Error][Valkyrie Input] (in ActionClass:BindSource()): You need to supply a valid Valkyrie Input as #1, did you supply a string by accident?",
			2
		);
		assert(dir, "[Error][Valkyrie Input] (in ActionClass:BindSource()): You need to supply an Input direction as #2", 2);
		do local suc = false;
			for k,v in next, InputDirections do
				if v == dir then
					suc = true;
					break;
				end;
			end;
			if not suc then
				error("[Error][Valkyrie Input] (in ActionClass:BindSource()): You need to supply a valid Valkyrie Input direction object as #2", 2);
			end;
		end;
		assert(object, "[Error][ValkyrieInput] (in ActionClass:BindSource()): You need to supply a valid source as #3", 2);
		
		-- Grab the input object for the source
		local iobj = CreateInputState(source, object);
		
		-- Wrap the function in a binding
		local func,bfunc = self.Action
		if d == InputDirections.UpDown then
			local down = false;
			bfunc = function(i,d,p,r)
				if d == InputDirections.Up then
					if down then
						down = false;
						return func(i,p,r);
					end;
					down = false
				elseif d == InputDirections.Down then
					down = true;
				end;
			end;
		else
			bfunc = function(i,d,p,r)
				if d == dir then
					return func(i,p,r);
				end;
			end;
		end;
		
		--> Connection
		local bind = iBinds[iobj].Event:connect(bfunc);
		ActionBinds[self][#ActionBinds[self]+1] = bind;
		return bind;
	end;
	function ActionClass:BindContext(keyboard, controller, touchscreen, dir, makebutton)
		-- ! Look at the CAS API and change the order of arguments around.
		-- ~ Extra content binding, CAS style
		-- @keyboard: Keyboard input type
		-- @controller: Controller input type
		-- @touchscreen: Touchscreen input type
		-- @dir: ::@dir
		-- @makebutton: Create an onscreen button for this input source?

		--> Connection, ?Button
	end;
	function ActionClass:CreateButton(name, color, position)
		-- @name: Name of the button, and the text displayed. Can be nil.
		-- @color: Color3 of the button. Can be nil.
		-- | Color can also be a name of a Material Color for a [500] Color
		-- @position: UDim2 of the button Position. Can be nil (automatic positioning)
		-- ~ Redirects a button press (From any input that can provide it) to the action

		--> Connection, Button
	end;
	function ActionClass:BindCombo(sources)
		-- @sources: Table array of Valkyrie Input Sources
		-- | When they're all down, it fires. Once.
		
		local BindCollection = {};
		local Totals = {};
		local ilist = {};
		local errmsg;
		local func = self.Action;
		for i=1,#sources do
			local v = sources[i];
			if not v then
				errmsg = "The source table is not an array";
				break;
			end;
			local Type, Name = LinkedTypes[v],LinkedNames[v];
			if not (Type and Name) then
				errmsg = "The source table contains an invalid source at ["..tostring(i).."]";
				break;
			end;
			local iobj = CreateInputState(v);
			ilist[i] = iobj;
			Totals[i] = false;
			local Bind = iBinds[iobj].Event:connect(function(q,d,p,r)
				if d == InputDirections.Up then
					Totals[i] = false;
				elseif d == InputDirections.Down then
					local isDown = true;
					Totals[i] = true;
					for n=1,#Totals do
						if not Totals[i] then
							isDown = false;
							break;
						end;
					end;
					if isDown then
						return func(ilist,p,r);
					end;
				end;
			end);
			BindCollection[#BindCollection+1] = Bind;
		end;
		if errmsg then
			for i=1, #BindCollection do
				BindCollection[i]:disconnect();
			end;
			error("[Error][Valkyrie Input] (in ActionClass:BindCombo()): "..errmsg, 2);
		end;
		
		--> Connection
		-- Create a CustomConnection Object to disconnect all of the connections stored inside of BindCollection
		return CustomConnection(function()
			for i=#BindCollection, 1, -1 do
				BindCollection[i]:disconnect();
				BindCollection[i] = nil;
			end;
		end);
	end;
	function ActionClass:BindSequence(sources)
		-- @sources: Table array of Valkyrie Input Sources
		-- | Sources are to be checked in order. No tree building here.
		local BindCollection = {};
		local curr = 1;
		

		--> Connection
	end;
	function ActionClass:BindTouchAction(source)
		-- ~ Specific touch events like tapping, pinching, scrolling etc
		
		--> Connection
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
