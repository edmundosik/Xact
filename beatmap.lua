parser = require "lib.LIP.LIP"
Bitwise = require "lib.bitwise"
Split = require "lib.split"

local Beatmap = {}

function Beatmap:load(path)
  local beatmap = {}
  local beatmapfile = parser.load(path)
  local beatmapfile_e = parser.loade(path)
  local beatmapfile_t = parser.loadt(path)
  local beatmapfile_obj = parser.loadhitobj(path)
  
  function beatmap:GetGeneral()
    local general = {}
    
    general[0] = beatmapfile.General.AudioFilename:sub(2)
    general[1] = beatmapfile.General.AudioLeadIn
    general[2] = beatmapfile.General.PreviewTime
    general[3] = beatmapfile.General.Countdown
    general[4] = beatmapfile.General.SampleSet:sub(2)
    general[5] = beatmapfile.General.StackLeniency
    general[6] = beatmapfile.General.Mode
    general[7] = beatmapfile.General.LetterboxInBreaks
    general[8] = beatmapfile.General.EditorBookmarks
    
    return general
  end
  
  function beatmap:GetMetadata()
    local metadata = {}
    
    metadata[0] = beatmapfile.Metadata.Title
    metadata[1] = beatmapfile.Metadata.Artist
    metadata[2] = beatmapfile.Metadata.Creator
    metadata[3] = beatmapfile.Metadata.Version
    metadata[4] = beatmapfile.Metadata.Source
    metadata[5] = beatmapfile.Metadata.Tags
    
    return metadata
  end
  
  function beatmap:GetDifficulty()
    local difficulty = {}
    
    difficulty[0] = beatmapfile.Difficulty.HPDrainRate
    difficulty[1] = beatmapfile.Difficulty.CircleSize
    difficulty[2] = beatmapfile.Difficulty.OverallDifficulty
    difficulty[3] = beatmapfile.Difficulty.ApproachRate
    difficulty[4] = beatmapfile.Difficulty.SliderMultiplier
    difficulty[5] = beatmapfile.Difficulty.SliderTickRate
    
    return difficulty
  end
  
  function beatmap:GetEvents()
    local events = {}
    local eventss = 0
    
    for k, v in pairs(beatmapfile_e) do
      eventss = eventss + 1
    end
    
    local i = 2
    while i < eventss do
      local event = "e"..tostring(i)
      events[i] = beatmapfile_e[event]
      i = i + 1
    end
    
    return events
  end
  
  function beatmap:GetEventData()
    local pos = {}
    local events = beatmap:GetEvents()
    
    if pcall(function() pos['bg'] = Split(tostring(events[3]), ',')[3]:sub(2, -2) end) then
      pos['bg'] = Split(tostring(events[3]), ',')[3]:sub(2, -2)
    else
      pos['bg'] = nil
    end
    --print(pos['bg'])
    return pos
  end
  
  function beatmap:GetTimingPoints()
    local timingpoints = {}
    local tpoints = 0
    
    for k, v in pairs(beatmapfile_t) do
      tpoints = tpoints + 1
    end
    
    local i = 2
    while i < tpoints do
      local timpoint = "t"..tostring(i)
      timingpoints[i] = beatmapfile_t[timpoint]
      i = i + 1
    end
    
    return timingpoints
  end
  
  function beatmap:GetTimingPointData() -- time,beatLength,meter,sampleSet,sampleIndex,volume,uninherited,effects
    local pos = {}
    local timingpoints = beatmap:GetTimingPoints()
    
    for i = 2, #timingpoints do
      pos[i] = {}
      for j = 0, 7 do
          pos[i]['time'] = {}
          pos[i]['beatLength'] = {}
          pos[i]['meter'] = {}
          pos[i]['sampleSet'] = {}
          pos[i]['sampleIndex'] = {}
          pos[i]['volume'] = {}
          pos[i]['uninherited'] = {}
          pos[i]['effects'] = {}
      end
    end
    
    for i = 2, #timingpoints do
      local timingpointsSplitted = Split(timingpoints[i], ',')
      
      pos[i]['time'] = timingpointsSplitted[1]
      pos[i]['beatLength'] = timingpointsSplitted[2]
      pos[i]['meter'] = timingpointsSplitted[3]
      pos[i]['sampleSet'] = timingpointsSplitted[4]
      pos[i]['sampleIndex'] = timingpointsSplitted[5]
      pos[i]['volume'] = timingpointsSplitted[6]
      pos[i]['uninherited'] = timingpointsSplitted[7]
      pos[i]['effects'] = timingpointsSplitted[8]
    end
    
    return pos
  end
  
  function beatmap:GetHitObjects()
    local hitobjects = {}
    local objs = 0;
    
    for k, v in pairs(beatmapfile_obj) do
      objs = objs + 1
    end
    
    local i = 2
    while i < objs do
      local hitobj = "obj"..tostring(i)
      hitobjects[i] = beatmapfile_obj[hitobj]
      i = i + 1
    end
    
    return hitobjects
  end
  
  function beatmap:GetHitobjectData() -- x,y,time,type,hitSound,objectParams,hitSample
    local pos = {}
    local hitobjects = beatmap:GetHitObjects()

    for i = 2, #hitobjects do
      pos[i] = {}
      for j = 0, 11 do
          pos[i]['x'] = {}
          pos[i]['y'] = {}
          pos[i]['time'] = {}
          pos[i]['type'] = {}
          pos[i]['hitSound'] = {}
          pos[i]['curveType'] = {}
          pos[i]['curvePoints'] = {}
          pos[i]['slides'] = {}
          pos[i]['length'] = {}
          pos[i]['edgeSounds'] = {}
          pos[i]['edgeSets'] = {}
          pos[i]['hitSample'] = {}
      end
    end
    
    local hitcircle  = 1
    local slider     = 2
    local newcombo   = 4
    local spinner    = 8
        
    for i = 2, #hitobjects do
      -- https://github.com/itdelatrisu/opsu/blob/28003bfbe5195a97c1d7135d6060d09727768aab/src/itdelatrisu/opsu/beatmap/HitObject.java#L187
      local hitobjectsSplitted = Split(hitobjects[i], ',')
      
      pos[i]['x'] = hitobjectsSplitted[1]
      pos[i]['y'] = hitobjectsSplitted[2]
      pos[i]['time'] = hitobjectsSplitted[3]
      pos[i]['type'] = hitobjectsSplitted[4]
      pos[i]['hitSound'] = hitobjectsSplitted[5]
      
      if (Bitwise:band(tonumber(pos[i]['type']), slider)) > 0 then -- if type is slider
        local sliderSplitted = Split(hitobjectsSplitted[6], '|')
        
        pos[i]['curveType'] = sliderSplitted[1]
        for k = 2, #sliderSplitted do
          local sliderXY = Split(sliderSplitted[k], ':')
          
          table.insert(pos[i]['curvePoints'], (sliderXY[1] * osupixel['xMulti']))
          table.insert(pos[i]['curvePoints'], (sliderXY[2] * osupixel['yMulti']))
        end
        pos[i]['slides'] = hitobjectsSplitted[7]
        pos[i]['length'] = hitobjectsSplitted[8]
        
        if #hitobjectsSplitted > 9 then
          local edgeHits = Split(hitobjectsSplitted[9], '|')
          for k = 1, #edgeHits do
            pos[i]['edgeSounds'][k] = edgeHits[k]
          end
        end
      end
    end
    
    return pos
  end
  
  function beatmap:GetBPM() -- BPM = (1 / beatLength * 1000 * 60)
    --return (1 / tonumber(beatmap:GetTimingPointData()[2].beatLength) * 1000 * 60)
  end
  
  return beatmap
end

return Beatmap