_G.ValkyrieC:LoadLibrary "Design";
local module	= {};
local maxColor  = Color3.Green[500];
local midColor	= Color3.Orange[500];
local minColor	= Color3.Red[500];
local cache		= require(script.Caching);

function module.toHSL(c3)
	local r, g, b 	= c3.r, c3.g, c3.b;
	local ma, mi 	= math.max(r,g,b), math.min(r,g,b);
	local h, s, l	= 0, 0, (ma + mi) * .5;
	
	if ma == mi then
		h			= 0;
		s 			= 0;
	else
		local d		= ma - mi;
		s			= l > .5 and d / (2 - ma - mi) or d / (ma + mi);
		if ma == r then
			h 		= (g - b) / d + (g < b and 6 or 0);
		elseif ma == g then
			h 		= (b - r) / d + 2;
		else
			h 		= (r - g) / d + 4;
		end
		h 			= h / 6;
	end
	
	return {h = h, s = s, l = l};
end

function module.hslSub(a, b)
	return {h = a.h - b.h, s = a.s - b.s, l = a.l - b.l};
end

function module.easing(t, b, c, d) -- In this case we're doing inQuad
  t = t / d
  return c * math.pow(t, 2) + b
end
function module.C3easing(t, b, e, d)
	local _b, _e= b, e;
 	local b 	= module.toHSL(b);
 	local e 	= module.toHSL(e);
	local c		= module.hslSub(e, b);

	return HSL.new(module.easing(t, b.h, c.h, d), module.easing(t, b.s, c.s, d), module.easing(t, b.l, c.l, d));
end
function module.realC3easing(t, b, c, d)
	return Color3.new(module.easing(t, b.r, c.r, d), module.easing(t, b.g, c.g, d), module.easing(t, b.b, c.b, d));
end
function module.UDim2easing(t, b, c, d)
  return UDim2.new(module.easing(t, b.X.Scale, c.X.Scale, d), module.easing(t, b.X.Offset, c.X.Offset, d), module.easing(t, b.Y.Scale, c.Y.Scale, d), module.easing(t, b.Y.Offset, c.Y.Offset, d));
end

function module.actualC3Sub(a, b)
	return Color3.new(a.r - b.r, a.g - b.g, a.b - b.b);
end

function module.computeNewVals(oldHealth, newHealth, maxHealth, obj)
    local oldPercent    = oldHealth / maxHealth;
    local newPercent    = newHealth / maxHealth;
    local changePercent = newPercent - oldPercent;
    local passBegin     = newPercent < .5 and minColor or midColor;
    local passEnd       = newPercent < .5 and midColor or maxColor;
    local passChange    = module.actualC3Sub(passEnd, passBegin);
    local newColor      = module.realC3easing(newPercent < .5 and newHealth or newHealth - maxHealth * .5, passBegin, passChange, maxHealth * .5, true);
    local oldColor      = cache.getCache("oldColor") or cache.setCache("oldColor", obj.BackgroundColor3);
    local changeColor   = module.actualC3Sub(newColor, oldColor);
    
    return oldPercent, newPercent, changePercent, passBegin, passEnd, passChange, newColor, oldColor, changeColor;
end

function module.clearCache()
	cache.clearCache();
end

return module;