Appbar Controller
===
Methods
---

**CreateAppbar**
```lua
AppbarModule:CreateAppbar(
	?table 		Settings {
		?Color3 	Color,
		?Color3		BorderColor,
		?table 		Header {
			?Color3 	Color,
			?var 		Text
		},
		?table 		RightIcon/LeftIcon {
			?Color3 	Color,
			?table 		Icon {
				string  	Tileset,
				string 		Name
			}
		}
	},
	?string 	Tween,
	?number 	Duration,
	?boolean 	Async
) | bool Async -> AppbarInstance, Async == true ? Sync : nil
  | nil Async -> AppbarInstance
```
`AppbarInstance` is explained in AppbarInstance.md.

This function creates an Appbar, applies the given settings to it and
tweens it in from the top.
It also creates a Frame called `ContentFrame` inside the Overlay. This is where
all content should go while the Appbar is visible.

Broadcasts `AppbarCreated` when the Appbar is ready and fully visible (unless called asynchronously).
Broadcasts `AppbarDestroyed` when the Appbar's Parent is set to nil.
Broadcasts `AppbarTweeningIn` when the Appbar is tweening in.
Broadcasts `AppbarTweeningOut` when the Appbar is tweening out.
If `Async` is true, `Sync` is returned. It is explained in Sync.md.
