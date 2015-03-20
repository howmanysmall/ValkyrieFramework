local check_cokey = dofile("interface/check_cokey.lua");
local messagemgr  = dofile("interface/message_manager.lua");
local achvmgr     = dofile("interface/achievements.lua");
local config      = require("lapis.config").get();
local loadstring  = dofile("interface/loadstring.lua");

local ret = {
  auth          = check_cokey;
  messages      = messagemgr;
  achievements  = achvmgr;
  loadstring    = loadstring;
};

return ret;
