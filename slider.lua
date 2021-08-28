local Draw = require "lib.draw"
local Utils = require "lib.utils"
local Flux = require "lib.flux.flux"

local Slider = {}

function Slider:create(color, curve, id, length, slides, time, edgeSounds, ...)
  local slider = {}
  local isVisible = false
  local drawSliderEnd = false
  local DrawSliderBall = false
  local drawCombo = true
  local beizerQuality = 4
  local arg = {...}
  
  local apprScale = 0
  
  local combo = 0
  
  local timer = 0
  local sliderTime = 0
  
  local bpoint = 1
  local point = 3
  
  local slidesLeft = tonumber(slides)
  local reverseSlider = false
  
  local sliderbXY = {}
  sliderbXY['x'] = arg[1]
  sliderbXY['y'] = arg[2]
  
  function slider:draw()
    if curve == 'B' then
      local curve = love.math.newBezierCurve(arg)
      local renderedCurve = curve:render(beizerQuality)
      love.graphics.setLineWidth(115 * normalizedCS)
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.line(renderedCurve)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 60 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 50 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 48 * normalizedCS)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.circle('fill', arg[1], arg[2], 60 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', arg[1], arg[2], 50 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.circle('fill', arg[1], arg[2], 48 * normalizedCS)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setLineWidth(100 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.line(renderedCurve)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setLineWidth(98 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.line(renderedCurve)
      love.graphics.setColor(1, 1, 1)
      
      if drawSliderEnd then
        love.graphics.setColor(color)
        Draw(skin.hitcircle, arg[#arg - 1], arg[#arg], normalizedCS, 0)
        love.graphics.setColor(1, 1, 1)
        Draw(skin.hitcircleoverlay, arg[#arg - 1], arg[#arg], normalizedCS, 0)
      end
      
      if tonumber(slides) > 1 then
        Draw(skin.reversearrow, arg[#arg - 1], arg[#arg], normalizedCS, 0)
      end
      if tonumber(slides) > 2 and DrawSliderBall then
        Draw(skin.reversearrow, arg[1], arg[2], normalizedCS, 0)
      end
        
      if not DrawSliderBall then
        love.graphics.setColor(color)
        Draw(skin.hitcircle, arg[1], arg[2], normalizedCS, 0)
        love.graphics.setColor(1, 1, 1)
        Draw(skin.hitcircleoverlay, arg[1], arg[2], normalizedCS, 0)
        love.graphics.setColor(color)
        Draw(skin.approachcircle, arg[1], arg[2], apprScale * normalizedCS, 0)
        love.graphics.setColor(1, 1, 1)
      end
    elseif curve == 'C' then
      local curve = Utils:catmull(arg)
      
      love.graphics.setLineWidth(115 * normalizedCS)
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.line(curve)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 60 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 50 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 48 * normalizedCS)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.circle('fill', arg[1], arg[2], 60 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', arg[1], arg[2], 50 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.circle('fill', arg[1], arg[2], 48 * normalizedCS)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setLineWidth(100 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.line(curve)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setLineWidth(98 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.line(curve)
      love.graphics.setColor(1, 1, 1)
      
      if drawSliderEnd then
        love.graphics.setColor(color)
        Draw(skin.hitcircle, arg[#arg - 1], arg[#arg], normalizedCS, 0)
        love.graphics.setColor(1, 1, 1)
        Draw(skin.hitcircleoverlay, arg[#arg - 1], arg[#arg], normalizedCS, 0)
      end
      
      if tonumber(slides) > 1 then
        Draw(skin.reversearrow, arg[#arg - 1], arg[#arg], normalizedCS, 0)
      end
      if tonumber(slides) > 2 and DrawSliderBall then
        Draw(skin.reversearrow, arg[1], arg[2],normalizedCS1, 0)
      end
      
      if not DrawSliderBall then
        love.graphics.setColor(color)
        Draw(skin.hitcircle, arg[1], arg[2],normalizedCS1, 0)
        love.graphics.setColor(1, 1, 1)
        Draw(skin.hitcircleoverlay, arg[1], arg[2], normalizedCS, 0)
        love.graphics.setColor(color)
        Draw(skin.approachcircle, arg[1], arg[2], apprScale * normalizedCS, 0)  
        love.graphics.setColor(1, 1, 1)
      end
    else
      
      love.graphics.setLineWidth(115 * normalizedCS)
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.line(arg)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 60 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 50 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.circle('fill', arg[#arg - 1], arg[#arg], 48 * normalizedCS)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.circle('fill', arg[1], arg[2], 60 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', arg[1], arg[2], 50 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.circle('fill', arg[1], arg[2], 48 * normalizedCS)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setLineWidth(100 * normalizedCS)
      love.graphics.setColor(0, 0, 0)
      love.graphics.line(arg)
      love.graphics.setColor(1, 1, 1)
      
      love.graphics.setLineWidth(98 * normalizedCS)
      love.graphics.setColor(color)
      love.graphics.line(arg)
      love.graphics.setColor(1, 1, 1)
      
      if drawSliderEnd then
        love.graphics.setColor(color)
        Draw(skin.hitcircle, arg[#arg - 1], arg[#arg], normalizedCS, 0)
        love.graphics.setColor(1, 1, 1)
        Draw(skin.hitcircleoverlay, arg[#arg - 1], arg[#arg], normalizedCS, 0)
      end
      
      if tonumber(slides) > 1 then
        Draw(skin.reversearrow, arg[#arg - 1], arg[#arg], normalizedCS, 0)
      end
      if tonumber(slides) > 2 and DrawSliderBall then
        Draw(skin.reversearrow, arg[1], arg[2], normalizedCS, 0)
      end
      
      if not DrawSliderBall then
        love.graphics.setColor(color)
        Draw(skin.hitcircle, arg[1], arg[2], normalizedCS, 0)
        love.graphics.setColor(1, 1, 1)
        Draw(skin.hitcircleoverlay, arg[1], arg[2], normalizedCS, 0)
        love.graphics.setColor(color)
        Draw(skin.approachcircle, arg[1], arg[2], apprScale * normalizedCS, 0) 
        love.graphics.setColor(1, 1, 1)
      end
    end
    
    if drawCombo then
      if combo == 1 then
        Draw(skin.default_1, arg[1], arg[2], normalizedCS, 0)
      elseif combo == 2 then
        Draw(skin.default_2, arg[1], arg[2], normalizedCS, 0)
      elseif combo == 3 then
        Draw(skin.default_3, arg[1], arg[2], normalizedCS, 0)
      elseif combo == 4 then
        Draw(skin.default_4, arg[1], arg[2], normalizedCS, 0)
      elseif combo == 5 then
        Draw(skin.default_5, arg[1], arg[2], normalizedCS, 0)
      elseif combo == 6 then
        Draw(skin.default_6, arg[1], arg[2], normalizedCS, 0)
      elseif combo == 7 then
        Draw(skin.default_7, arg[1], arg[2], normalizedCS, 0)
      elseif combo == 8 then
        Draw(skin.default_8, arg[1], arg[2], normalizedCS, 0)
      elseif combo == 9 then
        Draw(skin.default_9, arg[1], arg[2], normalizedCS, 0)
      else
        Utils:drawDefault(skin, combo, arg[1], arg[2], normalizedCS, -10)
      end
    end
  end
  
  function slider:drawSliderBall()
    Draw(skin.sliderb, sliderbXY.x, sliderbXY.y, normalizedCS, 0)
    Draw(skin.sliderfollowcircle, sliderbXY.x, sliderbXY.y, normalizedCS, 0)
  end
  
  function slider:ToggleVisibility()
    isVisible = not isVisible
  end
  
  function slider:IsVisible()
    return isVisible
  end
  
  function slider:GetSliderTime(beatLength) -- https://github.com/itdelatrisu/opsu/blob/28003bfbe5195a97c1d7135d6060d09727768aab/src/itdelatrisu/opsu/beatmap/HitObject.java#L410
    sliderTime = beatLength * (length / beatmapDifficulty[4]) / 100
    --sliderTime = (beatLength * (length / beatmapDifficulty[4]) / 100)
    return sliderTime
  end
  
  function slider:updateApproach(timer) -- https://github.com/itdelatrisu/opsu/blob/28003bfbe5195a97c1d7135d6060d09727768aab/src/itdelatrisu/opsu/objects/Slider.java#L193
    local timeDiff = time - (timer * 1000)
    local approachTime = Utils:preempt(ar)
    local scale = timeDiff / approachTime
    apprScale = 1 + scale * 3
  end
  
  function slider:GetID()
    return id
  end
  
  function slider:ToggleSliderBall()
    drawCombo = not drawCombo
    DrawSliderBall = not DrawSliderBall
  end
  
  function slider:IsSliderBall()
    return DrawSliderBall
  end
  
  function slider:SliderBallUpdate(dt, length)
    local timeDiff = sliderTime - (timer * 1000)
    Flux.update(dt)
    --[[if slidesLeft > 1 then
      if reverseSlider == false then
        print('not reverse')
        Flux.to(sliderbXY, math.abs(timeDiff / 1000) / slidesLeft, {x = arg[#arg - 1], y = arg[#arg]}):ease("linear"):oncomplete(function() reverseSlider = true; slidesLeft = slidesLeft - 1; print('not reverse done') end)
      end
      if reverseSlider == true then
        print('reverse')
        Flux.to(sliderbXY, math.abs(timeDiff / 1000) / slidesLeft, {x = arg[1], y = arg[2]}):ease("linear"):oncomplete(function() slidesLeft = slidesLeft - 1; print('reverse done') end)
      end--]]
    --elseif slides == 1 then
      Flux.to(sliderbXY, math.abs(timeDiff / 1000), {x = arg[#arg - 1], y = arg[#arg]}):ease("linear")
    --end
  end
  
  function slider:setTimer(timer)
    self.timer = timer
  end
  
  function slider:SetCombo(newcombo)
    combo = newcombo
  end
  
  slider['slides'] = slides
  slider['combo'] = combo
  slider['time'] = time
  slider['length'] = length
  slider['edgeSounds'] = edgeSounds
  
  return slider
end

return Slider