local module        = {};
local lib           = dofile("lib/achievements.lua");
local app_helpers   = require"lapis.application";
local parser        = dofile("lib/parse.lua");
local check         = dofile("lib/check_cokey.lua");

local yield_error   = app_helpers.yield_error;

function module.create(self)
  ngx.req.read_body();
  local parsedbody  = parser.parse(ngx.req.get_body_data());

  local par         = self.params;
  local gid         = par.gid;
  local cokey       = par.cokey;

  if not gid or not cokey then
    yield_error("GID or CoKey not set!");
  end

  local id          = parsedbody.id;
  local desc        = parsedbody.description;
  local name        = parsedbody.name;
  local reward      = parsedbody.reward;

  if not id or not desc or not name or not reward then
    yield_error("ID, description, name or reward not set!");
  end

  check.check_nopid(gid, cokey);

  return lib.create(gid, id, desc, name, reward);
end

function module.award(self)
  ngx.req.read_body();
  local parsedbody  = parser.parse(ngx.req.get_body_data());

  local par         = self.params;
  local gid         = par.gid;
  local cokey       = par.cokey;

  if not gid or not cokey then
    yield_error("GID or CoKey not set!");
  end

  local playerid    = parsedbody.playerid;
  local achvid      = parsedbody.id;

  if not playerid or not achvid then
    yield_error("Player ID or achievement ID not set!");
  end

  check.check_nopid(gid, cokey);
  return lib.award(gid, playerid, achvid)
end

return module;
