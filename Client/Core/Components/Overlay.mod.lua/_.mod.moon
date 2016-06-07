Valkyrie = _G.ValkyrieC
Load = Valkyrie.LoadLibrary
Load "Util"
Load "Design"

Valkyrie = _G.ValkyrieC
Overlay = Valkyrie\GetOverlay!

sbl = new"Frame"
    Name: "LeftNav"
    Parent: Overlay
    Size: new"UDim2" 0, 56, 1, 0
    BackgroundColor3: new"Color3" .18, .18, .18
    ZIndex: 8
    Children:
        ValkButton: new"ImageButton"
            Size: new"UDim2" 0, 56, 0, 56
            
