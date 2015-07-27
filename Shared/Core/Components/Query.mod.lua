-- function query:string -> function data:table -> var result
-- Query "Identify [x]" {x = SomethingToIdentify}
-- Query [[Clone [x] into [y\]]] {x = SomeInstance; y = SomeOtherInstance}
-- Query [[Group !all]] {Inst, Other, NewInst, Values}

-- Could be a good thing to try
local report = _G.Valkyrie:GetComponent "Report"

local QueryTrees = {
	Clone = {
		immediate = {1,'Instance'};
		runfunc = function(a,b)
			local c = a:Clone();
			if b then
				c.Parent = b;
			end;
			return c;
		end;
		capturenext = {
			into = {2,'Instance'};
			to = {2,'Instance'};
		};
	};
};

function identifyQuery(s)
	local targetQuery = s:match("^(%w*)%W");
	targetQuery = QueryTrees[targetQuery];
	if not targetQuery then
		return report.Error.QueryIdentify "No matching query";
	end;
	
end;
