local UIS = game:GetService("UserInputService");
-- Objective: Grant support to users for dynamic binding of events

local cxitio = {}; -- Manager
local Binds = {}; -- Binds holding

local InputData = {}; -- Data for current input
local SafeSet = {}; -- Internals containing the closure information
local newInput = function()
    local storage = {Down = false;}
    local r = newproxy(true);
    do
        local mt = getmetatable(r)
        mt.__index = storage;
        mt.__newindex = error;
        mt.__tostring = function() return "Valkyrie Input Data" end;
        mt.__metatable = "Locked metatable: Valkyrie";
    end
    return r, function(k,v)
        storage[k] = v;
    end
end

local InputTypes = {}; -- Has to collect all input types -.-
for k,v in next,Enum.KeyCode:GetEnumItems() do
    InputTypes[v.Name] = v.Name;
end
for k,v in next,Enum.UserInputType:GetEnumItems() do
    InputTypes[v.Name] = v.Name;
end

local Aliases = {
    -- Various aliases
    M1 = "MouseButton1";
    Mouse1 = "MouseButton1";
    M2 = "MouseButton2";
    Mouse2 = "MouseButton2";
    Primary = "MouseButton1";
    Secondary = "MouseButton2";
    M3 = "MouseButton3";
    Mouse3 = "MouseButton3";
	Shift = "LeftShift";
	Ctrl = "LeftControl";
}
local function assertMethod(m)
    assert(m == cxitio, "You need to call this as a method!", 3);
end

local done = {};
local function safeGet(k)
    k = Aliases[k] or k;
  if not done[k] then
    print("Safe get",k)
      local k = InputTypes[k];
      assert(k, tostring(k).." is not a valid input type :(", 3)
      done[k] = true;
  end
  return k;
end
local function getInputData(k)
    k = safeGet(k);
    if not InputData[k] then
        InputData[k],SafeSet[k] = newInput();
    end
    return InputData[k];
end


function cxitio:BindInputDown(k,f,c) -- How convenient...
    assertMethod(self);
    assert(type(f)=='function', "You really should supply a function to bind.",2)
    k = safeGet(k);
    Binds[k] = Binds[k] or {Keydown = {}; Keyup = {}}; -- Needs to start populating the table
    local BindController = c or setmetatable({},{
        __index = {
            disconnect = function(self)
                Binds[k].Keydown[self] = nil;
            end;
            changeKey = function(self,k)
                self:disconnect();
                cxitio:BindInputDown(k,f,self);
            end
        };
        __newindex = function()error("No changing the Controller!")end;
        __metatable = "Locked metatable :'(";
    });
    Binds[k].Keydown[BindController] = f;
    return BindController;
end

function cxitio:BindInputUp(k,f,c)
    assertMethod(self);
    assert(type(f)=='function', "You really should supply a function to bind.",2)
    k = safeGet(k);
    Binds[k] = Binds[k] or {Keydown = {}; Keyup = {}}; -- Needs to start populating the table
    local BindController = c or setmetatable({},{
        __index = {
            disconnect = function(self)
                Binds[k].Keyup[self] = nil;
            end;
            changeKey = function(self,k)
                self:disconnect();
                cxitio:BindInputUp(k,f,self);
            end
        };
        __newindex = function()error("No changing the Controller!")end;
        __metatable = "Locked metatable :'(";
    });
    Binds[k].Keyup[BindController] = f;
    return BindController;
end

function cxitio:Alias(K,k)
    assertMethod(self);
    assert(type(K) == 'string', "Must be a string for argument #1", 2);
    assert(type(k) == 'string' and safeGet(k), "Invalid argument #2", 2);
    if not Aliases[K] then Aliases[K] = k; end;
end

-- Polling events;
local active = false;

local inputEdge = function(iData)
    if not active then
        local k = safeGet((iData.KeyCode == Enum.KeyCode.Unknown and iData.UserInputType or iData.KeyCode).Name);
        local uData = getInputData(k);
        local begin = iData.UserInputState == Enum.UserInputState.Begin;
        SafeSet[k]("Down", begin);
        if Binds[k] then
            -- If there is a bind for this input
            for k, v in next, Binds[k]["Key" .. (begin and "down" or "up")] do
                coroutine.wrap(v)(uData);
            end
        end
    end
end

UIS.InputBegan:connect(inputEdge);
UIS.InputEnded:connect(inputEdge);
UIS.TextBoxFocused:connect(function() active = true; end);
UIS.TextBoxFocusReleased:connect(function() active = false; end);

do
local Keys = newproxy(true);
local mt = getmetatable(Keys);
mt.__index = function(_,k) return getInputData(k) end;
mt.__newindex = function() error("No manually changing the Input keys"); end;
mt.__tostring = function() return "Valkyrie binds keys table"; end;
mt.__metatable = "Locked Metatable: Valkyrie";
cxitio.Keys = Keys;
end

do
  local ocxi = cxitio;
  cxitio = newproxy(true);
  local mt = getmetatable(cxitio);
  mt.__index = ocxi;
  mt.__newindex = error;
  mt.__tostring = function(a) return "Valkyrie Binds Manager" end;
  mt.__metatable = "Locked metatable: Valkyrie";
end
return cxitio