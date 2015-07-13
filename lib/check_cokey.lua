local module      = {};
local mysql       = require"lapis.db";
local encoder     = library("encode");
local app_helpers = require"lapis.application";

local yield_error = app_helpers.yield_error;

function module.check(gid, cokey, uid)
  local game_id_result  = mysql.select("id FROM game_ids WHERE gid=? AND cokey=?", gid, cokey);
  if #game_id_result == 0 then
    yield_error("Invalid UID-GID-CoKey combination!");
  end

  local user_id_result  = mysql.select("id FROM `trusted_users_?`, uid=? AND connection_key=?", gid, uid, cokey);
  if #user_id_result == 0 then
    yield_error("Invalid UID-CoKey-GID combination!");
  end

  return encoder.encode {success = true, error = ""};
end

function module.check_nouid(gid, cokey)
  local game_id_result  = mysql.select("id FROM game_ids WHERE gid=? AND cokey=?", gid, cokey);
  if #game_id_result == 0 then
    yield_error("Invalid GID-CoKey pair!");
  end

  return "success=true;error=\"\"";
end

return module;
