local Draw = require "lib.draw"

local Utils = {}

function Utils:preempt(ar) -- https://osu.ppy.sh/wiki/en/Beatmapping/Approach_rate
  if ar < 5 then
    return (1200 + 600 * (5 - ar) / 5)
  elseif ar > 5 then
    if (1200 - 750 * (ar - 5) / 5) <= 0 then 
      return 0
    else
      return (1200 - 750 * (ar - 5) / 5)
    end
  else
    return 1200
  end
end

function Utils:catmull(points, step) -- https://gist.github.com/pr0digy/1383576
	if #points < 3 then
		return points
	end

	local steps = steps or 5

	local spline = {}
	local count = #points - 1
	local p0, p1, p2, p3, x, y

	for i = 1, count do
		if i == 1 then
			p0, p1, p2, p3 = points[i], points[i], points[i + 1], points[i + 2]
		elseif i == count then
			p0, p1, p2, p3 = points[#points - 2], points[#points - 1], points[#points], points[#points]
		else
			p0, p1, p2, p3 = points[i - 1], points[i], points[i + 1], points[i + 2]
		end	
		for t = 0, 1, 1 / steps do
			x = 0.5 * ( ( 2 * p1.x ) + ( p2.x - p0.x ) * t + ( 2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x ) * t * t + ( 3 * p1.x - p0.x - 3 * p2.x + p3.x ) * t * t * t )
			y = 0.5 * ( ( 2 * p1.y ) + ( p2.y - p0.y ) * t + ( 2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y ) * t * t + ( 3 * p1.y - p0.y - 3 * p2.y + p3.y ) * t * t * t )
			--prevent duplicate entries
			if not(#spline > 0 and spline[#spline].x == x and spline[#spline].y == y) then
				table.insert( spline , { x = x , y = y } )				
			end	
		end
	end
	return spline
end

function Utils:normalize(val, min, max)
  return (val - min) / (max - min)
end

function Utils:drawDefault(skin, num, x, y, scale, hcOverlap) -- https://github.com/itdelatrisu/opsu/blob/28003bfbe5195a97c1d7135d6060d09727768aab/src/itdelatrisu/opsu/GameData.java#L505
  local length = math.log10(num) + 1
  local sprWidth = skin.default_1:getWidth() * scale + hcOverlap
  local cx = x + ((length - 1) * (sprWidth / 2))
  
  for k = 1, length do
    local defaultspr = 'default_'..tostring(num % 10)
    Draw(skin[defaultspr], cx, y, scale, 0)
    cx = cx - sprWidth
    num = num / 10
    num = math.floor(num)
  end
end

function Utils:hypot(x, y)
  return math.sqrt(x ^ 2 + y ^ 2)
end

function Utils:getODTiming(od, iscircle, score) -- https://osu.ppy.sh/wiki/en/Beatmapping/Overall_difficulty
  if iscircle then
    if score == 50 then return 400 - 20 * od end
    if score == 100 then return 280 - 16 * od end
    if score == 300 then return 160 - 12 * od end
  end
end

function Utils:getOsuPixelData(width, height) -- https://github.com/itdelatrisu/opsu/blob/28003bfbe5195a97c1d7135d6060d09727768aab/src/itdelatrisu/opsu/beatmap/HitObject.java#L149
  local out = {}
  local swidth, sheight = width, height
  
  if (swidth * 3) > (sheight * 4) then
    swidth = sheight * 4 / 3
  else
    sheight = swidth * 3 / 4
  end
  
  local xMultiplier = swidth / 640
  local yMultiplier = sheight / 480
  
  local xOffset = (width - 512 * xMultiplier) / 2
  local yOffset = (height - 384 * yMultiplier) / 2
  
  out['xMulti'] = xMultiplier
  out['yMulti'] = yMultiplier
  out['xOffset'] = xOffset
  out['yOffset'] = yOffset
  
  return out
end

function Utils:clamp(val, low, high)
   if val < low then
      val = low
   elseif val > high then
      val = high
   end
   return val
end

function Utils:calculateScore(hitscore, combo, diffMulti, modMulti)
  local out = (hitscore + (hitscore * ((combo * diffMulti * modMulti) / 25)))
  return out
end

function Utils:calculateDifficultyMulti(hp, cs, od, hitobjCount, drainTime)
  local out = (hp + cs + od + Utils:clamp(hitobjCount / drainTime * 8, 0, 16)) / 38 * 5
  return out
end

function Utils:calculateAccuracy(score50s, score100s, score300s, score0s) -- https://osu.ppy.sh/wiki/en/Gameplay/Accuracy
  local out = (50 * score50s + 100 * score100s + 300 * score300s) / (300 * (score0s + score50s + score100s + score300s))
  return out
end

function Utils:calcPercent(value, percent) -- https://gist.github.com/HanSeo0507/283111ed13d4ccb2b50778ddd2a30c92
  value = tonumber(value)
  percent = tonumber(percent)
  return value * (percent/100)
end

function Utils:round(num, dp)
    --[[
    round a number to so-many decimal of places, which can be negative, 
    e.g. -1 places rounds to 10's,  
    
    examples
        173.2562 rounded to 0 dps is 173.0
        173.2562 rounded to 2 dps is 173.26
        173.2562 rounded to -1 dps is 170.0
    ]]--
    local mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end

function Utils:getScaling(drawable,canvas) -- https://love2d.org/forums/viewtopic.php?t=84025
	local canvas = canvas or nil

	local drawW = drawable:getWidth()
	local drawH = drawable:getHeight()

	local canvasW = 0
	local canvasH = 0
		
	if canvas then
		canvasW = canvas:getWidth()
		canvasH = canvas:getHeight()
	else
		canvasW = love.graphics.getWidth()
		canvasH = love.graphics.getHeight()
	end

	local scaleX = canvasW / drawW
	local scaleY = canvasH / drawH

	return scaleX, scaleY
end

return Utils