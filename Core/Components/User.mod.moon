--//
--// * User module for Valkyrie
--// | Handles user management.
--// | Requires permissions set by the user.
--//

User = {
  Notify: (User, Data) ->
    --# var<Instance<Player>, number> User
    --# table Data
    --## string Title
    --## string Description
    --## string Callback
    --## string ActionName
    --## table CallbackData (JSON-able)
    --// Notifies a player through Valkyrie
    --// Note on notifications (on the website):
    --// Initial notifications should ask "{num} notifications from {gameName}. Show notifications from {gameName}?"
    --// Users can then accept showing notifications or block notifications from the game.
    --// If blocking, they are told where they can unblock the notifications 
    --// from the game, and prompted whether to block the developer entirely.
    --// Callbacks are invoked via web event hooks when activated on web.
    --// Client-side notifications are also generated for the data.
    return nil
  -- More user-centric actions. All will need permissions.
  RequestPermissions: (User, Permissions) ->
    --# var<Instance<Player>, number> User
    --# table Permissions
    --## ... <[string PermissionNode] = (bool Requesting = false)>
}

ni = newproxy true
for k,v in pairs User
  if type(v) == 'function'
    User[k] = (...) ->
      return v select 2, ... if ... == ni else v ...
with getmetatable ni
  .__index = User
  .__tostring = -> "Valkyrie User API"
  .__metatable = "Locked metatable: Valkyrie"

return ni
