local module                  = {};
local modules                 = dofile("interface/modulespec.lua");
local parser                  = dofile("lib/parse.lua");
local auth                    = dofile("lib/check_cokey.lua");
local inspect                 = require("inspect");


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
          --print(inspect(parsedbody));

          local passArgs      = {};
          local missingArgs   = {};
          local request       = request.params;

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

          if not moduleMeta.skipAuth then
            auth.check_nouid(request.gid, request.cokey);
          end

          return lib[funcName](unpack(passArgs));
        end; -- return
      end; -- __index
    }); -- setmetatable
  end; -- __index
}); -- setmetatable

return module;
