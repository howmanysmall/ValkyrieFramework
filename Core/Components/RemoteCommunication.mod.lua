local ENABLE 		= true;

local module		= {};
local encoder;
local decoder;
local GID;
local URL;
local Key;

local proxy;
local assert		= assert;
local format		= string.format;
local getmetatable	= getmetatable;
local newproxy		= newproxy;
local HS			= game:GetService("HttpService");
do
	proxy			= newproxy(true);
	local mt		= getmetatable(proxy);
	mt.__index		= setmetatable({
        GiveDependencies         = function(...)
            GID, URL, Key, encoder, decoder = ...;
        end
    }, {__index = function(t, rem_module)
		local func_proxy;
		do
			func_proxy 			= newproxy(true);
			local func_mt		= getmetatable(func_proxy);
			func_mt.__tostring	= function() return format("Valkyrie RemoteCommunication: %s Module", rem_module); end
			func_mt.__len		= function() return 117; end;
			func_mt.__newindex	= function() warn "This time I don't even want to think of what's going inside your head!"; end;
			func_mt.__metatable	= "HAHAHAHA NOPE";

			func_mt.__index		= function(t, rem_function)
				return setfenv(function(should_be_func_proxy, args, _GID, _URL, _Key, _encoder, _decoder)
					if ENABLE then
						if _GID then
							encoder 	= _encoder;
							decoder 	= _decoder;
							GID 		= _GID;
							URL 		= _URL;
							Key 		= _Key;
						end
						assert(should_be_func_proxy == func_proxy, "You really have to call this as a method for no reason.", 2);
						-- Just because.
						rem_module		= HS:UrlEncode(rem_module);
						rem_function	= HS:UrlEncode(rem_function);
						local req_url	= format("%s/%s/%s/%s/%s", URL, rem_module, rem_function, GID, Key);
						local ret		= decoder(HS:PostAsync(req_url, encoder(args)));
						assert(ret.success, ret.error, 3);
						return ret.result;
					else
						return true;
					end
				end, {});
			end
		end

		return func_proxy;
	end});
	mt.__tostring	= "Valkyrie RemoteCommunication Component";
	mt.__len		= function() return 117 end;
	mt.__newindex	= function() error("What are you even trying to do?!",2) end;
	mt.__metatable	= "The feels when you know you're close to breaking it and you can't...";
end
return proxy;
