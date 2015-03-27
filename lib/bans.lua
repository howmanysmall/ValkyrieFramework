local module      = {};
local mysql       = library("mysql");
local encoder     = library("encode");

function module.createBan(gid, player, reason)
  local exists_result = mysql.query(mysql.select_base, "id", "bans", ("player=%d"):format(player));
  if exists_result:numrows() ~= 0 then
    yield_error("That user is already banned!");
  end

  mysql.query(mysql.insert_base, "bans", ("player=%d, from_gid='%s', reason='%s'"):format(player, mysql.safe(gid, reason)));

  return encoder.encode({success = true; error = ""});
end

function module.isBanned(player)
  local exists_result = mysql.query(mysql.select_base, "*", "bans", ("player=%d"):format(player));
  if exists_result:numrows() ~= 0 then
    local data        = exists_result:fetch({}, "a");
    return encoder.encode({success = true; error = ""; result = {true, data.reason, data.from_gid}});
  end
  return encoder.encode({success = true; error = ""; result = {false}});
end

return module;
