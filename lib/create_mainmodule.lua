local module    = {};
if not jit then
  error("LuaJIT not installed!");
end
local lz4       = dofile("lib/lz4.lua");
local bit32     = require"bit32";
local config    = require("lapis.config").get();

function num2hex(IN)
    return string.format("%x", IN);
end

function str2hex(str)
    local hex = ''
    while #str > 0 do
        local hb = num2hex(string.byte(str, 1, 1))
        if #hb < 2 then hb = '0' .. hb end
        hex = hex .. hb
        str = string.sub(str, 2)
    end
    return hex
end

local function toLittleEndian(int)
  return string.char(bit32.band(int, 0xFF))
      .. string.char(bit32.rshift(bit32.band(int, 0xFF00), 8))
      .. string.char(bit32.rshift(bit32.band(int, 0xFF0000), 16))
      .. string.char(bit32.rshift(bit32.band(int, 0xFF000000), 24));
end

function module.encodeProperty(propName, propType, propData)
  local ret = "\0\0\0\0"; -- Always zeroes since it's the only instance
  ret = ret .. toLittleEndian(propName:len());
  ret = ret .. propName;
  ret = ret .. string.char(propType);
  ret = ret .. propData;

  local origLen = ret:len();
  ret, err = lz4.compress(ret);
  if err then
    error(err);
  end

  ret = ret:sub(9);
  local compLen = ret:len();
  ret = "PROP" .. toLittleEndian(compLen) .. toLittleEndian(origLen) .. "\0\0\0\0" .. ret;

  return ret;
end

function module.encodeInstance(instName)
  local ret = "\0\0\0\0";
  ret = ret .. toLittleEndian(instName:len());
  ret = ret .. instName;
  ret = ret .. "\0"; -- No additional data
  ret = ret .. "\1\0\0\0"; -- One instance
  ret = ret .. "\0\0\0\0"; -- Always zeroes since it's the only instance
  local origLen = ret:len();
  ret, err = lz4.compress(ret);
  if err then
    error(err);
  end

  ret = ret:sub(9);
  local compLen = ret:len();
  ret = "INST" .. toLittleEndian(compLen) .. toLittleEndian(origLen) .. "\0\0\0\0" .. ret;

  return ret;
end

function module.encodeParent(num, refarr, pararr)
  local ret = "\0";
  ret = ret .. toLittleEndian(num);
  ret = ret .. refarr;
  ret = ret .. pararr;

  local origLen = ret:len();
  ret, err = lz4.compress(ret);
  if err then
    error(err);
  end

  ret = ret:sub(9);
  local compLen = ret:len();
  ret = "PRNT" .. toLittleEndian(compLen) .. toLittleEndian(origLen) .. "\0\0\0\0" .. ret;

  return ret;
end

function module.createModel(source)
  local modelData = "<roblox!\137\255\13\10\26\10\0\0"; -- Header
  modelData = modelData .. "\1\0\0\0\1\0\0\0"; -- One instance total, one unique
  modelData = modelData .. "\0\0\0\0\0\0\0\0"; -- Padding
  modelData = modelData .. module.encodeInstance("ModuleScript");
  modelData = modelData .. module.encodeProperty("LinkedSource", 1, "\0\0\0\0");
  modelData = modelData .. module.encodeProperty("Name", 1, "\n\0\0\0MainModule"); -- \n\0\0\0 == 10 in LE == ("MainModule"):len()
  modelData = modelData .. module.encodeProperty("Source", 1, toLittleEndian(source:len()) .. source);
  modelData = modelData .. module.encodeParent(1, "\0\0\0\0", "\0\0\0\1");
  modelData = modelData .. "END\0\0\0\0\0\9\0\0\0\0\0\0\0</roblox>";

  return modelData;
end






function module.uploadModel(data, id)
  local username = config.user .. "Bot";
  local password = config.user .. "b";

end

return module;
