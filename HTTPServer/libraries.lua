local oldfenv       = getfenv(0);
oldfenv.library     = function(name)
  return dofile(("lib/%s.lua"):format(name));
end

setfenv(0, oldfenv);
