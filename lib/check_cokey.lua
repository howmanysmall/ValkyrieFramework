local module      = {};
local mysql       = dofile("lib/mysql.lua");
local encoder     = dofile("lib/encode.lua");
local app_helpers = require"lapis.application";

local yield_error = app_helpers.yield_error;

function module.check(gid, cokey, pid)
  local game_id_result  = mysql.query(mysql.select_base, "id", "game_ids", ("gid='%s' AND cokey='%s'"):format(mysql.safe(gid, cokey)));
  if game_id_result:numrows() == 0 then
    yield_error("Invalid GID-CoKey pair!");
  end

  local place_id_result = mysql.query(mysql.select_base, "id", ("trusted_places_%s"):format(mysql.safe(gid)), ("pid='%d' AND connection_key='%s'"):format(mysql.safe(pid, cokey)));
  if place_id_result:numrows() == 0 then
    yield_error("Invalid PID-CoKey-GID combination!");
  end

  return encoder.encode({success = true, error = ""});
end

function module.check_nopid(gid, cokey)
  local game_id_result  = mysql.query(mysql.select_base, "id", "game_ids", ("gid='%s' AND cokey='%s'"):format(mysql.safe(gid, cokey)));
  if game_id_result:numrows() == 0 then
    yield_error("Invalid GID-CoKey pair!");
  end

  return encoder.encode({success = true, error = ""});
end

return module;
