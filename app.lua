local lapis       = require("lapis");
local app         = lapis.Application();
local json        = require"cjson";
-- Reminded: luasocket for time

local intmodules  = dofile("interface/modules.lua");
local parser      = dofile("lib/parse.lua");
local encoder     = dofile("lib/encode.lua");
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
    if not intmodules[self.params.module] or not intmodules[self.params.module][self.params.funct] then
      yield_error("Invalid module or function!");
    end
    return  {render = "empty"; layout = false; content_type = "text/valkyrie-return"; intmodules[self.params.module][self.params.funct](self)};
  end
}));

return app;
