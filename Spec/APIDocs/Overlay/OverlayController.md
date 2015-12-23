Overlay Controller
===
Settings
---
`Valkyrie:GetSettings "Overlay"`
TODO: Add settings for dealing with CoreGui

Members
---
**Open**
``` lua
Overlay.Open() -> nil
[Intent:OverlayOpened]
```
Opens the Overlay and fires `OverlayOpened`

**Close**
``` lua
Overlay.Close() -> nil
[Intent:OverlayClosed]
```
Closes the Overlay and fires `OverlayClosed`

**CreateActivity** [*Dynamic method*]
``` lua
Overlay.CreateActivity (
	table Properties {
		?string Name;
		?Color3 Color || ?Color3 Colour
}
) -> Activity NewActivity
[Intent:ActivityCreated] -> Activity NewActivity
```
Creates an `Activity` object with the basic properties specified in `Properties`

**OpenActivity**
``` lua
Overlay.OpenActivity (
	Activity TargetActivity;
) -> nil
[Intent:ActivityOpened] -> Activity TargetActivity
```
Closes the active activity object, including any screens it may have open, and
opens `TargetActivity`

**ShowMain**
``` lua
Overlay.ShowMain() -> nil
[Intent:ActivityOpened] -> Activity DashboardActivity
[Intent:OverlayHome]
```
Closes active activities and opens the main DashboardActivity. You are highly
advised to not modify this Activity unless you know what you're replacing.