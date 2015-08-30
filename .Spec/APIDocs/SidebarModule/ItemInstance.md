Sidebar Item Instance Controller
===
Methods
---
**TweenBackgroundColor**
```lua
ItemInstance:TweenBackgroundColor(
	?Color3 NewColor,
	?string Tween,
	?number Duration,
	?bool Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```

Tweens the BackgroundColor of the Sidebar Item.
This function should be used instead of Sidebar.Raw:TweenBackgroundColor()
because it tweens the padding's color as well.
If `Async` is true, `Sync` is returned. It is explained in AppbarModule/Sync.md.

**TweenOnX**
```lua
ItemInstance:TweenOnX(
	?number NewOffset,
	?string Tween,
	?number Duration,
	?bool Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```

Tweens the item on the X axis.
If `Async` is true, `Sync` is returned. It is explained in AppbarModule/Sync.md.

**GetCallback**
```lua
ItemInstance:GetCallback(
) -> ?Connection
```

Returns the Sidebar Item's callback's event connection.

**DisconnectCallback**
```lua
ItemInstance:DisconnectCallback(
) -> nil
```
Disconnects the Sidebar Item's callback's event connec

**SetCallback**
```lua
ItemInstance:SetCallback(
	function Callback
)
```