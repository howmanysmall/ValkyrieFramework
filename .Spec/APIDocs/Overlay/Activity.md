Activity Class
===
Members
---
**NewScreen**
``` lua
:NewScreen ( [self]
	?table data {
		?string Name = 'Screen';
	}
) -> Screen NewScreen
```
Generates a new Screen object for the supplied Activity

**SetContent**
``` lua
:SetContent ( [self]
	table<Instance> Data {...}
) -> nil
```
Sets the Activity content. All Instances will be set to a zindex of 4 and forced
to remain at a zindex of 4. Make sure to get the table in the right order to
make sure they are parented in the right order. All you will manage to do by not
setting this up correctly is break all Screens that open over the Activity.

**Close**
``` lua
:Close([self]) -> nil
```
Closes the Activity, including any screens that are open.

**OpenScreen**
``` lua
:OpenScreen ( [self]
	Screen TargetScreen
) -> nil
```
Opens `TargetScreen` over the Activity

**SetSidebarContent** [*Inactive*]
``` lua
:SetSidebarContent( [self]
	table<table> Content {
		... <{
			-- Content
		}>
	}
) -> nil
```
Sets the SidebarContent and configures it for automatic binding of events.