local Draw = require "lib.draw"
local Utils = require "lib.utils"
local Flux = require "lib.flux.flux"
local Tween = require "lib.tween.tween"

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

  local bpoint = 3
  local point = 3

  local slidesLeft = tonumber(slides)
  local reverseSlider = false

  local sliderbXY = {}
  sliderbXY['x'] = tonumber(arg[1])
  sliderbXY['y'] = tonumber(arg[2])

  local oldsliderbXY = {}
  oldsliderbXY['x'] = sliderbXY.x
  oldsliderbXY['y'] = sliderbXY.y

  local sliderbVX, sliderbVY = 0, 0 
  local dist2 = nil

  local calculated = false

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
    local timeDiff = ((timer * 1000) - time) / sliderTime
    --print('X: '..sliderbXY['x']..' Y: '..sliderbXY['y'])
    --[[if curve == 'B' then
      local curve = love.math.newBezierCurve(arg)
      local renderedCurve = curve:render(beizerQuality)
      if not calculated and renderedCurve[bpoint] ~= nil and renderedCurve[bpoint + 1] ~= nil then slider:calculateV(renderedCurve[bpoint], renderedCurve[bpoint + 1], 10); print('calculated new velocity') elseif not calculated then slider:calculateV(renderedCurve[#renderedCurve - 1], renderedCurve[#renderedCurve], timeDiff); print('calculated last velocity') end
      
      sliderbXY.x = sliderbXY.x + sliderbVX * dt
      sliderbXY.y = sliderbXY.y + sliderbVY * dt
      
      local dist = (oldsliderbXY.x - sliderbXY.x) ^ 2 + (oldsliderbXY.y - sliderbXY.y) ^ 2
      if renderedCurve[bpoint + 1] == nil and renderedCurve[bpoint] == nil then
        sliderbXY.x = arg[#arg - 1]
        sliderbXY.y = arg[#arg]
        sliderbVX = 0
        sliderbVY = 0
        print('finished slider')
      elseif dist >= dist2 then
        --sliderbXY.x = renderedCurve[bpoint]
        --sliderbXY.y = renderedCurve[bpoint + 1]
        sliderbVX = 0
        sliderbVY = 0
        --slidesLeft = slidesLeft - 1
        --reverseSlider = not reverseSlider
        calculated = false
        bpoint = bpoint + 1
        print('next beizer point')
      end
    end--]]

    --local sliderbTween = Tween.new(math.abs(sliderTime / 1000), sliderbXY, {x = arg[#arg - 1], y = arg[#arg]}, 'linear')
    --sliderbTween:update(dt)
    
    if curve == 'B' then
      
      
      --local sliderbt = Tween.new(math.abs(timeDiff / 1000) / #renderedCurve, sliderbXY, {x = renderedCurve[bpoint], y = renderedCurve[bpoint + 1]}, 'linear')
      local curve = love.math.newBezierCurve(arg)
      local renderedCurve = curve:render(2)
      --print(math.abs(sliderTime / 1000) / (#renderedCurve * 4))
      
      local sliderbt = Tween.new(math.abs(sliderTime / 1000) / #renderedCurve, sliderbXY, {x = renderedCurve[bpoint], y = renderedCurve[bpoint + 1]}, 'linear')
      
      local complete = sliderbt:update(dt)
      --print(bpoint..' / '..#renderedCurve)
      if complete then bpoint = bpoint + 4; remade = false end
    else
      local sliderbt = Tween.new(math.abs(sliderTime / 1000) / #arg, sliderbXY, {x = arg[point], y = arg[point + 1]}, 'linear')
      
      local complete = sliderbt:update(dt)
      --print(point..' / '..#arg)
      if complete then point = point + 2; remade = false end
    end
  end

  function slider:setTimer(timer)
    self.timer = timer
  end

  function slider:SetCombo(newcombo)
    combo = newcombo
  end

  function slider:calculateV(tx, ty, time)
    dist2 = (tx - sliderbXY.x) ^ 2 + (ty - sliderbXY.y) ^ 2
    
    local dist3 = math.sqrt(dist2)

    oldsliderbXY['x'] = sliderbXY.x
    oldsliderbXY['y'] = sliderbXY.y

    sliderbVX = (tx - sliderbXY.x) / dist3 * time
    sliderbVY = (ty - sliderbXY.y) / dist3 * time
    --print(sliderbVX..' '..sliderbVY)
    calculated = true
  end

  slider['slides'] = slides
  slider['combo'] = combo
  slider['time'] = time
  slider['length'] = length
  slider['edgeSounds'] = edgeSounds

  return slider
end

return Slider