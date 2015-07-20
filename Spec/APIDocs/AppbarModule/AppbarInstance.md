Appbar Instance Controller
===
Methods
---

**TweenBarColor**
```lua 
AppbarInstance:TweenBarColor(
	Color3 		NewColor,
	?number		Duration,
	?string		Tween,
	?bool 		Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```

This function tweens the Appbar's background color.
If `Async` is true, `Sync` is returned. It is explained in Sync.md.

**GetLeftIcon/GetRightIcon**
```lua 
AppbarInstance:GetLeftIcon/GetRightIcon(
) -> IconInstance
```

These functions return the IconInstances for both icons.
`IconInstance` is explained in IconInstace.md.

**GetTextObject**
```lua
AppbarInstance:GetTextObject(
) -> TextObject
```

This function returns the TextObject of the Appbar.
`TextObject` is explained in TextObject.md.

**Destroy**
```lua
AppbarInstance:Destroy(
	?number 	Duration,
	?string 	Tween,
	?bool  		Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```

This function tweens out and destroys the Appbar.
If `Async` is true, `Sync` is returned. It is explained in Sync.md.

Properties
---
**Raw**
```lua
Instance Appbar = AppbarTemplate:Clone()
```
Raw is the raw Appbar Instance.

**ContentFrame**
```lua
Instance ContentFrame = Instance.new("Frame", Core:GetOverlay())
```
ContentFrame is the ContentFrame created by the Appbar.