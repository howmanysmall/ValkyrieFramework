local config = require("lapis.config");

config("collb_dev", {
  port      = 8080,
  host      = "127.0.0.1",
  user      = "valkyrie",
  password  = "m224crb",
  database  = "valkyrie_engine",
  robloxun  = "ValkyrieBot",
  robloxpw  = "m224crb",
  logging   = {
    queries = false,
    requests= false
  },
  mysql     = {
    host    = "127.0.0.1",
    user    = "valkyrie",
    password= "m224crb",
    database= "valkyrie_engine" 
  }
});
config("local_dev", {
  port      = 1274,
  host      = "127.0.0.1",
  user      = "valkyrie",
  password  = "m224crb",
  database  = "valkyrie_engine",
  robloxun  = "ValkyrieBot",
  robloxpw  = "m224crb"
});
