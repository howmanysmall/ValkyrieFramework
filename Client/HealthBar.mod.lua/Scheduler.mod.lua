local module			= {}
local rstep             = game:GetService("RunService").RenderStepped;
local tasks				= {};
function module.scheduleTask(func, async, ...)
	table.insert(tasks, {func, async, {...}});
end

spawn(function() -- Main loop
	local currTask;
	repeat
		currTask = table.remove(tasks, 1);
		if currTask then
			if currTask[2] then
				spawn(function() currTask[1](unpack(currTask[3])) end);
			else
				currTask[1](unpack(currTask[3]));
			end
		end
	until rstep:wait(); -- It will never return a thing!
end)
return module;