local Timer = require "lib.hump.timer"
local Gamestate = require "lib.hump.gamestate"
local nativefs = require "lib.nativefs.nativefs"
local imgui = require "imgui"
local Bitwise = require "lib.bitwise"
local Utils = require "lib.utils"
local Draw = require "lib.draw"
local Split = require "lib.split"

local Hitcircle = require "hitcircle"
local Beatmap = require "beatmap"
local Skin = require "skin"
local Slider = require "slider"

local beatmapPath = ""
local beatmapName = ""
local currentDir = "Songs/"
local skinPath = "Skins/"

local skinName = "Default"

local hitcircles = {}
local sliders = {}

local timer = 0

local mapselect = {}
local map = {}
local finish = {}

local customARValue = -100
local customARRange = { -100, 50 }
local customAR = false 

local customCSValue = -100
local customCSRange = { -100, 12.2 }
local customCS = false 

local customODValue = -100
local customODRange = { -15, 15 }
local customOD = false

local customSpeedValue = 0
local customSpeedRange = {0, 10}
local customSpeed = false

local skip = false

local mods = {"doubletime", "nightcore", "halftime", "hardrock", "hidden", "flashlight", "autoplay", "relax", "autopilot", "easy", "nofail", "crazy"}

local doubletime = false
local halftime = false

local sampleset = 0
local hitnormal  = 0
local hitwhistle = 2
local hitfinish  = 4
local hitclap    = 8

local r = 0

local isKeyPressed = false
local isMousePressed = false

local score300 = 0
local score100 = 0
local score50 = 0
local scoreMiss = 0

local score300p = 0
local score100p = 0
local score50p = 0
local scoreMissp = 0

local score = 0
local scoreCombo = 1

local accuracy = 1

local drainTime = 0

local diffMulti = 0

local mapBG = nil

local hitobjLeft = 0

local config = {skin = 'Default', bgDim = 0.2, firstKey = 'z', secondKey = 'x'}

function flush()
  beatmap = nil
  
  beatmapTimingPointData = nil
  beatmapBPM = nil
  beatmapMetadata = nil
  beatmapGeneral = nil
  beatmapDifficulty = nil
  hitobjectdata = nil
  hitobjects = nil
  events = nil
  
  hp = 0
  cs = 0
  od = 0
  ar = 0
  
  bpm = 0
  currentBPM = 0
  currentBeatLength = 0
  
  beatmapEnd = false
  
  love.window.setTitle('Xact')
  
  currentHitobject = 2
  currentHCircleCombo = 1
  
  currentDir = "Songs/"
  
  timer = nil
  
  hitcircles = {}
  sliders = {}
  
  customAR = false
  customCS = false
  customOD = false
  customSpeed = false
  
  customARValue = -100
  customCSValue = -100
  customODValue = -100
  customSpeedValue = 0
  
  skip = false
  
  --mods.doubletime = false
  --mods.halftime = false
  mods.autoplay = false
  --mods.relax = false
  --mods.easy = false
  --mods.hardrock = false
  mods.crazy = false
  
  score300 = 0
  score100 = 0
  score50 = 0
  scoreMiss = 0
  
  score300p = 0
  score100p = 0
  score50p = 0
  scoreMissp = 0
  
  score = 0
  scoreCombo = 1
  
  accuracy = 1
  
  drainTime = 0
  
  diffMulti = 0
  
  mapBG = nil
  
  hitobjLeft = 0
  
  love.audio.stop()
end

function mapselect:enter()  
  flush()
  if not nativefs.getInfo('config.cfg') then
		local file = nativefs.newFile('config.cfg')
    file:open('w')
    file:write('skin='..config.skin..'\r\n')
    file:write('bgDim='..config.bgDim..'\r\n')
    file:write('firstKey='..config.firstKey..'\r\n')
    file:write('secondKey='..config.secondKey..'\r\n')
    file:close()
	end
  
  for line in nativefs.lines('config.cfg') do
    local splitted = Split(line, '=')
    config[splitted[1]] = splitted[2]
  end
  
  skinName = config.skin
  skin = Skin:create(skinPath, skinName)
  skin:load()
  
  --print(Utils:calculateAccuracy(0, 0, 1000000000000000, 1))
  --print(Utils:calculateDifficultyMulti(7, 7, 10, 1000, 120))
end

function mapselect:draw()   
  imgui.Begin("Skins")
  imgui.Text("Current selected skin: "..skinName)
  for k, v in ipairs(love.filesystem.getDirectoryItems(skinPath)) do
    if imgui.Selectable(v) then
      local file = love.filesystem.newFileData(currentDir..'/'..v)
      if love.filesystem.getInfo(skinPath..'/'..v..'/').type == 'directory' then
        skinName = v
        skin = Skin:create(skinPath, skinName)
        skin:load()
        
        local file = nativefs.newFile('config.cfg')
        file:open('w')
        file:write('skin='..skinName..'\r\n')
        file:write('bgDim='..config.bgDim..'\r\n')
        file:write('firstKey='..config.firstKey..'\r\n')
        file:write('secondKey='..config.secondKey..'\r\n')
        file:close()
      end
    end
  end
  imgui.End()
  
  imgui.Begin("Custom difficulty")
  
  if imgui.BeginMenuBar() then
    imgui.EndMenuBar();
  end
  
  customARValue = imgui.SliderFloat("Custom AR", customARValue, unpack(customARRange));
  customAR = imgui.Checkbox("Use custom AR", customAR)
  customCSValue = imgui.SliderFloat("Custom CS", customCSValue, unpack(customCSRange));
  customCS = imgui.Checkbox("Use custom CS", customCS)
  customODValue = imgui.SliderFloat("Custom OD", customODValue, unpack(customODRange));
  customOD = imgui.Checkbox("Use custom OD", customOD)
  
  customSpeedValue = imgui.SliderFloat("Beatmap speed", customSpeedValue, unpack(customSpeedRange));
  mods.doubletime = imgui.Checkbox("DoubleTime", mods.doubletime)
  mods.halftime = imgui.Checkbox("HalfTime", mods.halftime)
  
  mods.autoplay = imgui.Checkbox("Autoplay", mods.autoplay)
  mods.relax = imgui.Checkbox("Relax", mods.relax)
  mods.easy = imgui.Checkbox("Easy", mods.easy)
  mods.hardrock = imgui.Checkbox("Hardrock", mods.hardrock)
  mods.crazy = imgui.Checkbox("Shear", mods.crazy)
  
  if mods.doubletime then 
    customSpeedValue = 1.5 
    customSpeed = true
    mods.halftime = false
  elseif mods.halftime then
    customSpeedValue = 0.5
    customSpeed = true
    mods.doubletime = false
  else
    customSpeed = false
  end
  
  if mods.autoplay then
    mods.relax = false
  elseif mods.relax then
    mods.autoplay = false
  end
  
  imgui.End()
  
  imgui.Begin("Select beatmap file")
  if imgui.BeginMenuBar() then
    imgui.EndMenuBar();
  end
  
  if currentDir ~= "Songs/" then
    if imgui.Button("Back") then
      currentDir = "Songs/"
    end
  end
  
  for k, v in ipairs(love.filesystem.getDirectoryItems(currentDir)) do
    if imgui.Selectable(v) then
      local file = love.filesystem.newFileData(currentDir..'/'..v)
      if love.filesystem.getInfo(currentDir..'/'..v..'/').type == 'directory' then
        currentDir = currentDir..v
      elseif file:getExtension() == 'osu' then
        beatmapPath = currentDir..'/'..v
        if customAR then
          ar = customARValue
        end
        if customCS then
          cs = customCSValue
        end
        if customOD then
          od = customODValue
        end
        
        if customSpeedValue ~= 0 then
          customSpeed = true
        end
        
        Gamestate.switch(map)
      end
    end
  end
  imgui.End()
  love.graphics.clear(0.2, 0.2, 0.2)
  imgui.Render()
end

function mapselect:update(dt)
  imgui.NewFrame()
  --if love.keyboard.isDown('escape') then love.event.quit() end
end

function map:enter()  
  beatmap = Beatmap:load(beatmapPath)
  
  beatmapTimingPointData = beatmap:GetTimingPointData()
  beatmapBPM = beatmap:GetBPM()
  beatmapMetadata = beatmap:GetMetadata()
  beatmapGeneral = beatmap:GetGeneral()
  beatmapDifficulty = beatmap:GetDifficulty()
  hitobjectdata = beatmap:GetHitobjectData()
  hitobjects = beatmap:GetHitObjects()
  events = beatmap:GetEventData()
  
  hp = beatmapDifficulty[0]
  if not customCS then
    cs = beatmapDifficulty[1]
    if mods.easy then
      cs = cs / 2
    end
    if mods.hardrock then
      cs = cs * 1.3
      if cs > 10 then cs = 10 end
    end
  end
  
  if not customOD then
    od = beatmapDifficulty[2]
    if mods.easy then
      od = od / 2
    end
    if mods.hardrock then
      od = od * 1.4
      if od > 10 then od = 10 end
    end
  end
  
  if not customAR then
    if beatmapDifficulty[3] ~= nil then
      ar = beatmapDifficulty[3]
    else
      ar = 5
    end
    
    if mods.easy then
      ar = ar / 2
    end
    if mods.hardrock then
      ar = ar * 1.4
      if ar > 10 then ar = 10 end
    end
  end
  
  
  bpm = 0
  currentBPM = 0
  currentBeatLength = 0
  
  beatmapEnd = false
  
  local bName, bCreator, bDiff = "", "", ""
  
  if beatmapMetadata[0] ~= nil then
    bName = beatmapMetadata[0]
  else
    bName = "Beatmap"
  end
  
  if beatmapMetadata[2] ~= nil then
    bCreator = beatmapMetadata[2]
  else
    bCreator = "Creator"
  end
  
  if beatmapMetadata[3] ~= nil then
    bDiff = beatmapMetadata[3]
  else
    bDiff = "Difficulty"
  end
  
  love.window.setTitle('Xact - '..bName.." ("..bCreator..")".." ["..bDiff.."]")
  
  currentHitobject = 2
  currentHCircleCombo = 1
  
  for k = 2, #hitobjects do
    if (Bitwise:band(tonumber(hitobjectdata[k].type), 1)) > 0 then
      table.insert(hitcircles, Hitcircle:create((tonumber(hitobjectdata[k].x) * osupixel['xMulti']), (tonumber(hitobjectdata[k].y) * osupixel['yMulti']), currentHCircleCombo, {0.4, 0.5, 0.2}, k, tonumber(hitobjectdata[k].time), tonumber(hitobjectdata[k].hitSound)))
    elseif (Bitwise:band(tonumber(hitobjectdata[k].type), 2)) > 0 then
      --print(unpack(hitobjectdata[k].curvePoints))
      table.insert(sliders, Slider:create({0.4, 0.5, 0.2}, hitobjectdata[k].curveType, k, hitobjectdata[k].length, hitobjectdata[k].slides, tonumber(hitobjectdata[k].time), hitobjectdata[k].edgeSounds, (tonumber(hitobjectdata[k].x) * osupixel['xMulti']), (tonumber(hitobjectdata[k].y) * osupixel['yMulti']), unpack(hitobjectdata[k].curvePoints)))
    end
  end
  
  totalHitcircles, totalSliders = #hitcircles, #sliders
  
  if customSpeed then
    drainTime = tonumber(hitobjectdata[#hitobjectdata].time / customSpeedValue)
  else
    drainTime = tonumber(hitobjectdata[#hitobjectdata].time)
  end
  
  diffMulti = Utils:calculateDifficultyMulti(hp, cs, od, #hitobjectdata, drainTime / 1000)
  
  audioFile = love.audio.newSource(currentDir..'/'..beatmapGeneral[0], 'stream')
  
  if customSpeed then
    audioFile:setPitch(customSpeedValue)
  end
  love.audio.play(audioFile)
  
  r = 54.4 - 4.48 * cs -- https://osu.ppy.sh/wiki/en/Beatmapping/Circle_size
  normalizedCS = Utils:normalize(r, 0, 58)
  
  if beatmapGeneral[4] == 'Normal' then 
    sampleset = 1
  elseif beatmapGeneral[4] == 'Soft' then
    sampleset = 2
  elseif beatmapGeneral[4] == 'Drum' then
    sampleset = 3
  else
    sampleset = 1
  end
  
  if pcall(function() mapBG = love.graphics.newImage(currentDir..'/'..events.bg) end) then
    mapBG = love.graphics.newImage(currentDir..'/'..events.bg)
    bgSX, bgSY = Utils:getScaling(mapBG)
  else
    mapBG = nil
  end
end

function map:update(dt)
  if customSpeed then
    timer = timer and timer + dt * customSpeedValue or 0
  else
    timer = timer and timer + dt or 0
  end

  score50p = 100 * score50 / (score300 + score100 + score50 + scoreMiss)
  score100p = 100 * score100 / (score300 + score100 + score50 + scoreMiss)
  score300p = 100 * score300 / (score300 + score100 + score50 + scoreMiss)
  scoreMissp = 100 * scoreMiss / (score300 + score100 + score50 + scoreMiss)
  
  accuracy = Utils:calculateAccuracy(score50, score100, score300, scoreMiss)
  
  mouseX, mouseY = love.mouse.getPosition()
  love.mouse.setVisible(false)
  
  if #hitcircles == 0 and #sliders == 0 then
    beatmapEnd = true
  end
  
  hitobjLeft = #hitcircles + #sliders
  
  for k = 2, #beatmapTimingPointData do
    if beatmapTimingPointData[k].time ~= nil then
      if (tonumber(beatmapTimingPointData[k].time) / 1000) <= timer then
        currentBeatLength = tonumber(beatmapTimingPointData[k].beatLength)
        if currentBeatLength > 0 then 
          currentBPM = 1 / currentBeatLength * 1000 * 60 
        end
        
        sampleset = tonumber(beatmapTimingPointData[k].sampleSet)
        if sampleset == 0 then
          if beatmapGeneral[4] == 'Normal' then 
            sampleset = 1
          elseif beatmapGeneral[4] == 'Soft' then
            sampleset = 2
          elseif beatmapGeneral[4] == 'Drum' then
            sampleset = 3
          end
        end
      end
    else
      break
    end
  end
  
  if customSpeed then
    currentBPM = currentBPM * customSpeedValue
  end
  
  for k, v in ipairs(hitcircles) do
    if hitobjectdata[currentHitobject] ~= nil then
      if (Bitwise:band(tonumber(hitobjectdata[currentHitobject]['type']), 1)) > 0 then
        if ((hitcircles[k].time - Utils:preempt(ar)) / 1000) <= timer then
          if not v:IsVisible() then
            if (Bitwise:band(tonumber(hitobjectdata[currentHitobject].type), 4)) > 0 then
              currentHCircleCombo = 1
              v:SetCombo(currentHCircleCombo)
            else
              v:SetCombo(currentHCircleCombo)
              currentHCircleCombo = currentHCircleCombo + 1
            end
            
            v:ToggleVisibility()
            currentHitobject = currentHitobject + 1
          end
        end
      elseif (Bitwise:band(tonumber(hitobjectdata[currentHitobject].type), 8)) > 0 then
        currentHitobject = currentHitobject + 1
      end
    end
    if hitcircles[k] ~= nil then
      if v:IsVisible() then 
        v:updateApproach(timer)
        
        if not mods.autoplay and not mods.relax then
          local mouseDist = Utils:hypot((tonumber(hitobjectdata[hitcircles[k]:GetID()].x) * osupixel['xMulti'] + osupixel['xOffset']) - mouseX, (tonumber(hitobjectdata[hitcircles[k]:GetID()].y) * osupixel['yMulti'] + osupixel['yOffset']) - mouseY)
          if mouseDist < r then
            if isKeyPressed or isMousePressed then
              local timeDiff = (timer * 1000) - tonumber(hitcircles[1].time)
              local hitResult = v:getHitResult(timeDiff)
              --print('Hit score: '..hitResult)
              
              if hitResult == 300 then
                score300 = score300 + 1
                score = score + 300 * scoreCombo
                scoreCombo = scoreCombo + 1
              elseif hitResult == 100 then
                score100 = score100 + 1
                score = score + 100 * scoreCombo
                scoreCombo = scoreCombo + 1
              elseif hitResult == 50 then
                score50 = score50 + 1
                score = score + 50 * scoreCombo
                scoreCombo = scoreCombo + 1
              else
                if scoreCombo > 20 then skin.combobreak:stop(); love.audio.play(skin.combobreak) end
                table.remove(hitcircles, 1)
                scoreMiss = scoreMiss + 1
                scoreCombo = 1
              end
              
              isKeyPressed = false
              isMousePressed = false
              --print(#hitcircles)
              if hitResult ~= 0 then
                if sampleset == 1 then -- normal
                  if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                    skin.normal_hitnormal:stop()
                    love.audio.play(skin.normal_hitnormal)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                    skin.normal_hitwhistle:stop()
                    love.audio.play(skin.normal_hitwhistle)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                    skin.normal_hitfinish:stop()
                    love.audio.play(skin.normal_hitfinish)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                    skin.normal_hitclap:stop()
                    love.audio.play(skin.normal_hitclap)
                  else
                    skin.normal_hitnormal:stop()
                    love.audio.play(skin.normal_hitnormal)
                  end
                elseif sampleset == 2 then -- soft
                  if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                    skin.soft_hitnormal:stop()
                    love.audio.play(skin.soft_hitnormal)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                    skin.soft_hitwhistle:stop()
                    love.audio.play(skin.soft_hitwhistle)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                    skin.soft_hitfinish:stop()
                    love.audio.play(skin.soft_hitfinish)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                    skin.soft_hitclap:stop()
                    love.audio.play(skin.soft_hitclap)
                  else
                    skin.soft_hitnormal:stop()
                    love.audio.play(skin.soft_hitnormal)
                  end
                elseif sampleset == 3 then -- drum
                  if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                    skin.drum_hitnormal:stop()
                    love.audio.play(skin.drum_hitnormal)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                    skin.drum_hitwhistle:stop()
                    love.audio.play(skin.drum_hitwhistle)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                    skin.drum_hitfinish:stop()
                    love.audio.play(skin.drum_hitfinish)
                  elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                    skin.drum_hitclap:stop()
                    love.audio.play(skin.drum_hitclap)
                  else
                    skin.drum_hitnormal:stop()
                    love.audio.play(skin.drum_hitnormal)
                  end
                end
                table.remove(hitcircles, 1)
              end
            end
          end
          if #hitcircles ~= 0 then
            if ((hitcircles[1].time + 100) / 1000) <= timer then
              --print('Hit score: 0')
              if scoreCombo > 20 then skin.combobreak:stop(); love.audio.play(skin.combobreak) end
              scoreMiss = scoreMiss + 1
              scoreCombo = 1
              table.remove(hitcircles, 1)
            end
          end
        elseif mods.autoplay then
          if ((hitcircles[1].time) / 1000) <= timer then
            if hitResult ~= 0 then
              if sampleset == 1 then -- normal
                if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                  skin.normal_hitnormal:stop()
                  love.audio.play(skin.normal_hitnormal)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                  skin.normal_hitwhistle:stop()
                  love.audio.play(skin.normal_hitwhistle)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                  skin.normal_hitfinish:stop()
                  love.audio.play(skin.normal_hitfinish)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                  skin.normal_hitclap:stop()
                  love.audio.play(skin.normal_hitclap)
                else
                  skin.normal_hitnormal:stop()
                  love.audio.play(skin.normal_hitnormal)
                end
              elseif sampleset == 2 then -- soft
                if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                  skin.soft_hitnormal:stop()
                  love.audio.play(skin.soft_hitnormal)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                  skin.soft_hitwhistle:stop()
                  love.audio.play(skin.soft_hitwhistle)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                  skin.soft_hitfinish:stop()
                  love.audio.play(skin.soft_hitfinish)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                  skin.soft_hitclap:stop()
                  love.audio.play(skin.soft_hitclap)
                else
                  skin.soft_hitnormal:stop()
                  love.audio.play(skin.soft_hitnormal)
                end
              elseif sampleset == 3 then -- drum
                if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                  skin.drum_hitnormal:stop()
                  love.audio.play(skin.drum_hitnormal)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                  skin.drum_hitwhistle:stop()
                  love.audio.play(skin.drum_hitwhistle)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                  skin.drum_hitfinish:stop()
                  love.audio.play(skin.drum_hitfinish)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                  skin.drum_hitclap:stop()
                  love.audio.play(skin.drum_hitclap)
                else
                  skin.drum_hitnormal:stop()
                  love.audio.play(skin.drum_hitnormal)
                end
              end
            end
            
            --print('Hit score: 300')
            score300 = score300 + 1
            scoreCombo = scoreCombo + 1
            score = score + 300 * scoreCombo
            table.remove(hitcircles, 1)
          end
        end
        if mods.relax then
          local mouseDist = Utils:hypot((tonumber(hitobjectdata[hitcircles[k]:GetID()].x) * osupixel['xMulti'] + osupixel['xOffset']) - mouseX, (tonumber(hitobjectdata[hitcircles[k]:GetID()].y) * osupixel['yMulti'] + osupixel['yOffset']) - mouseY)
          local timeDiff = (timer * 1000) - tonumber(hitcircles[k].time)
          local hitResult = v:getHitResult(timeDiff)
          if mouseDist < r and (hitcircles[1].time / 1000) <= timer or mouseDist < r and ((hitcircles[1].time + (100 - 12 * od)) / 1000) <= timer then
            --print('Hit score: '..hitResult)
            
            if hitResult == 300 then
              score300 = score300 + 1
              scoreCombo = scoreCombo + 1
              score = score + 300 * scoreCombo
            elseif hitResult == 100 then
              score100 = score100 + 1
              scoreCombo = scoreCombo + 1
              score = score + 100 * scoreCombo
            elseif hitResult == 50 then
              score50 = score50 + 1
              scoreCombo = scoreCombo + 1
              score = score + 50 * scoreCombo
            else
              if scoreCombo > 20 then skin.combobreak:stop(); love.audio.play(skin.combobreak) end
              table.remove(hitcircles, 1)
              scoreMiss = scoreMiss + 1
              scoreCombo = 1
            end
            
            if hitResult ~= 0 then
              if sampleset == 1 then -- normal
                if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                  skin.normal_hitnormal:stop()
                  love.audio.play(skin.normal_hitnormal)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                  skin.normal_hitwhistle:stop()
                  love.audio.play(skin.normal_hitwhistle)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                  skin.normal_hitfinish:stop()
                  love.audio.play(skin.normal_hitfinish)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                  skin.normal_hitclap:stop()
                  love.audio.play(skin.normal_hitclap)
                else
                  skin.normal_hitnormal:stop()
                  love.audio.play(skin.normal_hitnormal)
                end
              elseif sampleset == 2 then -- soft
                if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                  skin.soft_hitnormal:stop()
                  love.audio.play(skin.soft_hitnormal)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                  skin.soft_hitwhistle:stop()
                  love.audio.play(skin.soft_hitwhistle)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                  skin.soft_hitfinish:stop()
                  love.audio.play(skin.soft_hitfinish)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                  skin.soft_hitclap:stop()
                  love.audio.play(skin.soft_hitclap)
                else
                  skin.soft_hitnormal:stop()
                  love.audio.play(skin.soft_hitnormal)
                end
              elseif sampleset == 3 then -- drum
                if (Bitwise:band(hitcircles[1].hitSound, hitnormal)) > 0 then
                  skin.drum_hitnormal:stop()
                  love.audio.play(skin.drum_hitnormal)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitwhistle)) > 0 then
                  skin.drum_hitwhistle:stop()
                  love.audio.play(skin.drum_hitwhistle)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitfinish)) > 0 then
                  skin.drum_hitfinish:stop()
                  love.audio.play(skin.drum_hitfinish)
                elseif (Bitwise:band(hitcircles[1].hitSound, hitclap)) > 0 then
                  skin.drum_hitclap:stop()
                  love.audio.play(skin.drum_hitclap)
                else
                  skin.drum_hitnormal:stop()
                  love.audio.play(skin.drum_hitnormal)
                end
                end
              table.remove(hitcircles, 1)
            end
          end
        end
        if #hitcircles ~= 0 then
          if ((hitcircles[1].time + 100) / 1000) <= timer then
            --print('Hit score: 0')
            if scoreCombo > 20 then skin.combobreak:stop(); love.audio.play(skin.combobreak) end
            scoreMiss = scoreMiss + 1
            scoreCombo = 1
            table.remove(hitcircles, 1)
          end
        end
      end
    end
  end
  
  for k, v in ipairs(sliders) do
    if hitobjectdata[currentHitobject] ~= nil then
      if (Bitwise:band(tonumber(hitobjectdata[currentHitobject]['type']), 2)) > 0 then
        if ((sliders[k].time - Utils:preempt(ar)) / 1000) <= timer then
          if not(v:IsVisible()) then
            if (Bitwise:band(tonumber(hitobjectdata[currentHitobject].type), 4)) > 0 then
              currentHCircleCombo = 1
              v:SetCombo(currentHCircleCombo)
            else
              v:SetCombo(currentHCircleCombo)
              currentHCircleCombo = currentHCircleCombo + 1
            end
            
            v:ToggleVisibility()
            currentHitobject = currentHitobject + 1
          end
        end
      elseif (Bitwise:band(tonumber(hitobjectdata[currentHitobject].type), 8)) > 0 then
        currentHitobject = currentHitobject + 1
      end
    end
    
    if sliders[k] ~= nil then
      v:setTimer(timer)
      if v:IsVisible() then v:updateApproach(timer) end
      if v:IsSliderBall() then v:SliderBallUpdate(dt, tonumber(sliders[k].length)) end
      
      if (sliders[k].time / 1000) <= timer then
        if skip == false and sliders[k].edgeSounds[1] ~= nil then
          if sampleset == 1 then
            if (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitnormal)) > 0 then
              skin.normal_hitnormal:stop()
              love.audio.play(skin.normal_hitnormal)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitwhistle)) > 0 then
              skin.normal_hitwhistle:stop()
              love.audio.play(skin.normal_hitwhistle)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitfinish)) > 0 then
              skin.normal_hitfinish:stop()
              love.audio.play(skin.normal_hitfinish)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitclap)) > 0 then
              skin.normal_hitclap:stop()
              love.audio.play(skin.normal_hitclap)
            end
          elseif sampleset == 2 then
            if (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitnormal)) > 0 then
              skin.soft_hitnormal:stop()
              love.audio.play(skin.soft_hitnormal)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitwhistle)) > 0 then
              skin.soft_hitwhistle:stop()
              love.audio.play(skin.soft_hitwhistle)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitfinish)) > 0 then
              skin.soft_hitfinish:stop()
              love.audio.play(skin.soft_hitfinish)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitclap)) > 0 then
              skin.soft_hitclap:stop()
              love.audio.play(skin.soft_hitclap)
            end
          elseif sampleset == 3 then
            if (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitnormal)) > 0 then
              skin.drum_hitnormal:stop()
              love.audio.play(skin.drum_hitnormal)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitwhistle)) > 0 then
              skin.drum_hitwhistle:stop()
              love.audio.play(skin.drum_hitwhistle)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitfinish)) > 0 then
              skin.drum_hitfinish:stop()
              love.audio.play(skin.drum_hitfinish)
            elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[1]), hitclap)) > 0 then
              skin.drum_hitclap:stop()
              love.audio.play(skin.drum_hitclap)
            end
          end
          skip = true
        elseif skip == false then
          skin.normal_hitnormal:stop()
          love.audio.play(skin.normal_hitnormal)
          skip = true
        end
        
        if not sliders[k]:IsSliderBall() then
          sliders[k]:ToggleSliderBall()
        end
        
        if ((sliders[k].time + math.abs(sliders[k]:GetSliderTime(currentBeatLength) * sliders[k].slides)) / 1000) <= timer then
          skip = false
          if sliders[k].edgeSounds[#sliders[k].edgeSounds] ~= nil then
            if sampleset == 1 then
              if (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitnormal)) > 0 then
                skin.normal_hitnormal:stop()
                love.audio.play(skin.normal_hitnormal)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitwhistle)) > 0 then
                skin.normal_hitwhistle:stop()
                love.audio.play(skin.normal_hitwhistle)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitfinish)) > 0 then
                skin.normal_hitfinish:stop()
                love.audio.play(skin.normal_hitfinish)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitclap)) > 0 then
                skin.normal_hitclap:stop()
                love.audio.play(skin.normal_hitclap)
              end
            elseif sampleset == 2 then
              if (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitnormal)) > 0 then
                skin.soft_hitnormal:stop()
                love.audio.play(skin.soft_hitnormal)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitwhistle)) > 0 then
                skin.soft_hitwhistle:stop()
                love.audio.play(skin.soft_hitwhistle)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitfinish)) > 0 then
                skin.soft_hitfinish:stop()
                love.audio.play(skin.soft_hitfinish)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitclap)) > 0 then
                skin.soft_hitclap:stop()
                love.audio.play(skin.soft_hitclap)
              end
            elseif sampleset == 3 then
              if (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitnormal)) > 0 then
                skin.drum_hitnormal:stop()
                love.audio.play(skin.drum_hitnormal)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitwhistle)) > 0 then
                skin.drum_hitwhistle:stop()
                love.audio.play(skin.drum_hitwhistle)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitfinish)) > 0 then
                skin.drum_hitfinish:stop()
                love.audio.play(skin.drum_hitfinish)
              elseif (Bitwise:band(tonumber(sliders[k].edgeSounds[#sliders[k].edgeSounds]), hitclap)) > 0 then
                skin.drum_hitclap:stop()
                love.audio.play(skin.drum_hitclap)
              end
            end
          end
          table.remove(sliders, 1)
        end
      end
    end
  end
  --[[
  if (Bitwise:band(tonumber(hitobjectdata[currentHitobject].type), 1)) > 0 then -- hitcircle
    if ((hitobjectdata[currentHitobject].time - Utils:preempt(ar)) / 1000) <= timer then
      if not(hitcircles[currentHitobject]:IsVisible()) then
        if (Bitwise:band(tonumber(hitobjectdata[currentHitobject].type), 4)) > 0 then -- newcombo
          currentHCircleCombo = 1
          hitcircles[currentHitobject]:SetCombo(currentHCircleCombo)
        else
          hitcircles[currentHitobject]:SetCombo(currentHCircleCombo)
          currentHCircleCombo = currentHCircleCombo + 1
        end
        
        hitcircles[currentHitobject]:ToggleVisibility()
        currentHitobject = currentHitobject + 1
      end
    end
  elseif (Bitwise:band(tonumber(hitobjectdata[currentHitobject].type), 2)) > 0 then -- slider
    if ((hitobjectdata[currentHitobject].time - Utils:preempt(ar)) / 1000) <= timer then
      if not(sliders[currentHitobject]:IsVisible()) then
        sliders[currentHitobject]:ToggleVisibility()
        currentHitobject = currentHitobject + 1
      end
    end
  end
  
  for k, v in ipairs(hitcircles) do
     if v:IsVisible() then
      v:update(dt, timer)
    end
      
    if hitcircles[k] ~= nil then
      if (hitobjectdata[hitcircles[k]:GetID()].time / 1000) <= timer then
        table.remove(hitcircles, 1)
      end
    end
  end
  
  for k, v in ipairs(sliders) do
    if v:IsVisible() then v:update(dt) end
      
    if sliders[k] ~= nil then
      if ((hitobjectdata[sliders[k]:GetID()].time + (v:GetSliderTime((currentBeatLength * -1), hitobjectdata[sliders[k]:GetID()].length) * hitobjectdata[sliders[k]:GetID()].slides)) / 1000) <= timer then
        table.remove(sliders, 1)
      end
    end
  end
  --]]
  
  if love.keyboard.isDown('escape') then Gamestate.switch(mapselect) end
end

function map:draw()
  if mapBG ~= nil then
    love.graphics.setColor(1, 1, 1, config.bgDim) -- 0.2 = 80% dim
    love.graphics.draw(mapBG, 0, 0, 0, bgSX, bgSY)
    love.graphics.setColor(1, 1, 1, 1)
  end
  
  love.graphics.translate(osupixel['xOffset'], osupixel['yOffset'])
  
  if mods.crazy then
    local t = love.timer.getTime()
    love.graphics.shear(math.cos(t), math.cos(t * 1.3))
  end
  
  for k = 1, #sliders do
    if sliders[#sliders + 1 - k]:IsVisible() then sliders[#sliders + 1 - k]:draw() end
    if sliders[#sliders + 1 - k]:IsSliderBall() then sliders[#sliders + 1 - k]:drawSliderBall() end
    --sliders[#sliders + 1 - k]:draw()
  end
  
  for k = 1, #hitcircles do
      if hitcircles[#hitcircles + 1 - k]:IsVisible() then hitcircles[#hitcircles + 1 - k]:draw() end
      --hitcircles[#hitcircles + 1 - k]:draw()
  end
  --[[
  for k = 2, #hitobjects do
    if (Bitwise:band(tonumber(hitobjectdata[k].type), 1)) > 0 then
      if hitcircles[#hitcircles + 1 - k]:IsVisible() then hitcircles[#hitcircles + 1 - k]:draw() end
    elseif (Bitwise:band(tonumber(hitobjectdata[k].type), 2)) > 0 then
      if sliders[#sliders + 1 - k]:IsVisible() then sliders[#sliders + 1 - k]:draw() end
      if sliders[#sliders + 1 - k]:IsSliderBall() then sliders[#sliders + 1 - k]:drawSliderBall() end
    end
  end--]]
  love.graphics.origin()
  --love.graphics.circle('fill', testx, testy, r)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("HP: "..tostring(Utils:round(hp, 1)), 10, 35)
  love.graphics.print("CS: "..tostring(Utils:round(cs, 1)), 10, 50)
  love.graphics.print("OD: "..tostring(Utils:round(od, 1)), 10, 65)
  love.graphics.print("AR: "..tostring(Utils:round(ar, 1)), 10, 80)
  love.graphics.print("BPM: "..tostring(bpm), 10, 95)
  love.graphics.print("Current BPM: "..tostring(Utils:round(currentBPM, 2)), 10, 110)
  
  love.graphics.print("Hitcircles: "..tostring(#hitcircles).." / "..tostring(totalHitcircles), 10, 125)
  love.graphics.print("Sliders: "..tostring(#sliders).." / "..tostring(totalSliders), 10, 140)
  love.graphics.print("Total hitobjects: "..tostring(#hitobjects), 10, 155)
  if customSpeed then
    love.graphics.print("Time: "..math.floor(tostring(timer / customSpeedValue))..' - '..math.floor(tostring(drainTime / 1000)), 10, 170)
  else
    love.graphics.print("Time: "..math.floor(tostring(timer))..' - '..math.floor(tostring(drainTime / 1000)), 10, 170)
  end
  --love.graphics.print("Difficulty multiplier: "..tostring(diffMulti), 10, 215)
  
  love.graphics.print("300's: "..tostring(score300)..' / '..tostring(Utils:round(score300p, 1))..'%', 10, 230)
  love.graphics.print("100's: "..tostring(score100)..' / '..tostring(Utils:round(score100p, 1))..'%', 10, 245)
  love.graphics.print("50's: "..tostring(score50)..' / '..tostring(Utils:round(score50p, 1))..'%', 10, 260)
  love.graphics.print("Misses: "..tostring(scoreMiss)..' / '..tostring(Utils:round(scoreMissp, 1))..'%', 10, 275)
  love.graphics.print("Score: "..tostring(score), 10, 290)
  love.graphics.print("Combo: "..tostring(scoreCombo)..'x', 10, 305)
  love.graphics.print("Accuracy: "..tostring((Utils:round(accuracy, 4) * 100))..'%', 10, 320)
  
  if accuracy == 1 then
    love.graphics.print("Rank: SS", 10, 335)
  elseif score300p > 90 and score50p < 1 and scoreMissp == 0 then
    love.graphics.print("Rank: S", 10, 335)
  elseif score300p > 80 and scoreMissp == 0 or score300p > 90 then
    love.graphics.print("Rank: A", 10, 335)
  elseif score300p > 70 and scoreMissp == 0 or score300p > 80 then
    love.graphics.print("Rank: B", 10, 335)
  elseif score300p > 60 then
    love.graphics.print("Rank: C", 10, 335)
  else
    love.graphics.print("Rank: D", 10, 335)
  end
  
  if beatmapEnd then
    love.graphics.print("Beatmap ended!\nPress ESC to return to beatmap selection menu", winW / 2.5, winH / 2.5, 0, 1.2, 1.2)    
  end	
  
  --love.graphics.draw(cursor, mouseX, mouseY, cursorAngle, 1, 1, cursor:getWidth() / 2, cursor:getHeight() / 2)
  --love.graphics.draw(cursormiddle, mouseX, mouseY, 0, 1, 1, cursormiddle:getWidth() / 2, cursormiddle:getHeight() / 2)
  
  Draw(skin.cursor, mouseX, mouseY, 1, cursorAngle)
  if skin.cursormiddle ~= 0 then Draw(skin.cursormiddle, mouseX, mouseY, 1, 0) end
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  winH = love.graphics.getHeight()
  winW = love.graphics.getWidth()
  osupixel = Utils:getOsuPixelData(winW, winH)
  
  skin = Skin:create(skinPath, skinName)
  skin:load()
  
  cursorAngle = 0
  
  Gamestate.registerEvents()
  Gamestate.switch(mapselect)
end

function love.update(dt) 
  
  --timer = 1000000000
  
  --[[
  --if hitobjectdata[currentHitcircle] == nil or hitcircles[currentHitcircle] == nil then
    --beatmapEnd = true
  --else
    --print(hitobjectdata[currentHitcircle].time)
    print((tonumber(hitobjectdata[currentHitcircle].time) / 1000)..' | '..timer)
    --if (tonumber(hitobjectdata[currentHitcircle].time) / 1000) < (timer) then
      print(hitcircles[currentHitcircle])
      hitcircles[currentHitcircle]:ToggleVisibility() 
      if tonumber(hitobjectdata[currentHitcircle].type) == 2 or tonumber(hitobjectdata[currentHitcircle].type) >= 4 then 
        --print("New combo Type: "..tostring(hitobjectdata[currentHitcircle].type))
        currentHCircleCombo = 1
        hitcircles[currentHitcircle]:SetCombo(currentHCircleCombo)
      else
        hitcircles[currentHitcircle]:SetCombo(currentHCircleCombo)
        currentHCircleCombo = currentHCircleCombo + 1
      end
      --print("Hitobject: "..(currentHitcircle - 2).." Time: "..tostring(hitobjectdata[currentHitcircle].time))
      --print(hitcircles[currentHitcircle]:GetApproachTime())
      currentHitcircle = currentHitcircle + 1
    --end
  --end
  --]]
  
  
  
  --cursorAngle = cursorAngle + dt * math.pi / 2
  --cursorAngle = cursorAngle % (2 * math.pi)
  
  
end

function love.draw()  
  
end

function love.textinput(t)
    imgui.TextInput(t)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.keypressed(key)
    imgui.KeyPressed(key)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
    
    if key == config.firstKey or key == config.secondKey then
      isKeyPressed = true
    end
end

function love.keyreleased(key)
    imgui.KeyReleased(key)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
    
    if key == config.firstKey or key == config.secondKey then
      isKeyPressed = false
    end
end

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousepressed(x, y, button)
    imgui.MousePressed(button)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
    
    if button == 1 or button == 2 then
      isMousePressed = true
    end
end

function love.mousereleased(x, y, button)
    imgui.MouseReleased(button)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
    
    if button == 1 or button == 2 then
      isMousePressed = false
    end
end

function love.wheelmoved(x, y)
    imgui.WheelMoved(y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end