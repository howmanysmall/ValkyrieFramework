local module    = {};
local mysql     = dofile("lib/mysql.lua");
local encoder   = dofile("lib/encode.lua");
local app_helpers = require"lapis.application";

local yield_error = app_helpers.yield_error;

function module.create(gid, id, desc, name, level)
  local uniq_result   = mysql.query(mysql.select_base, "id", mysql.safe(("achievements_%s"):format(gid)), ("achv_id='%s'"):format(id));

  if uniq_result:numrows() ~= 0 then
    yield_error("An achievement with that ID already exists");
  end

  local add_result    = mysql.query(mysql.insert_base, mysql.safe(("achievements_%s"):format(gid)), ("achv_id='%s', description='%s', name='%s', level='%d'"):format(mysql.safe(id), mysql.safe(desc), mysql.safe(name), level));

  return encoder.encode({success = true, error = ""});
end

return module;
