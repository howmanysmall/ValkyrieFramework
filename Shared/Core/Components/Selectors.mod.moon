-- I should be writing LiteLib right now.
Controller = {};
MoonUtil = _G.Valkyrie\GetComponent "MoonUtil"
r = newproxy true
extract = MoonUtil.ExtractWrapper r

-- Body
Controller.CompileSelector = extract (Selector) ->
	-- Start with primitive matching.
	for section in Selector\gmatch "[^,]+"
		-- Every single section.
		for selection in Selector\gmatch "%S+"
			-- Every single selection.

Controller.Select = extract (Selector, Source = workspace) ->
	if type Selector == 'string'
		Selector = Controller.CompileSelector Selector


with getmetatable r
	.__index = Controller
	.__metatable = "Locked Metatable: Valkyrie"
	.__tostring = -> "Valkyrie Selectors Controller"

return r;
