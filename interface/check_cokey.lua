local module      = {};
local lib         = dofile("lib/check_cokey.lua");
local app_helpers = require"lapis.application";

local yield_error = app_helpers.yield_error;

function module.check(request)
  local par   = request.params;
  local gid   = par.gid;
  local cokey = par.cokey;
  local uid   = par.uid;

  if not gid or not uid or not cokey then
    yield_error("UID, GID or CoKey not set!");
  end

  return lib.check(gid, cokey, uid);
end

return module;
