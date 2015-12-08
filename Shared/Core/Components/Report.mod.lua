local report = newproxy(true);
do
	local select = select;
	local function pack(...)
		return {n=select('#',...),...};
	end;
	local next = next;
	local rawset = rawset;
	local reportMt = getmetatable(report);
	local reportBufferProxy = {};
	reportMt.__index = function(t,k)
		table.insert(reportBufferProxy,k);
		return t;
	end;
	reportMt.__newindex = function()
		error("No.", 2);
	end;
	reportMt.__tostring = function(t)
		return "Status reporting function"
	end;
	reportMt.__call = function(t,...)
		local r = {
			result = pack(...);
			type = reportBufferProxy[1];
			success = (reportBufferProxy[1]:lower() ~= 'Error');
			source = reportBufferProxy[2] or setfenv(2,getfenv(2));
			tag = reportBufferProxy[3];
			message = reportBufferProxy[4];
			unpack(reportBufferProxy,5);
		};
		setmetatable(r,{
			__tostring = r.success
			and function() return r.message end
			or function()
				return string.format("[Error][%s] (in %s): %s", r.source, r.tag, r.message);
			end;
		});
		for k in next, reportBufferProxy do
			rawset(reportBufferProxy,k,nil);
		end;
		return r;
	end;
	reportMt.__len = function(t)
		return #reportBufferProxy;
	end;
	reportMt.__metatable = "Locked metatable: Valkyrie"
end;
return report;
