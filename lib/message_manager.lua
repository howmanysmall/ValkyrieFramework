local module      = {};
local mysql       = dofile("lib/mysql.lua");
local encoder     = dofile("lib/encode.lua");
local app_helpers = require"lapis.application";
local socket      = require"socket"; -- For time

local yield_error = app_helpers.yield_error;

function module.addMessage(user, message, gid)
  local time    = math.floor(socket.gettime());
  local result  = mysql.query(mysql.insert_base, "messages", ("sent=%d, user='%s', message='%s', gid='%s'"):format(time, mysql.safe(user, message, gid)));

  return encoder.encode({success = true, error = ""});
end

function module.checkMessages(since, fresh, gidfilter)
  if fresh then
    return encoder.encode({success = true, error = "", result = math.floor(socket.gettime())});
  end

  local result  = mysql.query(mysql.select_base, "message, sent, user", "messages", ("sent > %d AND gid='%s'"):format(since, gidfilter));
  local ret     = {math.floor(socket.gettime())};
  local row     = result:fetch({}, "a");
  while row do
    table.insert(ret, {tonumber(row.user), row.message, tonumber(row.sent), row.gid});
    row         = result:fetch({}, "a");
  end

  return encoder.encode({success = true, error = "", result = ret});
end

return module;
