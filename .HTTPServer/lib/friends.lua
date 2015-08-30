local module          = {};
local mysql           = library("mysql");
local encoder         = library("encode");
local app_helpers     = require"lapis.application";
local http            = require("socket.http");
local json            = require("cjson");
local userinfo        = library("userinfo");

local yield_error     = app_helpers.yield_error;

function module.getFriends(id)
  local ret           = {};
  local ingamep_ret   = mysql.query(mysql.select_base, "gid, player", "player_ingame", "1=1");
  local friends       = http.request(("http://api.roblox.com/users/%d/friends"):format(id));
  friends             = json.decode(friends);
  local ingameplayers = {};
  local row           = ingamep_ret:fetch({}, "a");
  while row do
    ingameplayers[tonumber(row.player)] = row.gid;
    row               = ingamep_ret:fetch({}, "a");
  end

  for index, value in next, friends do
    local toinsert    = {value.Id; value.Username; ingameplayers[value.Id] and true or false};
    table.insert(toinsert, ingameplayers[value.Id]);
    table.insert(ret, toinsert);
  end

  return encoder.encode({success = true, error = "", result = ret});
end

function module.setOnlineGame(id, gid)
  local exists_ret    = mysql.query(mysql.select_base, "gid", "player_ingame", ("player=%d"):format(id));
  if exists_ret:numrows() == 0 then
    mysql.query(mysql.insert_base, "player_ingame", ("player=%d, gid='%s'"):format(id, mysql.safe(gid)));
  else
    mysql.query(mysql.update_base, "player_ingame", ("player=%d, gid='%s'"):format(id, mysql.safe(gid)), ("player=%d"):format(id));
  end

  userinfo.tryCreateUser(id);

  mysql.query(mysql.update_base, "player_info", "last_online=0", ("player=%d"):format(id));

  return encoder.encode({success = true, error = ""});
end

function module.goOffline(id, time_ingame)
  mysql.query(mysql.delete_base, "player_ingame", ("player=%d"):format(id));
  mysql.query(mysql.update_base, "player_info", ("last_online=%d, time_ingame=time_ingame+%d"):format(math.floor(socket.gettime()), time_ingame), ("player=%d"):format(id));

  return encoder.encode({success = true, error = ""})
end

return module;
