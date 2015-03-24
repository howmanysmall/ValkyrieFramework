local module      = {};
local mysql       = library("mysql");
local encoder     = library("encode");
local app_helpers = require"lapis.application";

local yield_error = app_helpers.yield_error;

function module.check(gid, cokey, uid)
  local game_id_result  = mysql.query(mysql.select_base, "id", "game_ids", ("gid='%s' AND cokey='%s'"):format(mysql.safe(gid, cokey)));
  if game_id_result:numrows() == 0 then
    yield_error("Invalid UID-GID-CoKey combination!");
  end

  local user_id_result = mysql.query(mysql.select_base, "id", ("`trusted_users_%s`"):format(mysql.safe(gid)), ("uid='%d' AND connection_key='%s'"):format(mysql.safe(uid, cokey)));
  if user_id_result:numrows() == 0 then
    yield_error("Invalid UID-CoKey-GID combination!");
  end

  return encoder.encode({success = true, error = ""});
end

function module.check_nouid(gid, cokey)
  local game_id_result  = mysql.query(mysql.select_base, "id", "game_ids", ("gid='%s' AND cokey='%s'"):format(mysql.safe(gid, cokey)));
  if game_id_result:numrows() == 0 then
    yield_error("Invalid GID-CoKey pair!");
  end

  return "success=true;error=\"\"";
end

return module;
