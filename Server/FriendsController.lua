repeat wait() until _G.Valkyrie;
local valkyrie = _G.Valkyrie;
local intent = valkyrie:GetComponent("IntentService");
local remote = valkyrie:GetComponent("RemoteCommunication");
local hs = game:GetService("HttpService");

intent:RegisterRPCIntent("FriendsController", function(player, command, ...)
	if command == "GetFriends" then
		if player.UserId > 0 then
			-- Because it has a chance to error (Not including the reason if Valkyrie Server goes down)
			local result;
			local success, message = pcall(function() result = remote.friends:getFriends({id = player.UserId}); end);
			repeat wait() until success ~= nil;
			if success then
				intent:BroadcastRPCIntent("FriendsController", player, command, result);
			else
				intent:BroadcastRPCIntent("FriendsController", player, command, false, "Remote communication error");
			end
		else
			intent:BroadcastRPCIntent("FriendsController", player, false, "Invalid UserId");
		end
	elseif command == "GetPlayerInfo" then
		-- Don't need to check UserId of the player as it's already been taken care of
		-- (And they should not send this request if their GetFriends errored, otherwise you can suspect something)
		-- Because it has a chance to error (Not including the reason if Valkyrie Server goes down)
		local userId = ...			
		
		local result;
		local success, message = pcall(function() result = remote.playerinfo:getUserinfo({id = userId}); end);
		repeat wait() until success ~= nil;
		if success then
			intent:BroadcastRPCIntent("FriendsController", player, command, result);
		else
			intent:BroadcastRPCIntent("FriendsController", player, command, false, "Remote communication error");
		end
	end;
end);