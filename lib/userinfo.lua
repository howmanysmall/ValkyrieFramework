local module                = {};
local mysql                 = library("mysql");
local encoder               = library("encode");
local parser                = library("parse");
local app_helpers           = require"lapis.application";
local inspect               = require"inspect";
local http                  = require("socket.http");
local socket                = require("socket");
local json                  = require("cjson");
local meta                  = library("meta");
local friends               = {};

local yield_error           = app_helpers.yield_error;

function friends.getFriends(id)
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

local function getGeneralInfo(id)
  local ret                 = {};
  local ingamep_ret         = mysql.query(mysql.select_base, "gid, player", "player_ingame", ("player=%d"):format(id));
  local otherinfo           = http.request(("http://api.roblox.com/users/%d"):format(id));
  otherinfo                 = json.decode(otherinfo);
  local row                 = ingamep_ret:fetch({}, "a");
  local gamename            = nil;

  if row then
    gamename                = meta.getMeta("name", row.gid);
  end

  return {otherinfo.Id; otherinfo.Username; row and true or false; row and row.gid or nil; gamename};
end

local function fixDate(date, diff)
  date                      = date:gsub("(%d-)a", function(a) return " " .. tostring(tonumber(a) - 1970) .. "a"; end);
  date                      = date:gsub("(%d-)([md]) ", function(a, b) return tostring(tonumber(a) - 1) .. b .. " "; end);
  date                      = date:gsub("(%d-)h", function(a) return tostring(tonumber(a) - 2) .. "h"; end);

  date                      = date:gsub(" 0%l*", "");
  if date:sub(1, 1) == " " then
    return date:sub(2);
  end

  if date                   == "" then
    if diff then
      return "N/A";
    end
    return "just now";
  end

  return date;
end

local function getDBGeneralInfo(id)
  local ret                 = {{}, {}};
  local userinfo_ret        = mysql.query(mysql.select_base, "*", "player_info", ("player=%d"):format(id));

  local row                 = userinfo_ret:fetch({}, "a");
  if row then
    ret[2]                  = {row.time_ingame, row.joined, row.last_online};
  else
    ret[2]                  = {0, 0, 0}; 
  end

  table.insert(ret[1], fixDate(os.date("%Ya %mm %dd %Hh %Mmin", row.time_ingame), true));
  table.insert(ret[1], fixDate(os.date("%Ya %mm %dd", math.floor(socket.gettime()) - row.joined)));
  table.insert(ret[1], fixDate(os.date("%Ya %mm %dd %Hh %Mmin", math.floor(socket.gettime()) - row.last_online)));

  return ret;
end

function module.tryCreateUser(id)
  local exists_ret          = mysql.query(mysql.select_base, "id", "player_info", ("player=%d"):format(id));
  if exists_ret:numrows() == 0 then
    mysql.query(mysql.insert_base, "player_info", ("player=%d, time_ingame=0, joined=%d, last_online=0"):format(id, math.floor(socket.gettime())));
  end

  return encoder.encode({success = true; error = ""});
end

function module.getUserinfo(id)
  local ret                 = {};

  table.insert(ret, math.floor(socket.gettime()));

  table.insert(ret, getGeneralInfo(id));
  table.insert(ret, getDBGeneralInfo(id));

  local exists_result       = mysql.query(mysql.select_base, "table_name", "information_schema.tables", ("table_name='player_achv_%d'"):format(id));
  if exists_result:numrows() ~= 0 then
    local achvs_result      = mysql.query(mysql.select_base, "*", ("player_achv_%d"):format(id), "1=1");
    local row               = achvs_result:fetch({}, "a");
    local checkedGames      = {};
    local insertret         = {};
    while row do
      if checkedGames[row.gid] == nil then
        local game_achv_res   = mysql.query(mysql.select_base, "*", ("achievements_%s"):format(row.gid), "1=1");
        local insertretchk    = {};
        local row2            = game_achv_res:fetch({}, "a");
        while row2 do
          insertretchk[row2.achv_id] = row2;
          row2                = game_achv_res:fetch({}, "a");
        end
        checkedGames[row.gid] = insertretchk;
      end
      local insinsret         = {};
      table.insert(insinsret, row.achvid);
      table.insert(insinsret, row.gid);
      table.insert(insinsret, checkedGames[row.gid][row.achvid].name);
      table.insert(insinsret, checkedGames[row.gid][row.achvid].description);
      table.insert(insinsret, tonumber(checkedGames[row.gid][row.achvid].reward));
      table.insert(insinsret, tonumber(checkedGames[row.gid][row.achvid].icon));
      insertret[row.achvid]   = insinsret;
      row                     = achvs_result:fetch({}, "a");
    end
    table.insert(ret, insertret);

    local totalreward         = 0;
    for i, v in next, insertret do
      totalreward             = totalreward + v[5];
    end
    table.insert(ret, totalreward);
  else
    table.insert(ret, {}); -- achievements
    table.insert(ret, 0);  -- total reward
  end

  table.insert(ret, parser.parse(friends.getFriends(id)).result);

  print(inspect(parser.parse(encoder.encode(ret))));

  return encoder.encode({success = true; error = ""; result = ret});
end

return module;
