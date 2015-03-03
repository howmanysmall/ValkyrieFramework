local module      = {};
local lib         = dofile("lib/message_manager.lua");
local app_helpers = require"lapis.application";
local parser      = dofile("lib/parse.lua");
local check       = dofile("lib/check_cokey.lua");

local yield_error = app_helpers.yield_error;

function module.addMessage(self)
  ngx.req.read_body();
  local parsedbody  = parser.parse(ngx.req.get_body_data());

  local par   = self.params;
  local gid   = par.gid;
  local cokey = par.cokey;

  if not gid or not cokey then
    yield_error("GID or CoKey not set!");
  end

  local user    = parsedbody.user;
  local message = parsedbody.message;

  if not user or not message then
    yield_error("User or message not set!");
  end

  check.check_nopid(gid, cokey); -- Will yield an error if those don't match, thus stopping the program

  return lib.addMessage(user, message);
end

function module.checkMessages(self)
  ngx.req.read_body();
  local parsedbody  = parser.parse(ngx.req.get_body_data());

  local par   = self.params;
  local gid   = par.gid;
  local cokey = par.cokey;

  if not gid or not cokey then
    yield_error("GID or CoKey not set!");
  end

  local since = parsedbody.since;
  local fresh = parsedbody.fresh;

  if not since then
    yield_error("Since not set!");
  end

  check.check_nopid(gid, cokey);

  return lib.checkMessages(since, fresh);
end

return module;
