local module              = {};
local mysql               = dofile("lib/mysql.lua");
local encoder             = dofile("lib/encode.lua");
local metamanager         = dofile("lib/meta.lua");
local app_helpers         = require"lapis.application";

local yield_error         = app_helpers.yield_error;

function module.create(gid, id, desc, name, reward)
  local uniq_result       = mysql.query(mysql.select_base, "id", mysql.safe(("`achievements_%s`"):format(mysql.safe(gid))), ("achv_id='%s'"):format(mysql.safe(id)));

  if uniq_result:numrows() ~= 0 then
    yield_error("An achievement with that ID already exists!");
  end

  local usedreward        = metamanager.getMeta("usedreward", gid);
  local maxreward         = 1000 - usedreward;

  if maxreward < reward then
    yield_error("The reward exceeds the maximum available reward (" .. maxreward .. ")!");
  end
  metamanager.setMeta("usedreward", usedreward + reward, gid);

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

function module.list(gid, othgid, filter)
  local exists_result   = mysql.query(mysql.select_base, "table_name", "information_schema.tables", ("table_name='achievements_%s'"):format(mysql.safe(othgid)));
  if exists_result:numrows() == 0 then
    yield_error("That game doesn't exist");
  end

  local query = mysql.select_base:format("*", ("achievements_%s"):format(mysql.safe(othgid)), "1=1 "); -- hax
  if filter[1] ~= "" and filter[1] and filter[2] then
    if filter[1] == ">" then
      query = query .. ("AND %s>=%d "):format("reward", filter[2]);
    else
      query = query .. ("AND %s<=%d "):format("reward", filter[2]);
    end
  end
  if filter[3] ~= "" and filter[3] then
    query = query .. ("AND %s LIKE '%%%s%%' "):format("achv_id", mysql.safe(filter[3]));
  end
  if filter[4] ~= "" and filter[4] then
    query = query .. ("AND %s LIKE '%%%s%%' "):format("name", mysql.safe(filter[4]));
  end
  if filter[5] ~= "" and filter[5] then
    query = query .. ("AND %s LIKE '%%%s%%' "):format("name", mysql.safe(filter[5]));
  end

  local result  = mysql.literalQuery(query);
  local ret     = {};
  local row     = result:fetch({}, "a");
  while row do
    table.insert(ret, {tonumber(row.reward), row.achv_id, row.name, row.description});
    row         = result:fetch({}, "a");
  end

  return encoder.encode({
    success = true,
    error   = "",
    result  = ret
  });
end

return module;
