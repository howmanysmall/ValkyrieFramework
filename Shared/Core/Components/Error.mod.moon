--//
--// * Error objects for Valkyrie
--// 

data = setmetatable {}, mode: 'k'

(val) ->
  t = {k,v for k,v in pairs val}
  r = newproxy true
  with getmetatable r
    .__index = t
    .__len = -> t.Level or 1
    .__tostring = -> string.format "[Error][%s] (in %s): %s", t.Tag, t.Section, t.Message
    .__metatable = "Locked Metatable: Valkyrie"
    .__call = error
  return r
