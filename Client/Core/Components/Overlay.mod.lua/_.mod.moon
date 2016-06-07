Valkyrie = _G.ValkyrieC
Load = Valkyrie.LoadLibrary
Load "Util"
Load "Design"

Valkyrie = _G.ValkyrieC
Overlay = Valkyrie\GetOverlay!

r = newproxy true
hybrid = Valkyrie.GetComponent('moonutil').ExtractWrapper r

init = false
open = false

-- Whoops.
OverlayController = with {}
    .OpenOverlay = hybrid ->
        if init
            -- Need a better opening animation now that it's differently styled
        else
            -- Get our init going
            require(script.init)!
        open = true
    .CloseOverlay = hybrid ->
        -- Also need a better closing animation.
        open = false
    .ToggleOverlay = hybrid ->
        return OverlayController.CloseOverlay! if open else OverlayController.OpenOverlay!
    
    
with getmetatable r
    .__index = OverlayController
    .__metatable = 'Locked Metatable: Valkyrie Overlay'
    .__tostring = -> "Valkyrie Overlay"

return r
