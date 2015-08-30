Intent Service
===
*Used for anonymous, independent event broadcasting and listeners*  
*All functions are dynamic and can be called as methods, or on their own*  

**BroadcastIntent**
``` lua
IntentService:BroadcastIntent(
  string Intent,
  ... Info
) -> nil
```
Broadcasts `Info` to listeners registered to `Intent`

---

**RegisterIntent**
``` lua
IntentService:RegisterIntent(
  string Intent,
  function(...) Listener
) -> RBXScriptConnection Controller
```
Registers `Listener` as a listener for `Intent`

---

**BroadcastRPCIntent**  
*This function has different behaviour on the client and server*

* Client
  ``` lua
  IntentService:BroadcastRPCIntent(
    string Intent,
    ... Info
  ) -> nil
  ```
  Broadcasts `Info` to listeners on the server registered to `Intent`
* Server
  ``` lua
  IntentService:BroadcastRPCIntent(
    string Intent,
    (Player,string) Target,
    ... Info
  ) -> nil
  ```
  Broadcasts `Info` to listeners at `Target` registered to `Intent`. `Target`
  can be either a Player, or the string 'All'. Anything else will break.

---

**RegisterRPCIntent**  
*This function has different behaviour on the client and server*

* Client
  ``` lua
  IntentService:RegisterRPCIntent(
    string Intent,
    function(...) Listener
  ) -> RBXScriptConnection Controller
  ```
  Registers `Listener` as a listener for RPC intent `Intent`
* Server
  ``` lua
  IntentService:RegisterRPCIntent(
    string Intent,
    function(Player p,...) Listener
  ) -> RBXScriptConnection Controller
  ```
  Registers `Listener` as a listener for RPC intent `Intent`. First parameter to
  `Listener` should be the Player that broadcasted the intent.
