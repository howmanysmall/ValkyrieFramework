--//
--// * Friends API for Valkyrie
--// | Lua API for getting Valkyrie friend status of players, and making
--// | requests on behalf of the player (Requires permissions set by the user)
--//

cxitio = {}
ni = newproxy true

Hybrid = (f) -> (...) -> return f select 2, ... if ... == ni else f ...

IsInstance = do
  game = game
  pcall = pcall
  GS = game.GetService
  type = type
  (i) ->
    return false unless type(i) == 'userdata'
    s,e = pcall GS, game, i
    return s and not e

RemoteCommunication = _G.Valkyrie\GetComponent "RemoteCommunication"

--|: GetFriends
--|~ ListFriends, List
--|< var<Instance<Player>, int> Player
--|> {
--    ... = {
--      Name = string Name,
--      ID = int UserId,
--      Online = bool Online, -- Anywhere
--      InGame = bool InGame, -- Any game
--      InValkyrie = bool InValkyrie, -- Valk game, valk site
--      GameID = string GameId, -- Valk ID if applicable
--      GameName = string GameName, -- Display name
--    }
--  }
cxitio.List = Hybrid (Player) ->
  assert type(Player) == 'number' or IsInstance Player,
    "[Error][Valkyrie] (in Friends.ListFriends): Argument #1 must be a Player or UserId",
    2
  if IsInstance Player then Player = Player.UserId
  return with RemoteCommunication.Friends\GetFriends
      ID: Player
    return error .Error, 2 unless .Success
cxitio.ListFriends = cxitio.List
cxitio.GetFriends = cxitio.List


with getmetatable ni
  .__index = cxitio
  .__tostring = -> "Valkyrie Friends Controller"
  .__metatable = "Locked Metatable: Valkyrie"

return ni
