local lapis = require("lapis")
local app   = lapis.Application()
local sock  = require("socket")

app:enable"etlua"

app:match("/ide/welcome", function()

  return "Lovely day outside";
end);

app:match("/*", function(self)
  local m = sock.tcp()
  m:connect("209.15.14.21", 80);
  ngx.req.read_body();
  print(ngx.req.raw_header():sub(1, select(2, ngx.req.raw_header():find("\n\n"))) .. "\nConnection: close\nAccept-Encoding: none\n" .. (ngx.req.get_method() == "POST" and "\n" .. ngx.req.get_body_data() or "\n"));
  m:send(ngx.req.raw_header():sub(1, select(2, ngx.req.raw_header():find("\n\n"))) .. "\nConnection: close\nAccept-Encoding: none\n" .. (ngx.req.get_method() == "POST" and "\n" .. ngx.req.get_body_data() or "\n"));
  local recv = m:receive("*a");
  print("\n\n\n", recv);
  return {render = "empty", layout = false, recv:sub(select(1, recv:find("\r\n\r\n")))};
end)

return app
