local module      = {};
local mysql       = dofile("lib/mysql.lua");
local encoder     = dofile("lib/encode.lua");
local app_helpers = require"lapis.application";
local socket      = require"socket"; -- For time

local yield_error = app_helpers.yield_error;

function module.addMessage(user, message)
  local time    = math.floor(socket.gettime());
  local result  = mysql.query(mysql.insert_base, "messages", ("sent=%d, user='%s', message='%s'"):format(time, mysql.safe(user, message)));

  return encoder.encode({success = true, error = ""});
end

function module.checkMessages(since, fresh)
  if fresh then
    return encoder.encode({success = true, error = "", result = math.floor(socket.gettime())});
  end

  local result  = mysql.query(mysql.select_base, "message, sent, user", "messages", ("sent > %d"):format(since));
  local ret     = {math.floor(socket.gettime())};
  local row     = result:fetch({}, "a");
  while row do
    table.insert(ret, {tonumber(row.user), row.message, tonumber(row.sent)});
    row         = result:fetch({}, "a");
  end

  return encoder.encode({success = true, error = "", result = ret});
end

return module;
