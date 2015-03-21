--[[local check_cokey = dofile("interface/check_cokey.lua");
local messagemgr  = dofile("interface/message_manager.lua");
local achvmgr     = dofile("interface/achievements.lua");
local config      = require("lapis.config").get();
local loadstring  = dofile("interface/loadstring.lua");

local ret = {
  auth            = check_cokey;
  messages        = messagemgr;
  achievements    = achvmgr;
  loadstring      = loadstring;
};
if config._name == "local_dev" then
  local userinfo  = dofile("interface/userinfo.lua");
  ret["userinfo"] = userinfo;
end

return ret;]]

local module                  = {};
local modules                 = dofile("interface/modulespec.lua");
local parser                  = dofile("lib/parse.lua");

module                        = setmetatable(module, {
  __index                     = function(self, module)
    local moduleMeta  = modules[module];
    if moduleMeta == nil then
      error("Invalid module name!");
    end

    local lib                 = dofile(("lib/%s.lua"):format(moduleMeta.libName));

    return setmetatable({}, {
      __index                 = function(self2, funcName)
        local functionMeta    = moduleMeta.functions[funcName];
        if not functionMeta then
          error("Invalid function name!");
        end
        return function(request)
          ngx.req.read_body();
          local parsedbody    = parser.parse(ngx.req.get_body_data());

          local passArgs      = {};
          local missingArgs   = {};
          local request       = request.params;

          print(parsedbody.gidfilter);

          for i = 1, #functionMeta do
            local metaType    = type(functionMeta[i]);
            local requiredArg = metaType == "string" and functionMeta[i] or functionMeta[i].name;

            if parsedbody[requiredArg] ~= nil then
              table.insert(passArgs, parsedbody[requiredArg]);
            elseif request[requiredArg] ~= nil then
              table.insert(passArgs, request[requiredArg]);
            else
              if metaType == "table" and functionMeta[i].norequire then
                table.insert(passArgs, functionMeta[i].default);
              else
                table.insert(missingArgs, requiredArg);
              end
            end -- if parsedbody
          end -- for

          if #missingArgs ~= 0 then
            error("Missing arguments: " .. table.concat(missingArgs, ", "));
          end

          return lib[funcName](unpack(passArgs));
        end; -- return
      end; -- __index
    }); -- setmetatable
  end; -- __index
}); -- setmetatable

return module;
