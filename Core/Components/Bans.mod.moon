--//
--// * Bans module for Valkyrie Server
--// | Manages making bans for games, including checking for bans and offering
--// | a simple global bans proxy.
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
  CreateBan: (Player, Reason) ->
    if IsInstance Player and Player\IsA "Player" then Player = Player.UserId
    assert type(Player) == 'number',
      "[Error][Valkyrie Bans] (in CreateBan): Argument #1 must be a Player or UserId",
      2
    assert type(Reason) == 'string'
      "[Error][Valkyrie Bans] (in CreateBan): Argument #2 must be a string",
      2
    r,e = RemoteCommunication.Bans\CreateBan
      Player: Player
      Reason: Reason
    return nil, e unless r
    with r
      if .IsGlobal
        IntentService.Broadcast "GlobalBanCreated", Player, Reason
      else
        IntentService.Broadcast "GameBanCreated", Player, Reason
  IsBanned: (Player) ->
    if IsInstance Player and Player\IsA "Player" then Player = Player.UserId
    assert type(Player) == 'number',
      "[Error][Valkyrie Bans] (in IsBanned): Argument #1 must be a Player or UserId",
      2
    RemoteCommunication.Bans\IsBanned
      Player: Player
  CreateGameBan: (Player, Reason) ->
    if IsInstance Player and Player\IsA "Player" then Player = Player.UserId
    assert type(Player) == 'number',
      "[Error][Valkyrie Bans] (in CreateGameBan): Argument #1 must be a Player or UserId",
      2
    assert type(Reason) == 'string',
      "[Error][Valkyrie Bans] (in CreateGameBan): Argument #2 must be a string",
      2
    r,e = RemoteCommunication.Bans\CreateGameBan
      Player: Player
      Reason: Reason
    return nil, e unless r
    with r
      IntentService.Broadcast "GameBanCreated", Player, Reason
  RemoveGameBan: (Player) ->
    if IsInstance Player and Player\IsA "Player" then Player = Player.UserId
    assert type(Player) == 'number',
      "[Error][Valkyrie Bans] (in RemoveBan): Argument #1 must be a Player or UserId",
      2
    r,e = RemoteCommunication.Bans\RemoveGameBan
      Player: Player
    return nil, e unless r
    with r
      IntentService.Broadcast "GameBanRemoved", Player

ni = newproxy true
for k,v in pairs cxitio
  if type(v) == 'function'
    cxitio[k] = (...) -> v select 2, ... if ... == ni else v ...
with getmetatable ni
  .__index = cxitio
  .__metatable = "Locked Metatable: Valkyrie"
  .__tostring = -> "Valkyrie Bans module"
return ni
