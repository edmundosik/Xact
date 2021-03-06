local Bitwise = {}

function Bitwise:band(a, b) -- https://stackoverflow.com/questions/32387117/bitwise-and-in-lua
  local result = 0
  local bitval = 1
  while a > 0 and b > 0 do
    if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
        result = result + bitval      -- set the current bit
    end
    bitval = bitval * 2 -- shift left
    a = math.floor(a/2) -- shift right
    b = math.floor(b/2)
  end
  return result
end

return Bitwise