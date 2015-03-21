local module      = {};
local lib         = dofile("lib/userinfo.lua");
local app_helpers = require"lapis.application";
local parser      = dofile("lib/parse.lua");
local check       = dofile("lib/check_cokey.lua");

local yield_error = app_helpers.yield_error;

function module.getUserinfo(self)
  ngx.req.read_body();
  local parsedbody  = parser.parse(ngx.req.get_body_data());

  local par         = self.params;
  local gid         = par.gid;
  local cokey       = par.cokey;

  if not gid or not cokey then
    yield_error("GID or CoKey not set!");
  end

  local id          = parsedbody.id;

  if not id then
    yield_error("ID not set!");
  end

  check.check_nouid(gid, cokey);

  return lib.getUserinfo(id);
end

return module;
