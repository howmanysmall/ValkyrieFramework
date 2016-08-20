local ENABLE 		= true;

local module		= {};
local encoder;
local decoder;
local GID;
local URL;
local Key;

local proxy;
local error;
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
            GID, URL, Key, encoder, decoder, error = ...;
        end
    }, {__index = function(t, rem_module)
		local func_proxy;
		do
			func_proxy 			= newproxy(true);
			local func_mt		= getmetatable(func_proxy);
			func_mt.__tostring	= function() return format("Valkyrie RemoteCommunication: %s Module", rem_module); end
			func_mt.__len		= function() return 117; end;
			func_mt.__metatable	= "Locked Metatable: Valkyrie";

			func_mt.__index		= function(t, rem_function)
				return function(should_be_func_proxy, args, _GID, _URL, _Key)
					if ENABLE then
						if _GID then
							encoder 	= _encoder;
							decoder 	= _decoder;
							GID 		= _GID;
							URL 		= _URL;
							Key 		= _Key;
						end
						assert(should_be_func_proxy == func_proxy, "You have to call this as a method solely for consistency with Roblox. Thanks Roblox.", 2);
						-- Just because.
						rem_module		= HS:UrlEncode(rem_module);
						rem_function	= HS:UrlEncode(rem_function);
						local req_url	= format("%s/api/%s/%s/%s/%s", URL, rem_module, rem_function, GID, Key);
                        local Result;
                        local Success, Error = pcall(function() Result = HS:PostAsync(req_url, HS:JSONEncode(args)) end);
                        if not Success then
                            return nil, error {
                              Tag = "RemoteCommunication",
                              Section = rem_module,
                              Level = 1,
                              Message = Error,
                              Type = "Internal"
                            }
                        end
						local ret		= HS:JSONDecode(Result);
						if ret.Success then
						    return ret.Result, nil
					    else
					        return nil, error {
					            Tag = rem_module,
					            Section = rem_function,
					            Level = 2,
					            Message = ret.Error,
                      Type = "Server"
				            }
				        end
					else
						return true;
					end
				end;
			end
		end

		return func_proxy;
	end});
	mt.__tostring	= "Valkyrie RemoteCommunication Component";
	mt.__len		= function() return 117 end;
	mt.__metatable	= "Locked Metatable: Valkyrie";
end
return proxy;
