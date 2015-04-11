local server        = require("socket");
local socks         = require("socket").tcp();
server              = server.bind("*", 80);
local tmpcnt        = 0;

function readNoClose(sock)
  local stuff       = "";
  local clen        = 0;
  local line        = "";
  repeat
    line, err       = sock:receive("*l");
    if not line then
      error(err);
    end
    stuff           = stuff .. line .. "\n";
    print(line);
    local match     = line:match("Content%-Length: (%d+)");
    if match then
      print("MATCH'd", match);
      clen          = tonumber(match);
    end
  until line        == "";

  if clen > 0 then
    print("clen higher");
    tmpcnt          = tmpcnt + 1;
    local tmpcont   = tmpcnt;
    local tfile     = io.open("tmp/" .. tmpcont .. ".gz", "w");
    io.output(tfile);

    local ret;
    repeat
      io.write(select(1, sock:receive(1)), "");
      ret           = os.execute("gunzip tmp/" .. tmpcont .. ">/dev/null 2>&1");
    until ret       == 0;
  end

  return stuff;
end

local rsock, err    = socks:connect("209.15.14.21", 80);
if not rsock then
  error(err);
end

while 1 do
  local client      = server:accept();
  client:settimeout(10);

  local stuff       = readNoClose(client);
  socks:send(stuff);

  local recvd       = readNoClose(socks);

  if not recvd then
    error(err);
  end

  client:send(recvd);
end
