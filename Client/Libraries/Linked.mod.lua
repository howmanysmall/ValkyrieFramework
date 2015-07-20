local wrap, unwrap;
--[[--
	Linked datatypes library for Valkyrie libraries.
	Allows normally readonly values to replicate back to their source
	Breaks a lot of constructor things and a ton of logic, but hey.
--]]--

return function(Override, OverrideGlobal, wlist, ulist)
	wrap, unwrap = wrap, unwrap;
	local newlv3 = function(link, prop, val)
		local x,y,z = val.x, val.y, val.z;
		local r = newproxy(true);
		local mt = getmetatable(r);
		local props = {
			x = x;
			y = y;
			z = z;
			link = link;
			prop = prop;
		};
		local weak = setmetatable({link = link},{__mode = 'kv'});
		link = nil;
		mt.__index = function(_,k)
			return props[k] or Vector3.new(props.x, props.y, props.z)[k];
		end;
		mt.__newindex = function(_,k,v)
			if props[k] then props[k] = v;
			else error("You are not allowed to set "..tostring(k), 2);
			end;
			local n3 = Vector3.new(props.x, props.y, props.z);
			ulist[r] = n3;
			if weak.link then
				weak.link[prop] = n3;
			else
				error("Linked Instance no longer exists", 2);
			end;
		end;
		ulist[r] = val;
		mt.__tostring = function() return "Valkyrie linked Vector3" end;
		mt.__metatable= "Locked metatable: Valkyrie";
	end;
	Override "Instance" (function(mt,v)
		local oldindex = mt.__index;
		mt.__index = function(t,k)
			local nv = oldindex(t,k);
			local t = type(nv);
			if t == "Vector3" then
				return newlv3(v, k, nv);
			end
		end;
	end);
end;