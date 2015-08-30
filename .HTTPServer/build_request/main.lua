function love.load()
  TextButton:new("HoverButton");
  TextLabel:new("Display");
  HoverButton.text = "Hover me to see the TextLabel."
  HoverButton.autoSize = false
  HoverButton.size = {100,20}
  HoverButton:centerText()--Aligns text to center on Y and X axis.
  HoverButton.hasBorder = false
  Display.text = ":o"
  Display.visible = false
  Display.size = {100,20}
  Display:centerText()
  Display.position = {0,20}
  Display.hasBorder = false
  HoverButton.mouseEntered:connect(function()
    Display.visible = true
  end)
  HoverButton.mouseExited:connect(function()
    Display.visible = false
  end)
end
