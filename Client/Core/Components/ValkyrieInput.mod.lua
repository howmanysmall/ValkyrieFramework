-- Unified input
-- Create actions, bind input.

local Controller = {};
local this = newproxy(true);

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

do
	local mt = getmetatable(this);
	mt.__index = Controller;
	mt.__tostring = function()
		return "Valkyrie Input controller";
	end;
	mt.__metatable = "Locked metatable: Valkyrie";
end;

return this;
