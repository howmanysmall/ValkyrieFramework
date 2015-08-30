Appbar Icon Instance Controller
===
Methods
---
**TweenIconColor**
```lua
IconInstance:TweenIconColor(
	Color3 		NewColor,
	?number		Duration,
	?string		Tween,
	?bool 		Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```

This function tweens the color of the icon.
If `Async` is true, `Sync` is returned. It is explained in Sync.md.

**ChangeIcon**
```lua
IconInstance:ChangeIcon(
	table		NewIcon {
		string 		Tileset,
		string  	Name
	},
	?number		Duration,
	?string 	Tween,
	?bool 		Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```

This function changes the icon by tweening the current icon to the side and
tweening an alternate icon from the side.
Since it switches them around, their names, `self.MainIcon`, `self.AltIcon`
and the callback connections will also be switched around.
If `Async` is true, `Sync` is returned. It is explained in Sync.md.

**GetCallback**
```lua
IconInstance:GetCallback(
) -> ?table {
	Connection Main,
	Connection Alt
}
```

This function returns a table of connections that are connected to their
respective icons' InputEnded events (if the table exists).

**DisconnectCallback**
```lua
IconInstance:DisconnectCallback(
)
```

This function disconnects the callbacks.

**SetCallback**
```lua
IconInstance:SetCallback(
	function() Callback
)
```

This function sets up a callback that is fired when the user clicks (button 1)
or taps the icon.


Properties
---
**Appbar**
```lua
Instance Appbar = Appbar
```

This property is the Appbar that contains the icon.

**MainIcon**
```lua
Instance MainIcon = Icon 
```

This property is the main icon.

**AltIcon**
```lua
Instance AltIcon = AltIcon
```

This property is the alternative icon.

**Side**
```lua
string Side = "Left" or "Right"
```

This property contains the side of the icon.