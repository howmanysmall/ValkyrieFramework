Sidebar Instance Controller
===
Methods
---
**GetNumItems**
```lua
SidebarInstance:GetNumItems(
) -> number NumItems
```

Returns the number of sidebar items.

**GetShowItemIndices**
```lua
SidebarInstance:GetShowItemIndices(
) -> number FirstItem, number LastItem
```

Returns the indices of the first and last shown items.

**GetItem**
```lua
SidebarInstance:GetItem(
	number Index
) -> ItemInstance
```

Returns the corresponding ItemInstance for the item.
`ItemInstance` is explained in ItemInstance.md.

**Destroy**
```
SidebarInstance:Destroy(
	?string Tween,
	?number TweenDuration,
	?bool Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```
Tweens out and destroys the sidebar.
If `Async` is true, `Sync` is returned. It is explained in AppbarModule/Sync.md.
**Make sure that no items stick out (`ItemInstance:TweenOnX`)**

**Show**
```
SidebarInstance:Show(
	?string Tween,
	?number TweenDuration,
	?bool Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```
Tweens in the sidebar.
If `Async` is true, `Sync` is returned. It is explained in AppbarModule/Sync.md.


**Hide**
```
SidebarInstance:Hide(
	?string Tween,
	?number TweenDuration,
	?bool Async
) | bool Async -> true ? Sync : nil
  | nil Async -> nil
```
Tweens out the sidebar without destroying it.
If `Async` is true, `Sync` is returned. It is explained in AppbarModule/Sync.md.
**Make sure that no items stick out (`ItemInstance:TweenOnX`)**