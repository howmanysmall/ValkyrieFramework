local module      = {};
local lib         = dofile("lib/check_cokey.lua");
local app_helpers = require"lapis.application";

local yield_error = app_helpers.yield_error;

function module.check(request)
  local par   = request.params;
  local gid   = par.gid;
  local cokey = par.cokey;
  local pid   = par.pid;

  if not pid or not gid or not cokey then
    yield_error("PID, GID or CoKey not set!");
  end

  return lib.check(gid, cokey, pid);
end

return module;
