local module        = {};
local lib           = dofile("lib/create_mainmodule.lua");
local app_helpers   = require"lapis.application";
local parser        = dofile("lib/parse.lua");
local check         = dofile("lib/check_cokey.lua");

local yield_error   = app_helpers.yield_error;

function module.load(self)
  ngx.req.read_body();
  local parsedbody  = parser.parse(ngx.req.get_body_data());

  local par         = self.params;
  local gid         = par.gid;
  local cokey       = par.cokey;

  if not gid or not cokey then
    yield_error("GID or CoKey not set!");
  end

  local source      = parsedbody.source;

  if not source then
    yield_error("Source not set!");
  end

  check.check_nouid(gid, cokey);

  return lib.uploadModel(source, 0);
end

return module;
