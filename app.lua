local lapis       = require("lapis");
local app         = lapis.Application();
-- Reminded: luasocket for time

local intmodules  = dofile("interface/modules.lua");
local permstest   = dofile("lib/permissions.lua");
local app_helpers = require"lapis.application";

local capture_errors  = app_helpers.capture_errors;
local yield_error     = app_helpers.yield_error;

app:enable"etlua"
app:get("/", function()
  return "Welcome to Lapis " .. require("lapis.version");
end);

function err_func(self)
  return    {render = "empty"; layout = false; content_type = "text/valkyrie-return"; ("success=false;error=\"%s\""):format(self.errors[1])};
end

app:match("/:module/:funct/:gid/:cokey", capture_errors({
  on_error = err_func;
  function(self)
    local result       = nil;
    local success, message = pcall(function() result = intmodules[self.params.module][self.params.funct](self); end);
    if not success then
      yield_error(message);
    end
    return  {render = "empty"; layout = false; content_type = "text/valkyrie-return"; result};
  end
}));

app:match("/testparse/:stuff", function(self)
  permstest.parsePermissions();
end)



return app;
