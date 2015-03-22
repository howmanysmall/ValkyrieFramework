local module                = {};
local mysql                 = dofile("lib/mysql.lua");
local encoder               = dofile("lib/encode.lua");
local parser                = dofile("lib/parse.lua");
local friends               = dofile("lib/friends.lua");
local app_helpers           = require"lapis.application";

local yield_error           = app_helpers.yield_error;

function module.getUserinfo(id)
  local ret                 = {};
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

  return encoder.encode({success = true; error = ""; result = ret});
end

return module;
