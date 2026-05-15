-- Clean paste: Cmd+Shift+V strips leading whitespace and pastes
hs.hotkey.bind({"cmd", "shift"}, "v", function()
  local txt = hs.pasteboard.getContents()
  if not txt then return end
  txt = txt:gsub("^%s+", ""):gsub("\n[ \t]+", "\n")
  hs.pasteboard.setContents(txt)
  hs.eventtap.keyStroke({"cmd"}, "v")
end)

hs.alert.show("Config loaded")
