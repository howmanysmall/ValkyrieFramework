local lapis       = require("lapis");
local app         = lapis.Application();

require"libraries";
local intmodules  = dofile("interface/modules.lua");
local permstest   = library("permissions");
local parser      = library("parse");
local creator     = library("create_mainmodule");
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

app:match("/gskw/g_all/ible",
    function(self)
      return "<h1 style='color: red'>APRIL FOOLS!</h1>";
    end
);

app:match("/:module/:funct/:gid/:cokey", capture_errors({
  on_error = err_func;
  function(self)
    local result       = nil;
    ngx.req.read_body();
    --io.write(("\27[34;1m%s.%s \27[36m%s\27[0m - %s:%s\n"):format(self.params.module, self.params.funct, ngx.req.get_body_data(), self.params.gid, self.params.cokey));
    local success, message = pcall(function() result = intmodules[self.params.module][self.params.funct](self, parser.parse(ngx.req.get_body_data())); end);
    if not success then
      yield_error(message);
    end
    return  {render = "empty"; layout = false; content_type = "text/valkyrie-return"; result};
  end
}));

app:match("/:module/:funct/:gid/:cokey/:valkargs", capture_errors({
  on_error = err_func;
  function(self)
    local result       = nil;
    local success, message = pcall(function() result = intmodules[self.params.module][self.params.funct](self, parser.parse(self.params.valkargs)); end);
    if not success then
      yield_error(message);
    end
    return  {render = "empty"; layout = false; content_type = "text/valkyrie-return"; result};
  end
}));

app:match("/uploadraw", function(self)
    print(self.params.uploaded_file.content);
    creator.uploadRaw(self.params.uploaded_file.content);
end);

return app;
