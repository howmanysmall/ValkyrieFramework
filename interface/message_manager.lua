local module      = {};
local lib         = dofile("lib/message_manager.lua");
local parser      = dofile("lib/parse.lua");
local app_helpers = require"lapis.application";

local yield_error = app_helpers.yield_error;

return module;
