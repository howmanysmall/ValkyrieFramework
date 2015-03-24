local module        = {};
local permsfile     = io.open("permissions.perms", "r");
local permissions   = {};
local ins           = require("inspect");
local possperms     = {
  modules           = {
    "require";
    "function";
  };
  achievements      = {
    "award";
    "create";
    "list";
  };
  auth              = {
    "check";
  };
  loadstring        = {
    "load";
    "lockAsset";
  };
  messages          = {
    "addMessage";
    "checkMessage";
  };
  playerinfo        = {
    "getUserinfo";
  };
  friends           = {
    "getFriends";
    "setOnlineGame";
    "goOffline";
  };
  datastore         = {
    "saveData";
    "loadData";
  };
  ["*"]             = {
    "modules.*";
    "achievements.*";
    "auth.*";
    "loadstring.*";
    "messages.*";
    "playerinfo.*";
    "friends.*";
    "datastore.*";
  };
};

local function arg(num, ...)
  return ({...})[num];
end

local currentperms  = {allow = {}, deny = {}};

-- Do not try to understand this function. It works, k?
local function insertRecursively(table, path, value, prevvalue)
  print(path, prevvalue);
  if path:sub(1, 1) == "*" then
    if prevvalue then
      for index, name in next, possperms[prevvalue] do
        if name:find("*") then
          insertRecursively(table, name, value, nil);
        elseif not path:find("%.") then
          table[prevvalue][name] = value;
        else
          if table[name:sub(1, arg(1, name:find(".")) - 1)] == nil then
            table[name:sub(1, arg(1, name:find(".")) - 1)]  = {};
          end
          insertRecursively(table[name:sub(1, arg(1, name:find(".")) - 1)], path:sub(arg(1, path:find("%.")) + 1), value, name);
        end
      end
    else
      insertRecursively(table, path:sub(arg(1, path:find("%.")) + 1), value, "*");
    end
  end
  if not path:find("%.") and path:sub(1, 1) ~= "*" then
    table[prevvalue][path]     = value;
  elseif path:sub(1, 1) ~= "*" then
    if table[path:sub(1, arg(1, path:find("%.")) - 1)] == nil then
      table[path:sub(1, arg(1, path:find("%.")) - 1)]  = {};
    end
    insertRecursively(table, path:sub(arg(1, path:find("%.")) + 1), value, path:sub(1, arg(1, path:find("%.")) - 1));
  end
end

local function getRecursively(table, path)
  print(path);
  if not path:find("%.") then
    return table[path];
  else
    if table[path:sub(1, arg(1, path:find("%.")) - 1)] == nil then
      return nil;
    end
    return getRecursively(table[path:sub(1, arg(1, path:find("%.") - 1))], path:sub(arg(1, path:find("%.") + 1)));
  end
end

function module.parsePermissions()
  local line          = permsfile:read("*line");
  local currentgid    = "";
  currentperms        = {allow = {}, deny = {}}
  while line do
    if line:sub(1, 1) == ":" then
      if currentgid ~= "" then
        permissions[currentgid] = currentperms;
      end
      currentgid    = line:sub(2);
    elseif line:sub(1, 1) == "+" then
      insertRecursively(currentperms.allow, line:sub(2), true);
    elseif line:sub(1, 1) == "-" then
      insertRecursively(currentperms.deny, line:sub(2), true);
    end
    line            = permsfile:read("*line");
  end
end

function module.getPermission(gid, key)
  local allowed     = getRecursively(permissions[gid].allow, key);
  local denied      = getRecursively(permissions[gid].deny, key);

  if allowed then
    if denied then
      return false;
    else
      return true;
    end
  end
  return false;
end

return module;
