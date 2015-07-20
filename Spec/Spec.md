Valkyrie thing specification
============================
Require
-------
Sets up everything in the main part of the module  
Returns a `function(GID,Key)`, which requests to the server for authentication  
If the server returns `false` for the success, then it errors `error`  
If the server returns `true`, then it binds events and returns the module  

Overlay
-------
* Has a neat little clock running off of 
```lua
local t=tick()%86400;
while wait(1) do
t = t+1%86400;
Clock.Text=("%.2d:%.2d:%.2d"):format(t/3600,(t/60)%60,t%60);
end
```
* Achievements display linked with the server (Including user calculated level)
* Valkyrie user currency thing level
* Multi-page layout base (Little dot things at the bottom displaying the page)
* User customisation (Just needs a colour name from the [Material Design] specification)

Developer
---------
* Needs to be able to register achievements on the server with an associated xp value, with a limit on the xp they can award per game
* Needs to be able to tell the server that a user has gotten an achievement (Authenticated by the GID and CoKey)
* Access to different variations of the API through Valkyrie:LoadLibrary(string Name)
* Ability to load different 'plugins' into the core to automate or modify behaviour

Plugins
-------
* Access to the Settings core (Create & modify its own keys)
* Access to the Valkyrie core (With all the same methods as a user)
* Access to the Valkyrie libraries
* Access to the Plugins library (Injected defaultly into function returns)
* Limited access to Valkyrie server requests (Non-constructed)



[Material Design]: http://www.google.co.uk/design/spec/style/color.html#color-color-palette