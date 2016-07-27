local cxitio = {};
local r = newproxy(true);
local client;
local type = type;

local ValkyrieEvents;

local LocalIntent;
local RemoteIntent;
local RemoteIntentBind;

local function extract(...)
	if (...) == r then
		return select(2,...);
	else
		return ...
	end;
end;

-- Quickly test to see if we're on the client Valkyrie
if game:GetService("RunService"):IsStudio() then
	if script:IsDescendantOf(game.Players) then
		client = true;
		-- Success: You're on the client Valkyrie
		-- Register intent from the server, and to the server
		RemoteIntent = game.ReplicatedStorage:WaitForChild("ValkyrieIntent");
		RemoteIntent.OnClientEvent:connect(function(Intent,...)
			RemoteIntentBind:Fire(Intent,...);
		end);
		cxitio.BroadcastRPCIntent = function(...)
			RemoteIntent:FireServer(extract(...));
		end;
	else
		client = false;
		-- On the server Valkyrie
		-- Register intent from the client, and to the client
		RemoteIntent = game.ReplicatedStorage:FindFirstChild("ValkyrieIntent")
		if not RemoteIntent then
			RemoteIntent = Instance.new("RemoteEvent");
			RemoteIntent.Name = "ValkyrieIntent";
			RemoteIntent.Parent = game.ReplicatedStorage;
		end;
		RemoteIntent.OnServerEvent:connect(function(p,Intent,...)
			RemoteIntentBind:Fire(Intent,p,...);
		end);
		cxitio.BroadcastRPCIntent = function(...)
			local args = {n=select('#',extract(...)),extract(...)};
			if args[2] == 'All' then
				RemoteIntent:FireAllClients(args[1], unpack(args,3,args.n));
			else
				RemoteIntent:FireClient(args[2],args[1],unpack(args,3,args.n));
			end;
		end;
	end;
elseif game:GetService("RunService"):IsClient() then
	client = true;
	-- Success: You're on the client Valkyrie
	-- Register intent from the server, and to the server
	RemoteIntent = game.ReplicatedStorage:WaitForChild("ValkyrieIntent");
	RemoteIntent.OnClientEvent:connect(function(Intent,...)
		RemoteIntentBind:Fire(Intent,...);
	end);
	cxitio.BroadcastRPCIntent = function(...)
		RemoteIntent:FireServer(extract(...));
	end;
else
	client = false;
	-- On the server Valkyrie
	-- Register intent from the client, and to the client
	RemoteIntent = game.ReplicatedStorage:FindFirstChild("ValkyrieIntent")
	if not RemoteIntent then
		RemoteIntent = Instance.new("RemoteEvent");
		RemoteIntent.Name = "ValkyrieIntent";
		RemoteIntent.Parent = game.ReplicatedStorage;
	end;
	RemoteIntent.OnServerEvent:connect(function(p,Intent,...)
		RemoteIntentBind:Fire(Intent,p,...);
	end);
	cxitio.BroadcastRPCIntent = function(...)
		local args = {n=select('#',extract(...)),extract(...)};
		if args[2] == 'All' then
			RemoteIntent:FireAllClients(args[1], unpack(args,3,args.n));
		else
			RemoteIntent:FireClient(args[2],args[1],unpack(args,3,args.n));
		end;
	end;
end;

cxitio.RegisterRPCIntent = function(...)
	local Intent,f = extract(...);
	assert(Intent and type(f) == 'function', "Invalid arguments", 2);
	return RemoteIntentBind:connect(function(i,...)
		if i == Intent then f(...) end;
	end);
end;

cxitio.RegisterIntent = function(...)
	local Intent,f = extract(...);
	assert(Intent and type(f) == 'function', "Invalid arguments", 2);
	return LocalIntent:connect(function(i,...)
		if i == Intent then f(...) end;
	end);
end;
cxitio.ConnectIntent = cxitio.RegisterIntent;

cxitio.BroadcastIntent = function(...)
	LocalIntent:Fire(extract(...));
end;

cxitio.FireIntent = cxitio.BroadcastIntent;
cxitio.FireRPCIntent = cxitio.BroadcastRPCIntent;
cxitio.InvokeIntent = function(...)
	return error("[Error][Valkyrie Intents] (in IntentService:InvokeIntent()): Invoke is not yet implemented");
end;

cxitio.BroadcastUniversal = function(...)
    cxitio.BroadcastIntent(...);
    if client then
        cxitio.BroadcastRPCIntent(...);
    else
        cxitio.BroadcastRPCIntent(select(2,extract(...)));
    end;
end;
cxitio.FireUniversal = cxitio.BroadcastUniversal;
cxitio.FireUniversalIntent = cxitio.BroadcastUniversal;
cxitio.BroadcastUniversalIntent = cxitio.BroadcastUniversal;

cxitio.RegisterUniversal = function(...)
    local rpcc, locc;
    locc = cxitio.RegisterIntent(...);
    rpcc = cxitio.RegisterRPCIntent(...);
    return {
        disconnect = function()
            rpcc:disconnect();
            locc:disconnect();
        end;
    };
end;
cxitio.ConnectUniversal = cxitio.RegisterUniversal;
cxitio.ConnectUniversalIntent = cxitio.RegisterUniversal;
cxitio.RegisterUniversalIntent = cxitio.RegisterUniversal;

local mt = getmetatable(r);
mt.__index = function(t,k)
	ValkyrieEvents = _G.Valkyrie:GetComponent("ValkyrieEvents");
	LocalIntent = ValkyrieEvents.new "Event"
	RemoteIntentBind = ValkyrieEvents.new "Event"
	mt.__index = cxitio;
	return t[k];
end;
mt.__tostring = function()
	return "Valkyrie Intent Service: "..(client and "Client" or "Server");
end;
mt.__metatable = "Locked metatable: Valkyrie";
return r;
