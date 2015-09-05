-- Valkyrie-based permissions control
-- Provides group permissions and user permissions, with inheritence
local report = _G.Valkyrie:GetComponent("Report");

-- Permission objects are userdata. Love the things.
local Permissions = {};
local Permissionmtlist = {};
local PermissionLinks = {};

-- Make something to actually generate Permissions
local function createPermission(name)
	-- Check people aren't being stupid
	assert(type(name)=='string', "Give a permission name as #1");

	-- Work out what this permission is
	local start = Permissions;
	local subsets = {};
	name:gsub("([^.])",function(c)
		subsets[#subsets] = c;
	end);
	if #subsets > 1 then
		for i=1,#subsets-1 do
			local v = subsets[i];
			if not start[v] then start[v] = {} end;
			if type(start[v]) ~= 'table' then
				error(
					report.Error.Permissions.Create
					[name.." overrites existing permission"]
				(),2);
			end;
			start = start[v];
		end;
	end;

	-- Create
	local newPermission = newproxy(true);
	local mt = getmetatable(newPermission);
	mt.__tostring = function()
		return name;
	end;
	mt.__metatable = {};
	-- Will possibly extend this later if Valkyrie gets a standard way to extend
	-- operator behaviour on data.

	-- Bind
	Permissionmtlist[newPermission] = mt;
	PermissionLinks[name] = newPermission;

	return newPermission;
end;

local function getPermission(permission)
	local target;
	if type(permission) == 'string' then
		target = PermissionLinks[permission];
	elseif type(permission) == 'userdata' then
		target = Permissionmtlist[permission] and permission or nil;
	end;
	return target
end

-- Populate the Permissions
do
	local Defaults = require(script.DefaultPermissions);
	for i=1,#Defaults do
		createPermission(Defaults[i]);
	end;
end;

-- Manage the permissions
-- That means, make the groups and users.
local groups = {};
local users = {};
local usergroups = {};
local gclass = {};
local glinks = setmetatable({},{__mode = 'v'});
-- [1] = Permissions; [2] = Users

local function createGroup(name, inherits)
	local newGroup = newproxy(true);
	local mt = getmetatable(newGroup);
	local gPermissions = {};
	local gUsers = {};
	if inherits then
		setmetatable(gPermissions,{
			__index = groups[inherits].Permissions
		});
	end;
	local pProx = newproxy(true);
	local uProx = newproxy(true);
	do
		local pmt = getmetatable(pProx);
		pmt.__index = function(_,k)
			if type(k) == 'string' then
				if PermissionLinks[k] then
					return gPermissions[PermissionLinks[k]];
				end
			else
				return gPermissions[k];
			end
		end;
		pmt.__tostring = function()
			return "Permissions: "..name;
		end;
		pmt.__metatable = '';
		pmt.__newindex = function(_,k,v)
			if type(k) == 'string' then
				if v == nil then
					gclass.RemovePermission(newGroup, k);
				elseif v == false then
					gclass.BlockPermission(newGroup, k);
				elseif v == true then
					gclass.AddPermission(newGroup, k);
				end;
			end;
		end;
		local umt = getmetatable(uProx);
		umt.__index = gUsers;
		umt.__tostring = function()
			return "Users: "..name;
		end;
		umt.__newindex = function(_,k,v)
			if v == nil then
				-- Clearing a user
				gclass.RemoveUser(newGroup, k);
			else
				gclass.AddUser(newGroup, v, k);
			end;
		end;
		umt.__metatable = '';
	end;
	mt.__index = function(_,k)
		if type(k) == 'string' then
			nk = k:lower();
			if nk == 'users' then
				return uProx;
			elseif nk == 'permissions' then
				return pProx;
			else
				return gclass[k];
			end;
		end;
	end;

	glinks[newGroup] = {gPermissions,gUsers};

	return newGroup;
end;

function gclass:AddPermission(permission)
	local plist = glinks[self][1];
	-- Check if our target permission exists
	local target = getPermission(permission)
	if not target then
		-- Not a valid permission? Shameful.
		return error(
			report.Error.Permissions.AddPermission
			["A valid permission was not supplied to be added."]
		(), 2);
	end;
	plist[target] = true;
end;

function gclass:BlockPermission(permission)
	local plist = glinks[self][1];
	local target = getPermission(permission)
	if not target then
		return error(
			report.Error.Permissions.BlockPermission
			["A valid permission was not supplied to be blocked."]
		(), 2);
	end;
	plist[target] = false;
end;

function gclass:RemovePermission(permission)
	local plist = glinks[self][1];
	local target = getPermission(permission);
	if not target then
		return error(
			report.Error.Permissions.RemovePermission
			["A valid permission was not supplied to be removed/defaulted."]
		(), 2);
	end;
	plist[target] = nil;
end;

function gclass:AddUser(user, alias)
	local ulist = glinks[self][1];
	assert(user, "You must provide a user to add", 2);
	if usergroups[user] then
		usergroups[user]:RemoveUser(user);
	elseif alias and usergroups[alias] then
		usergroups[alias]:RemoveUser(alias);
	end;
	if alias then
		ulist[alias] = user;
		usergroups[alias] = self;
	else
		ulist[user] = user;
		usergroups[user] = self;
	end;
end;

function gclass:RemoveUser(user)
	local ulist = glinks[self][1];
	assert(user, "You must provide a user to add", 2);
	usergroups[user] = nil;
	if ulist[user] then
		ulist[user] = nil;
	else
		for k,v in next, ulist do
			if v == user then ulist[k] = nil break end;
		end;
	end;
end;

-- Manage the controller
-- Users
-- Groups
-- Permissions

local controller = newproxy(true);
local controllerclass = {};
local controllermt = getmetatable(controller);

local function extract(...)
	if (...) == controller then
		return select(2, ...);
	else
		return ...
	end
end

function controllerclass.CreatePermission(...)
	return createPermission(extract(...));
end;

function controllerclass.GetPermission(...)
	return getPermission(extract(...));
end;

function controllerclass.CreateGroup(...)
	return createGroup(extract(...));
end;

function controllerclass.AddUserPermission(...)
	local user, permission = extract(...);
	assert(user and permission, "You need to supply (user, permission)", 2);
	local target = getPermission(permission);
	if not target then
		return error(
			report.Error.Permissions.AddUserPermission
			["A valid permission was not supplied to be added."]
		(), 2);
	end;
	if not users[user] then users[user] = {} end;
	users[user][target] = true;
end;

function controllerclass.RemoveUserPermission(...)
	local user, permission = extract(...);
	assert(user and permission, "You need to supply (user, permission)", 2);
	local target = getPermission(permission);
	if not target then
		return error(
			report.Error.Permissions.RemoveUserPermission
			["A valid permission was not supplied to be removed/defaulted."]
		(), 2);
	end;
	if not users[user] then users[user] = {} end;
	users[user][target] = nil;
end;

function controllerclass.BlockUserPermission(...)
	local user, permission = extract(...);
	assert(user and permission, "You need to supply (user, permission)", 2);
	local target = getPermission(permission);
	if not target then
		return error(
			report.Error.Permissions.BlockUserPermission
			["A valid permission was not supplied to be blocked."]
		(), 2);
	end;
	if not users[user] then users[user] = {} end;
	users[user][target] = false;
end;

function controllerclass.GetUserPermission(...)
	local user, permission = extract(...);
	assert(user and permission, "You need to supply (user, permission)", 2);
	local target = getPermission(permission);
	if not target then
		return error(
			report.Error.Permissions.GetUserPermission
			["A valid permission was not supplied to be checked."]
		(), 2);
	end;
	if not users[user] then users[user] = {} end;
	return users[user][target] or (usergroups[user] and usergroups[user].Permissions[target] or nil);
end;

function controllerclass.GetUserPermissions(...)
	local user = extract(...);
	assert(user, "You need to supply a user", 2);
	local uplist = {};
	if usergroups[user] then
		local curr = glinks[usergroups[user]][1];
		local cursion = {curr};
		while getmetatable(curr).__index do
			curr = getmetatable(curr).__index;
			cursion[#cursion+1] = curr;
		end;
		for i=#cursion, 1, -1 do
			for k,v in next, cursion[i] do
				uplist[k] = v;
			end;
		end;
	end;
	if not users[user] then users[user] = {} end;
	for k,v in next, users[user] do
		uplist[k] = v;
	end;
	return uplist;
end;

function controllerclass.GetGroup(...)
	local name = extract(...);
	assert(name, "You must provide a name of a Group", 2);
	return groups[name];
end;

controllermt.__index = controllerclass;
controllermt.__tostring = function() return "Permissions controller" end;
controllermt.__metatable = "Locked metatable: Valkyrie";

return controller
