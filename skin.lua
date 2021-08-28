local parser = require "lib.LIP.LIP"

local Skin = {}

function Skin:create(path, name)
  local skin = {}
  --local skinini = parser.load(path..name.."/skin.ini")
  skin['HitCircleOverlap'] = 3
  
  function skin:load()
    if pcall(function() love.graphics.newImage(path..name.."/hitcircle@2x.png") end) then
      skin["hitcircle"] = love.graphics.newImage(path..name.."/hitcircle@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/hitcircle.png") end) then
        skin["hitcircle"] = love.graphics.newImage(path..name.."/hitcircle.png")
      else
        skin["hitcircle"] = love.graphics.newImage(path.."Default/hitcircle.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/hitcircleoverlay@2x.png") end) then
      skin["hitcircleoverlay"] = love.graphics.newImage(path..name.."/hitcircleoverlay@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/hitcircleoverlay.png") end) then
        skin["hitcircleoverlay"] = love.graphics.newImage(path..name.."/hitcircleoverlay.png")
      else
        skin["hitcircleoverlay"] = love.graphics.newImage(path.."Default/hitcircleoverlay.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/approachcircle@2x.png") end) then
      skin["approachcircle"] = love.graphics.newImage(path..name.."/approachcircle@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/approachcircle.png") end) then
        skin["approachcircle"] = love.graphics.newImage(path..name.."/approachcircle.png")
      else
        skin["approachcircle"] = love.graphics.newImage(path.."Default/approachcircle.png")
      end
    end
    
    if pcall(function() love.graphics.newImage(path..name.."/default-1@2x.png") end) then
      skin["default_1"] = love.graphics.newImage(path..name.."/default-1@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-1.png") end) then
        skin["default_1"] = love.graphics.newImage(path..name.."/default-1.png")
      else
        skin["default_1"] = love.graphics.newImage(path.."Default/default-1.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-2@2x.png") end) then
      skin["default_2"] = love.graphics.newImage(path..name.."/default-2@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-2.png") end) then
        skin["default_2"] = love.graphics.newImage(path..name.."/default-2.png")
      else
        skin["default_2"] = love.graphics.newImage(path.."Default/default-2.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-3@2x.png") end) then
      skin["default_3"] = love.graphics.newImage(path..name.."/default-3@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-3.png") end) then
        skin["default_3"] = love.graphics.newImage(path..name.."/default-3.png")
      else
        skin["default_3"] = love.graphics.newImage(path.."Default/default-3.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-4@2x.png") end) then
      skin["default_4"] = love.graphics.newImage(path..name.."/default-4@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-4.png") end) then
        skin["default_4"] = love.graphics.newImage(path..name.."/default-4.png")
      else
        skin["default_4"] = love.graphics.newImage(path.."Default/default-4.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-5@2x.png") end) then
      skin["default_5"] = love.graphics.newImage(path..name.."/default-5@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-5.png") end) then
        skin["default_5"] = love.graphics.newImage(path..name.."/default-5.png")
      else
        skin["default_5"] = love.graphics.newImage(path.."Default/default-5.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-6@2x.png") end) then
      skin["default_6"] = love.graphics.newImage(path..name.."/default-6@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-6.png") end) then
        skin["default_6"] = love.graphics.newImage(path..name.."/default-6.png")
      else
        skin["default_6"] = love.graphics.newImage(path.."Default/default-6.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-7@2x.png") end) then
      skin["default_7"] = love.graphics.newImage(path..name.."/default-7@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-7.png") end) then
        skin["default_7"] = love.graphics.newImage(path..name.."/default-7.png")
      else
        skin["default_7"] = love.graphics.newImage(path.."Default/default-7.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-8@2x.png") end) then
      skin["default_8"] = love.graphics.newImage(path..name.."/default-8@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-8.png") end) then
        skin["default_8"] = love.graphics.newImage(path..name.."/default-8.png")
      else
        skin["default_8"] = love.graphics.newImage(path.."Default/default-8.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-9@2x.png") end) then
      skin["default_9"] = love.graphics.newImage(path..name.."/default-9@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-9.png") end) then
        skin["default_9"] = love.graphics.newImage(path..name.."/default-9.png")
      else
        skin["default_9"] = love.graphics.newImage(path.."Default/default-9.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-0@2x.png") end) then
      skin["default_0"] = love.graphics.newImage(path..name.."/default-0@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-0.png") end) then
        skin["default_0"] = love.graphics.newImage(path..name.."/default-0.png")
      else
        skin["default_0"] = love.graphics.newImage(path.."Default/default-0.png")
      end
    end
    --[[
    if pcall(function() love.graphics.newImage(path..name.."/default-comma@2x.png") end) then
      skin["default_comma"] = love.graphics.newImage(path..name.."/default-comma@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-comma.png") end) then
        skin["default_comma"] = love.graphics.newImage(path..name.."/default-comma.png")
      else
        skin["default_comma"] = love.graphics.newImage(path.."Default/default-comma.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-dot@2x.png") end) then
      skin["default_dot"] = love.graphics.newImage(path..name.."/default-dot@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-dot.png") end) then
        skin["default_dot"] = love.graphics.newImage(path..name.."/default-dot.png")
      else
        skin["default_dot"] = love.graphics.newImage(path.."Default/default-dot.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-percent@2x.png") end) then
      skin["default_percent"] = love.graphics.newImage(path..name.."/default-percent@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-precent.png") end) then
        skin["default_percent"] = love.graphics.newImage(path..name.."/default-percent.png")
      else
        skin["default_percent"] = love.graphics.newImage(path.."Default/default-percent.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/default-x@2x.png") end) then
      skin["default_x"] = love.graphics.newImage(path..name.."/default-x@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/default-x.png") end) then
        skin["default_x"] = love.graphics.newImage(path..name.."/default-x.png")
      else
        skin["default_x"] = love.graphics.newImage(path.."Default/default-x.png")
      end
    end--]]
    --[[
    skin["hit0"] = love.graphics.newImage(path..name.."/hit0.png")
    skin["hit50"] = love.graphics.newImage(path..name.."/hit50.png")
    skin["hit100"] = love.graphics.newImage(path..name.."/hit100.png")
    skin["hit100k"] = love.graphics.newImage(path..name.."/hit100k.png")
    skin["hit300"] = love.graphics.newImage(path..name.."/hit300.png")
    skin["hit300g"] = love.graphics.newImage(path..name.."/hit300g.png")
    skin["hit300k"] = love.graphics.newImage(path..name.."/hit300k.png")
    --]]
    
    if pcall(function() love.graphics.newImage(path..name.."/score-0@2x.png") end) then
      skin["score_0"] = love.graphics.newImage(path..name.."/score-0@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-0.png") end) then
        skin["score_0"] = love.graphics.newImage(path..name.."/score-0.png")
      else
        skin["score_0"] = love.graphics.newImage(path.."Default/score-0.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-1@2x.png") end) then
      skin["score_1"] = love.graphics.newImage(path..name.."/score-1@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-1.png") end) then
        skin["score_1"] = love.graphics.newImage(path..name.."/score-1.png")
      else
        skin["score_1"] = love.graphics.newImage(path.."Default/score-1.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-2@2x.png") end) then
      skin["score_2"] = love.graphics.newImage(path..name.."/score-2@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-2.png") end) then
        skin["score_2"] = love.graphics.newImage(path..name.."/score-2.png")
      else
        skin["score_2"] = love.graphics.newImage(path.."Default/score-2.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-3@2x.png") end) then
      skin["score_3"] = love.graphics.newImage(path..name.."/score-3@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-3.png") end) then
        skin["score_3"] = love.graphics.newImage(path..name.."/score-3.png")
      else
        skin["score_3"] = love.graphics.newImage(path.."Default/score-3.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-4@2x.png") end) then
      skin["score_4"] = love.graphics.newImage(path..name.."/score-4@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-4.png") end) then
        skin["score_4"] = love.graphics.newImage(path..name.."/score-4.png")
      else
        skin["score_4"] = love.graphics.newImage(path.."Default/score-4.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-5@2x.png") end) then
      skin["score_5"] = love.graphics.newImage(path..name.."/score-5@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-5.png") end) then
        skin["score_5"] = love.graphics.newImage(path..name.."/score-5.png")
      else
        skin["score_5"] = love.graphics.newImage(path.."Default/score-5.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-6@2x.png") end) then
      skin["score_6"] = love.graphics.newImage(path..name.."/score-6@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-6.png") end) then
        skin["score_6"] = love.graphics.newImage(path..name.."/score-6.png")
      else
        skin["score_6"] = love.graphics.newImage(path.."Default/score-6.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-7@2x.png") end) then
      skin["score_7"] = love.graphics.newImage(path..name.."/score-7@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-7.png") end) then
        skin["score_7"] = love.graphics.newImage(path..name.."/score-7.png")
      else
        skin["score_7"] = love.graphics.newImage(path.."Default/score-7.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-8@2x.png") end) then
      skin["score_8"] = love.graphics.newImage(path..name.."/score-8@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-8.png") end) then
        skin["score_8"] = love.graphics.newImage(path..name.."/score-8.png")
      else
        skin["score_8"] = love.graphics.newImage(path.."Default/score-8.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-9@2x.png") end) then
      skin["score_9"] = love.graphics.newImage(path..name.."/score-9@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-9.png") end) then
        skin["score_9"] = love.graphics.newImage(path..name.."/score-9.png")
      else
        skin["score_9"] = love.graphics.newImage(path.."Default/score-9.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-dot@2x.png") end) then
      skin["score_dot"] = love.graphics.newImage(path..name.."/score-dot@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-dot.png") end) then
        skin["score_dot"] = love.graphics.newImage(path..name.."/score-dot.png")
      else
        skin["score_dot"] = love.graphics.newImage(path.."Default/score-dot.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-comma@2x.png") end) then
      skin["score_comma"] = love.graphics.newImage(path..name.."/score-comma@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-comma.png") end) then
        skin["score_comma"] = love.graphics.newImage(path..name.."/score-comma.png")
      else
        skin["score_comma"] = love.graphics.newImage(path.."Default/score-comma.png")
      end
    end
    if pcall(function() love.graphics.newImage(path..name.."/score-x@2x.png") end) then
      skin["score_x"] = love.graphics.newImage(path..name.."/score-x@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/score-x.png") end) then
        skin["score_x"] = love.graphics.newImage(path..name.."/score-x.png")
      else
        skin["score_x"] = love.graphics.newImage(path.."Default/score-x.png")
      end
    end
    --[[
    skin["score_0"] = love.graphics.newImage(path..name.."/score-0.png")
    skin["score_1"] = love.graphics.newImage(path..name.."/score-1.png")
    skin["score_2"] = love.graphics.newImage(path..name.."/score-2.png")
    skin["score_3"] = love.graphics.newImage(path..name.."/score-3.png")
    skin["score_4"] = love.graphics.newImage(path..name.."/score-4.png")
    skin["score_5"] = love.graphics.newImage(path..name.."/score-5.png")
    skin["score_6"] = love.graphics.newImage(path..name.."/score-6.png")
    skin["score_7"] = love.graphics.newImage(path..name.."/score-7.png")
    skin["score_8"] = love.graphics.newImage(path..name.."/score-8.png")
    skin["score_9"] = love.graphics.newImage(path..name.."/score-9.png")
    skin["score_comma"] = love.graphics.newImage(path..name.."/score-comma.png")
    skin["score_dot"] = love.graphics.newImage(path..name.."/score-dot.png")
    skin["score_precent"] = love.graphics.newImage(path..name.."/score-percent.png")
    skin["score_x"] = love.graphics.newImage(path..name.."/score-x.png")--]]
    
    if pcall(function() love.graphics.newImage(path..name.."/sliderb@2x.png") end) then
      skin["sliderb"] = love.graphics.newImage(path..name.."/sliderb@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/sliderb.png") end) then
        skin["sliderb"] = love.graphics.newImage(path..name.."/sliderb.png")
      else
        skin["sliderb"] = love.graphics.newImage(path.."Default/sliderb0.png")
      end
    end
    
    skin["reversearrow"] = love.graphics.newImage(path..name.."/reversearrow.png")
    skin["sliderfollowcircle"] = love.graphics.newImage(path..name.."/sliderfollowcircle.png")
    skin["sliderscorepoint"] = love.graphics.newImage(path..name.."/sliderscorepoint.png")
    
    --skin["normal_hitnormal"] = love.audio.newSource(path..name.."/normal-hitnormal.wav", 'stream')
    
    if pcall(function() love.audio.newSource(path..name.."/normal-hitclap.ogg", 'static') end) then
      skin["normal_hitclap"] = love.audio.newSource(path..name.."/normal-hitclap.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/normal-hitclap.wav", 'static') end) then
        skin["normal_hitclap"] = love.audio.newSource(path..name.."/normal-hitclap.wav", 'static')
      else
        skin["normal_hitclap"] = love.audio.newSource(path.."Default/normal-hitclap.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/normal-hitfinish.ogg", 'static') end) then
      skin["normal_hitfinish"] = love.audio.newSource(path..name.."/normal-hitfinish.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/normal-hitfinish.wav", 'static') end) then
        skin["normal_hitfinish"] = love.audio.newSource(path..name.."/normal-hitfinish.wav", 'static')
      else
        skin["normal_hitfinish"] = love.audio.newSource(path.."Default/normal-hitfinish.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/normal-hitnormal.ogg", 'static') end) then
      skin["normal_hitnormal"] = love.audio.newSource(path..name.."/normal-hitnormal.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/normal-hitnormal.wav", 'static') end) then
        skin["normal_hitnormal"] = love.audio.newSource(path..name.."/normal-hitnormal.wav", 'static')
      else
        skin["normal_hitnormal"] = love.audio.newSource(path.."Default/normal-hitnormal.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/normal-hitwhistle.ogg", 'static') end) then
      skin["normal_hitwhistle"] = love.audio.newSource(path..name.."/normal-hitwhistle.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/normal-hitclap.wav", 'static') end) then
        skin["normal_hitwhistle"] = love.audio.newSource(path..name.."/normal-hitwhistle.wav", 'static')
      else
        skin["normal_hitwhistle"] = love.audio.newSource(path.."Default/normal-hitwhistle.wav", 'static')
      end
    end
    
    if pcall(function() love.audio.newSource(path..name.."/soft-hitclap.ogg", 'static') end) then
      skin["soft_hitclap"] = love.audio.newSource(path..name.."/soft-hitclap.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/soft-hitclap.wav", 'static') end) then
        skin["soft_hitclap"] = love.audio.newSource(path..name.."/soft-hitclap.wav", 'static')
      else
        skin["soft_hitclap"] = love.audio.newSource(path.."Default/soft-hitclap.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/soft-hitfinish.ogg", 'static') end) then
      skin["soft_hitfinish"] = love.audio.newSource(path..name.."/soft-hitfinish.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/soft-hitfinish.wav", 'static') end) then
        skin["soft_hitfinish"] = love.audio.newSource(path..name.."/soft-hitfinish.wav", 'static')
      else
        skin["soft_hitfinish"] = love.audio.newSource(path.."Default/soft-hitfinish.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/soft-hitnormal.ogg", 'static') end) then
      skin["soft_hitnormal"] = love.audio.newSource(path..name.."/soft-hitnormal.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/soft-hitnormal.wav", 'static') end) then
        skin["soft_hitnormal"] = love.audio.newSource(path..name.."/soft-hitnormal.wav", 'static')
      else
        skin["soft_hitnormal"] = love.audio.newSource(path.."Default/soft-hitnormal.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/soft-hitwhistle.ogg", 'static') end) then
      skin["soft_hitwhistle"] = love.audio.newSource(path..name.."/soft-hitwhistle.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/soft-hitclap.wav", 'static') end) then
        skin["soft_hitwhistle"] = love.audio.newSource(path..name.."/soft-hitwhistle.wav", 'static')
      else
        skin["soft_hitwhistle"] = love.audio.newSource(path.."Default/soft-hitwhistle.wav", 'static')
      end
    end
    
    if pcall(function() love.audio.newSource(path..name.."/drum-hitclap.ogg", 'static') end) then
      skin["drum_hitclap"] = love.audio.newSource(path..name.."/drum-hitclap.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/drum-hitclap.wav", 'static') end) then
        skin["drum_hitclap"] = love.audio.newSource(path..name.."/drum-hitclap.wav", 'static')
      else
        skin["drum_hitclap"] = love.audio.newSource(path.."Default/drum-hitclap.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/drum-hitfinish.ogg", 'static') end) then
      skin["drum_hitfinish"] = love.audio.newSource(path..name.."/drum-hitfinish.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/drum-hitfinish.wav", 'static') end) then
        skin["drum_hitfinish"] = love.audio.newSource(path..name.."/drum-hitfinish.wav", 'static')
      else
        skin["drum_hitfinish"] = love.audio.newSource(path.."Default/drum-hitfinish.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/drum-hitnormal.ogg", 'static') end) then
      skin["drum_hitnormal"] = love.audio.newSource(path..name.."/drum-hitnormal.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/drum-hitnormal.wav", 'static') end) then
        skin["drum_hitnormal"] = love.audio.newSource(path..name.."/drum-hitnormal.wav", 'static')
      else
        skin["drum_hitnormal"] = love.audio.newSource(path.."Default/drum-hitnormal.wav", 'static')
      end
    end
    if pcall(function() love.audio.newSource(path..name.."/drum-hitwhistle.ogg", 'static') end) then
      skin["drum_hitwhistle"] = love.audio.newSource(path..name.."/drum-hitwhistle.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/drum-hitclap.wav", 'static') end) then
        skin["drum_hitwhistle"] = love.audio.newSource(path..name.."/drum-hitwhistle.wav", 'static')
      else
        skin["drum_hitwhistle"] = love.audio.newSource(path.."Default/drum-hitwhistle.wav", 'static')
      end
    end
    
    if pcall(function() love.graphics.newImage(path..name.."/cursor@2x.png") end) then
      skin["cursor"] = love.graphics.newImage(path..name.."/cursor@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/cursor.png") end) then
        skin["cursor"] = love.graphics.newImage(path..name.."/cursor.png")
      else
        skin["cursor"] = love.graphics.newImage(path.."Default/cursor.png")
      end
    end
    
    if pcall(function() love.graphics.newImage(path..name.."/cursormiddle@2x.png") end) then
      skin["cursormiddle"] = love.graphics.newImage(path..name.."/cursormiddle@2x.png")
    else
      if pcall(function() love.graphics.newImage(path..name.."/cursormiddle.png") end) then
        skin["cursormiddle"] = love.graphics.newImage(path..name.."/cursormiddle.png")
      else
        skin["cursormiddle"] = 0
      end
    end
    
    if pcall(function() love.audio.newSource(path..name.."/combobreak.ogg", 'static') end) then
      skin["combobreak"] = love.audio.newSource(path..name.."/combobreak.ogg", 'static')
    else
      if pcall(function() love.audio.newSource(path..name.."/combobreak.wav", 'static') end) then
        skin["combobreak"] = love.audio.newSource(path..name.."/combobreak.wav", 'static')
      else
        if pcall(function() love.audio.newSource(path..name.."/combobreak.mp3", 'static') end) then
          skin["combobreak"] = love.audio.newSource(path..name.."/combobreak.mp3", 'static')
        else
          skin["combobreak"] = love.audio.newSource(path.."Default/combobreak.mp3", 'static')
        end
      end
    end
    
  end

  return skin
end

return Skin