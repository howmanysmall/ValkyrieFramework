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

function ActionClass:Unbind()
	ActionBinds[self]:disconnect();
	ActionBinds[self] = nil;
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

function ActionClass:Bind(source, dir, func)
	-- @source: Valkyrie Input type
	-- @dir: Input direction (Up, Down, UpDown/Click)
	-- @func: Binding function
	
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
