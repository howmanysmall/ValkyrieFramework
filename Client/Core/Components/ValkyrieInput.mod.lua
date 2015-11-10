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
	local UIS = game:GetService("UserInputService");
	local CAS = game:GetService("ContextActionService");
	local Mouse = game.Players.LocalPlayer:GetMouse();
	-- How do I determine how to bind a certain source .-.
	-- wtf ηττημένος xaxa
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
			Shift = make("Keyboard", "Shift");
			Tab = make("Keyboard", "Tab");
			Esc = make("Keyboard", "Escape");
			Space = make("Keyboard", "Space");
			
		};
		
	};
	for k,v in next, InputSources do
		local np = newproxy(true);
		local mt = getmetatable(np);
		mt.__index = v;
		mt.__tostring = function()return k end;
		mt.__metatable = "Locked metatable: Valkyrie";
		InputSources[k] = np;
	end;
	local ni = InputSources;
	InputSources = newproxy(true);
	local mt = getmetatable(InputSources);
	mt.__index = ni;
	mt.__metatable = "Locked metatable: Valkyrie";
	mt.__tostring = function() return "Valkyrie Input Sources" end;
end;

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
	local UIS = game:GetService("UserInputService");
	local Mouse = game:GetService("Players").LocalPlayer;
	local CAS = game:GetService("ContextActionService");
	
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
		if Type == 'Keyboard' then
			
		elseif Type == 'Mouse1' then
			
		elseif Type == 'Mouse2' then
			
		elseif Type == 'MouseMoved' then
			
		elseif Type == 'MouseScrolled' then
			
		elseif Type == 'ControllerButton' then
			
		elseif Type == 'TouchScreen' then
			
		end;
		
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


do
	local mt = getmetatable(this);
	mt.__index = Controller;
	mt.__tostring = function()
		return "Valkyrie Input controller";
	end;
	mt.__metatable = "Locked metatable: Valkyrie";
end;

return this;
