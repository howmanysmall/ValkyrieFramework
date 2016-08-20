--//
--// * Error objects for Valkyrie
--// 

(val) ->
  t = {k,v for k,v in pairs val}
  r = newproxy true
  with getmetatable r
    .__index = t
    .__len = -> t.Level or 1
    .__tostring = -> string.format "[Error][%s] (in %s): %s", t.Tag, t.Section, t.Message
    .__newindex = (k,v) => t[k] = v
    .__metatable = "Locked Metatable: Valkyrie"
    .__call = => error @, (@Level or 1)+1
  return r
