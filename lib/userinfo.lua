local module              = {};
local mysql               = dofile("lib/mysql.lua");
local encoder             = dofile("lib/encode.lua");
local app_helpers         = require"lapis.application";

local yield_error         = app_helpers.yield_error;

function module.getUserinfo(id)
  local ret               = {achievements = {}, totalreward = 0, friends = {}};
  local exists_result     = mysql.query(mysql.select_base, "table_name", "information_schema.tables", ("table_name='player_achv_%d'"):format(id));
  if exists_result:numrows() == 0 then
    yield_error("That user has not been awarded any achievements yet.");
  else
    local achvs_result    = mysql.query(mysql.select_base, "*", ("player_achv_%d"):format(id), "1=1");
    local row             = achvs_result:fetch({}, "a");
    local checkedGames    = {};
    while row do
      local insertret     = {};
      if checkedGames[row.gid] == nil then
        local game_achv_res = mysql.query(mysql.select_base, "*", ("achievements_%s"):format(row.gid));
        local insertretchk  = {};
        local row2          = game_achv_res:fetch({}, "a");
        while row2 do
          insertretchk[row2.achv_id] = row2;
          row2              = game_achv_res:fetch({}, "a");
        end
        checkedGames[row.gid] = insertretchk;
      end
      insertret[row.achvid] = checkedGames[row.gid][row.achvid];
      row                 = achvs_result:fetch({}, "a");
    end
    ret.achievements  = insertret;

    for i, v in pairs(insertret) do
      ret.totalreward = ret.totalreward + v.reward;
    end
  end

  -- TODO: Friends
end

return module;
