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
		pmt.__index = gPermissions;
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
			k = k:lower();
			if k == 'users' then
				return uProx;
			elseif k == 'permissions' then
				return pProx;
			else
				return gclass[k];
			end;
		end;
	end;

	glinks[newGroup] = {pProx,uProx};

	return newGroup;
end;
