Appbar Text Object Controller
===
Methods
---
**ChangeText**
```lua
TextObject:ChangeText(
	var 		NewText,
	?number		Duration,
	?string		Tween,
	?bool		Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```

This function changes the text of the Text Object to `NewText`.
It does it by tweening the main text object to the left side of the screen and
tweening the alternate text object from the top.

Since it switches them around, `self.MainObject` and `self.AltObject` will be 
switched around as well.

If `Async` is true, `Sync` is returned. It is explained in Sync.md.


**TweenTextColor**
```lua
TextObject:TweenTextColor(
	Color3 		NewColor,
	?number		Duration,
	?string		Tween,
	?bool		Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```

This function tweens the text's color.
If `Async` is true, `Sync` is returned. It is explained in Sync.md.

Properties
---
**Appbar**
```lua
Instance Appbar = Appbar
```

This property is the Appbar that contains the text.

**MainObject**
```lua
Instance MainObject = MainObject 
```

This property is the main icon.

**AltObject**
```lua
Instance AltObject = AltObject
```

This property is the alternative icon.