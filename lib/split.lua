function split (string, seperator) -- https://stackoverflow.com/questions/1426954/split-string-in-lua
  if seperator == nil then
    seperator = "%s"
  end
  local t={}
  for str in string.gmatch(string, "([^"..seperator.."]+)") do
    table.insert(t, str)
  end
  return t
end

return split