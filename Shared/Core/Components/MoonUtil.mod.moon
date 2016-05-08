-- Moonscript utility
local ^
ExtractWrapper = (o) ->
	(...) ->
		select 2, ... if ... == o else ...

r = newproxy true
extract = ExtractWrapper r

Util = with {}
-- Essentially extractizer but for Moonscript use.
-- With a little more ugly.
-- Can work with vanilla Lua but was designed for Moonscript syntax
	.ExtractWrapper = extract ExtractWrapper
	

with getmetatable r
	.__index = Util
	.__metatable = "Locked Metatable: Valkyrie"
	.__tostring = -> "Valkyrie MoonUtil"

return r
