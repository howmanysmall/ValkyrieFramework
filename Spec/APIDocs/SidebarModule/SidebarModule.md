Sidebar Controller
===
Methods
---
**CreateSidebar**
```lua
SidebarController:CreateSidebar(
	?table Settings {
		?table Items {
			?table Settings1 {
				?Color3 BackgroundColor,
				?Color3 TextColor,
				?var Text, 	// will be tostring()'d
			},
			?...
		},
		?Color3 BackgroundColor,
		?Color3 BorderColor
	},
	?string TweenName,
	?number TweenDuration,
	?bool Async
) | bool Async -> SidebarInstance, Async == true ? Sync : nil
  | nil Async -> SidebarInstance
```

`SidebarInstance` is explained in SidebarInstance.md.

This function creates a Sidebar, applies the given settings to it and tweens it
in from the left.  
It also creates a Frame called `ContentFrame` inside the **current ContentFrame**. 
This is where all content should go while the Sidebar is visible.

Broadcasts `SidebarCreated` when the Sidebar is ready and fully visible (unless called asynchronously).
Broadcasts `SidebarDestroyed` when the Sidebar's parent is set to nil.
Broadcasts `SidebarTweeningIn` when the Sidebar is tweening in.
Broadcasts `SidebarTweeningOut` when the Sidebar is tweening out.
If `Async` is true, `Sync` is returned. It is explained in AppbarModule/Sync.md.