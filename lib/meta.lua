local module        = {};
local mysql         = dofile("lib/mysql.lua");
local app_helpers   = require"lapis.application";

local yield_error   = app_helpers.yield_error;

function module.getMeta(key, gid)
  local result      = mysql.query(mysql.select_base, "value", ("meta_%s"):format(mysql.safe(gid)), ("`key`='%s'"):format(mysql.safe(key)));

  if result:numrows() == 0 then
    error("Invalid meta key!");
  end

  return result:fetch({}, "a").value;
end

function module.setMeta(key, value, gid)
  local uniq_res    = mysql.query(mysql.select_base, "value", ("meta_%s"):format(mysql.safe(gid)), ("`key`='%s'"):format(mysql.safe(key)));

  if uniq_res:numrows() == 0 then
    mysql.query(mysql.insert_base, ("meta_%s"):format(mysql.safe(gid)), ("`key`='%s', value='%s'"):format(mysql.safe(key), mysql.safe(value)));
  else
    mysql.query(mysql.update_base, ("meta_%s"):format(mysql.safe(gid)), ("value='%s'"):format(mysql.safe(value)), ("`key`='%s'"):format(mysql.safe(key)));
  end
end

return module;
