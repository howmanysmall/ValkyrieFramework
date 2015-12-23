Anticheat Controller
===
Settings
---
`Valkyrie:GetSettings("AntiCheat")`

**KickMessage**  
*Type:* string  
*Default value:* nil  
  
**KickLimit**  
*Type:* int  
*Default value:* 1

Methods
---
*All methods are dynamic and can be called as methods or on their own*  

**Protect**
``` lua
AntiCheat:Protect(
  Instance Value
)
```
Supplied a Value type Instance, `Value` becomes protected such that if `Value`
is changed on the client, the value is checked back against the server. If they
don't match up, then the user is kicked and banned. Easy. Should not be used for
values that change rapidly or are changed in LocalScripts, because it could
result in wrongly added bans and the permission for your place to use the AC
service revoked.