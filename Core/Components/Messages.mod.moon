--//
--// * Messages component for Valkyrie Server
--//

RemoteCommunication = _G.Valkyrie.GetComponent "RemoteCommunication"
IntentService = _G.Valkyrie.GetComponent "IntentService"

IsInstance = do
  game = game
  pcall = pcall
  GS = game.GetService
  type = type
  (i) ->
    return false unless type(i) == 'userdata'
    s,e = pcall GS, game, i
    return s and not e

cxitio =
  -- INCOMPLETE SPECIFICATION FOR MESSAGES
  AddMessage: -> nil

ni = newproxy true
for k,v in pairs cxitio
  if type(v) == 'function'
    cxitio[k] = (...) -> v select 2, ... if ... == ni else v ...
with getmetatable ni
  .__index = cxitio
  .__metatable = "Locked Metatable: Valkyrie"
  .__tostring = -> "Valkyrie Messages module"
return ni
