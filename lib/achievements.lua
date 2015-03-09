local module              = {};
local mysql               = dofile("lib/mysql.lua");
local encoder             = dofile("lib/encode.lua");
local app_helpers         = require"lapis.application";

local yield_error         = app_helpers.yield_error;

function module.create(gid, id, desc, name, reward)
  local uniq_result       = mysql.query(mysql.select_base, "id", mysql.safe(("achievements_%s"):format(gid)), ("achv_id='%s'"):format(mysql.safe(id)));

  if uniq_result:numrows() ~= 0 then
    yield_error("An achievement with that ID already exists!");
  end

  local add_result        = mysql.query(mysql.insert_base, mysql.safe(("achievements_%s"):format(gid)), ("achv_id='%s', description='%s', name='%s', reward='%d'"):format(mysql.safe(id), mysql.safe(desc), mysql.safe(name), reward));

  return encoder.encode({success = true, error = ""});
end

function module.award(gid, pid, aid)
  local uniq_result       = mysql.query(mysql.select_base, "id", mysql.safe(("achievements_%s"):format(gid)), ("achv_id='%s'"):format(mysql.safe(aid)));
  if uniq_result:numrows() == 0 then
    yield_error("That achievement doesn't exist!");
  end

  local plr_exist_result  = mysql.query(mysql.select_base, "table_name", "information_schema.tables", ("table_name='player_achv_%d'"):format(pid));
  if plr_exist_result:numrows() == 0 then
    print("\27[1;36mA table for " .. pid .. " doesn't exist; creating it!\27[0m");

    mysql.query(mysql.create_base, ("player_achv_%d"):format(pid), "LIKE player_achv_template");
  end

  local aw_uniq_res       = mysql.query(mysql.select_base, "id", ("player_achv_%d"):format(pid), ("achvid='%s'"):format(mysql.safe(aid)));
  if aw_uniq_res:numrows() ~= 0 then
    yield_error("That achievement has already been awarded to the player");
  end

  mysql.query(mysql.insert_base, ("player_achv_%d"):format(pid), ("achvid='%s', gid='%s'"):format(mysql.safe(aid), mysql.safe(gid)));

  return encoder.encode({success = true, error = ""});
end

return module;
