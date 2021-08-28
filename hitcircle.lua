local Draw = require "lib.draw"
local Utils = require "lib.utils"

local Hitcircle = {}

function Hitcircle:create(x, y, combo, color, id, time, hitsound)
  local hitcircle = {}
  local isVisible = false
  
  local apprScale = 0
  
  function hitcircle:draw()
    love.graphics.setColor(color)
    Draw(skin.hitcircle, x, y, normalizedCS, 0)
    love.graphics.setColor(1, 1, 1)
    Draw(skin.hitcircleoverlay, x, y, normalizedCS, 0)
    love.graphics.setColor(color)
    Draw(skin.approachcircle, x, y, apprScale * normalizedCS, 0)
    love.graphics.setColor(1, 1, 1)
    
    if combo == 1 then
      Draw(skin.default_1, x, y, normalizedCS, 0)
    elseif combo == 2 then
      Draw(skin.default_2, x, y, normalizedCS, 0)
    elseif combo == 3 then
      Draw(skin.default_3, x, y, normalizedCS, 0)
    elseif combo == 4 then
      Draw(skin.default_4, x, y, normalizedCS, 0)
    elseif combo == 5 then
      Draw(skin.default_5, x, y, normalizedCS, 0)
    elseif combo == 6 then
      Draw(skin.default_6, x, y, normalizedCS, 0)
    elseif combo == 7 then
      Draw(skin.default_7, x, y, normalizedCS, 0)
    elseif combo == 8 then
      Draw(skin.default_8, x, y, normalizedCS, 0)
    elseif combo == 9 then
      Draw(skin.default_9, x, y, normalizedCS, 0)
    else
      Utils:drawDefault(skin, combo, x, y, normalizedCS, -10)
    end    
  end
  
  function hitcircle:updateApproach(timer)
    local timeDiff = time - (timer * 1000)
    local approachTime = Utils:preempt(ar)
    local scale = timeDiff / approachTime
    apprScale = 1 + scale * 3
  end
  
  function hitcircle:IsVisible()
    return isVisible
  end
  
  function hitcircle:ToggleVisibility()
    isVisible = not isVisible
  end
  
  function hitcircle:SetCombo(newcombo)
    combo = newcombo
  end
  
  function hitcircle:GetCombo()
    return combo
  end
  
  function hitcircle:GetID()
    return id
  end
  
  function hitcircle:getHitResult(time)
    local timeDiff = math.abs(tonumber(time))
    --print(timeDiff)
    if timeDiff <= Utils:getODTiming(od, true, 300) then 
      return 300
    elseif timeDiff <= Utils:getODTiming(od, true, 100) then 
      return 100
    elseif timeDiff <= Utils:getODTiming(od, true, 50) then
      return 50
    else 
      return 0
    end
  end
  
  hitcircle['x'] = x
  hitcircle['y'] = y
  hitcircle['time'] = time
  hitcircle['hitSound'] = hitsound
  
  return hitcircle
end

return Hitcircle