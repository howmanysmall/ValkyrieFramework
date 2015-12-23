Valkyrie API
===

Methods
---
*Most Valkyrie methods can be called as a method or a function, unless shown
to be otherwise*

**GetComponent**
``` lua
Valkyrie:GetComponent(
  string ComponentName
) -> var Component
```
Returns the component at `ComponentName`. Respects wrapper behaviour.
    
---
        
**SetComponent**
``` lua
Valkyrie:SetComponent(
  string ComponentName,
  var Component
) -> nil
```
Sets the component at `ComponentName` to Component, unless `ComponentName` is
reserved for an existing Valkyrie component.

---

**GetSettings**  
*This function has different behaviour on the client and server*

* Client
  ``` lua
  Valkyrie:GetSettings(
    (string,bool) ?SettingsName
  ) | bool SettingsName -> true ? Settings.User : Settings.Custom
    | string SettingsName -> Settings.Components[SettingsName]
    | nil SettingsName -> Settings.Custom
  ```
  Takes a string, bool or nil. If `SettingsName` is a bool, it returns
  `Settings.User` if true, or `Settings.Custom` if false. It also returns
  `Settings.Custom` if it is nil. If the supplied value is a string, it returns
  the component settings relating to that value.
 
* Server
  ``` lua
  Valkyrie:GetSettings(
    string ?SettingsName
  ) | string SettingsName -> Settings.Components[SettingsName]
    | nil SettingsName -> Settings.Custom
  ```
  Takes a string or nil, and returns the component settings for that string or
  `Settings.Custom` if no string is supplied.

---

**LoadLibrary**
``` lua
Valkyrie:LoadLibrary(
  string LibraryName
) -> nil
```
Loads the Library at `LibraryName` into the environment the function was called
from. For all intents and purposes, libraries should be loaded before you define
any local values to avoid retaining unwrapped values in a wrapped environment.

---

**AddLibrary**
``` lua
Valkyrie:AddLibrary(
  (function,ModuleScript) Library,
  string LibraryName
) -> nil
```
Adds the Library at `Library` to the list of valid library names for
`:LoadLibrary`, provided that `Library` is a function or a ModuleScript
returning a function.

---

**GenerateWrapper**
``` lua
Valkyrie:GenerateWrapper(
  bool ?Private
) -> ValkyrieWrapper Wrapper
```
Returns a Wrapper object. If the bool supplied is true, then the Wrapper has its
own ulist and wlist, along with a few other things. This makes it partially
incompatible with other wrapped objects.

Auth
---
When authorising Valkyrie, you must first `require()` the loader from a Roblox
server, which returns the auth function. You should then call the auth function
with your GameId and your private auth Key, which is checked with the Valkyrie
servers along with the Id of the user the place belongs to. If all is fine, then
the function will return the Valkyrie core object. It will also insert Valkyrie
into `_G.Valkyrie`, so that you can access it in all Scripts.