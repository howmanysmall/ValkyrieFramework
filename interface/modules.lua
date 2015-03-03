local check_cokey = dofile("interface/check_cokey.lua");
--local messagemgr  = dofile("interface/message_manager.lua");

return {
  auth      = check_cokey;
  messages  = messagemgr;
};
