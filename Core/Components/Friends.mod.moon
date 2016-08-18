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
--|> table Data {
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
  r = with RemoteCommunication.Friends\GetFriends
      ID: Player
    return error .Error, 2 unless .Success
  return r.Data
cxitio.ListFriends = cxitio.List
cxitio.GetFriends = cxitio.List

--|: Invite
--|~ InviteFriend, InviteToGame
--|< var<Player, int> PlayerAs, var<Player, int> Friend
--|> {Success = bool Success, Error = bool Error}
cxitio.Invite = Hybrid (Player, Friend) ->
  if IsInstance Player then Player = Player.UserId
  if IsInstance Friend then Friend = Friend.UserId
  assert type(Player) == 'number',
    "[Error][Valkyrie] (in Friends.Invite): Argument #1 must be a Player or UserId",
    2
  assert type(Friend) == 'number',
    "[Error][Valkyrie] (in Friends.Invite): Argument #2 must be a Player or UserId",
    2
  return with RemoteCommunication.Friends\Invite
      ID: Player
      Friend: Friend
    return error .Error, 2 unless .Success

with getmetatable ni
  .__index = cxitio
  .__tostring = -> "Valkyrie Friends Controller"
  .__metatable = "Locked Metatable: Valkyrie"

return ni
