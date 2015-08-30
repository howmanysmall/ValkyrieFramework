Screen Class
===
Members
---
**Close**
``` lua
:Close([self]) -> nil
```
Closes the Screen and returns to the parent Activity.

**SetContent**
``` lua
:SetContent ( [self]
	table<Instance> Content {
		...
	}
) -> nil
```
Sets the content of the Screen. All content is forced at zindex 7.