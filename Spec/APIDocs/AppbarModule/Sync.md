Appbar Sync Function
===
The Sync Function is used for yielding until an asynchronous method is done.
It is implemented like so:

```lua
function Util.RunAsync(Runner)
	local Coroutine = coroutine.create(Runner);
	coroutine.resume(Coroutine);
	return function()
		while coroutine.status(Coroutine) ~= "dead" do
			RenderStepped:wait();
		end
	end
end
```