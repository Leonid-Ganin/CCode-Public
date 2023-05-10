local CALC = require 'Core.Simulation.calc'
local M = {}

local setTransitionListener = function(listener)
    return ' function(e) pcall(function() if GAME.hash == hash then ' .. listener .. '(e) end end) end'
end

M['deleteFilter'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. CALC(params[1]) .. ' GAME.group.objects[name].fill.effect = nil'
    GAME.lua = GAME.lua .. ' GAME.group.objects[name]._effect = nil end)'
end

M['setBlur'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local sizeH = '((' .. CALC(params[5]) .. ') * 5.1 + 2)'
    local sizeV = '((' .. CALC(params[6]) .. ') * 5.1 + 2)'
    local sigmaH = '((' .. CALC(params[7]) .. ') * 5.1 + 2)'
    local sigmaV = '((' .. CALC(params[8]) .. ') * 5.1 + 2)'
    local onComplete, onPause = CALC(params[10], 'a', true), CALC(params[11], 'a', true)
    local onResume, onCancel = CALC(params[12], 'a', true), CALC(params[13], 'a', true)
    local onRepeat = CALC(params[14], 'a', true)
    local easing = CALC(params[9], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.blurGaussian\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.blurGaussian\''
    GAME.lua = GAME.lua .. ' object.fill.effect.horizontal.blurSize = ' .. sizeH
    GAME.lua = GAME.lua .. ' object.fill.effect.horizontal.sigma = ' .. sigmaH
    GAME.lua = GAME.lua .. ' object.fill.effect.vertical.blurSize = ' .. sizeV
    GAME.lua = GAME.lua .. ' object.fill.effect.vertical.sigma = ' .. sigmaV
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[14], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[10], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.blurGaussian\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.blurGaussian\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.blurGaussian\''
    GAME.lua = GAME.lua .. ' object.fill.effect.horizontal.blurSize = 0.01'
    GAME.lua = GAME.lua .. ' object.fill.effect.horizontal.sigma = 0.01'
    GAME.lua = GAME.lua .. ' object.fill.effect.vertical.blurSize = 0.01'
    GAME.lua = GAME.lua .. ' object.fill.effect.vertical.sigma = 0.01 end'
    GAME.lua = GAME.lua .. ' local function doTo(object) transition.' .. direction .. '(object.fill.effect.horizontal, {'
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' blurSize = ' .. sizeH .. ', sigma = ' .. sigmaH .. '})'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect.vertical, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' blurSize = ' .. sizeV .. ', sigma = ' .. sigmaV .. '}) end doTo(object) end end)'
end

M['setChromakey'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local sensitivity = '((' .. CALC(params[5]) .. ') / 100)'
    local smoothing = '((' .. CALC(params[6]) .. ') / 100)'
    local color = '{ ' .. CALC(params[7]) .. ' / 255, ' .. CALC(params[8]) .. ' / 255, ' .. CALC(params[9]) .. ' / 255, 1}'
    local onComplete, onPause = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
    local onResume, onCancel = CALC(params[13], 'a', true), CALC(params[14], 'a', true)
    local onRepeat = CALC(params[15], 'a', true)
    local easing = CALC(params[10], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.chromaKey\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.chromaKey\''
    GAME.lua = GAME.lua .. ' object.fill.effect.sensitivity = ' .. sensitivity
    GAME.lua = GAME.lua .. ' object.fill.effect.smoothing = ' .. smoothing
    GAME.lua = GAME.lua .. ' object.fill.effect.color = ' .. color
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[15], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.chromaKey\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.chromaKey\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.chromaKey\''
    GAME.lua = GAME.lua .. ' object.fill.effect.sensitivity = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.smoothing = 0 end'
    GAME.lua = GAME.lua .. ' object.fill.effect.color = ' .. color
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' sensitivity = ' .. sensitivity .. ', smoothing = ' .. smoothing .. '}) end doTo(object) end end)'
end

M['setCrystallization'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local numTiles = '(' .. CALC(params[5]) .. ')'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.crystallize\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.crystallize\''
    GAME.lua = GAME.lua .. ' object.fill.effect.numTiles = ' .. numTiles
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.crystallize\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.crystallize\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.crystallize\''
    GAME.lua = GAME.lua .. ' object.fill.effect.numTiles = 100 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' numTiles = ' .. numTiles .. '}) end doTo(object) end end)'
end

M['setPixellization'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local numPixels = '(' .. CALC(params[5]) .. ')'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.pixelate\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.pixelate\''
    GAME.lua = GAME.lua .. ' object.fill.effect.numTiles = ' .. numPixels
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.pixelate\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.pixelate\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.pixelate\''
    GAME.lua = GAME.lua .. ' object.fill.effect.numPixels = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' numPixels = ' .. numPixels .. '}) end doTo(object) end end)'
end

M['setScatter'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.scatter\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.scatter\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.scatter\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.scatter\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.scatter\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. '}) end doTo(object) end end)'
end

M['setOpTile'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local numPixels = '(' .. CALC(params[5]) .. ')'
    local angle = '(' .. CALC(params[6]) .. ')'
    local scale = '(' .. CALC(params[7]) .. ' / 10)'
    local onComplete, onPause = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onResume, onCancel = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
    local onRepeat = CALC(params[13], 'a', true)
    local easing = CALC(params[8], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.opTile\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.opTile\''
    GAME.lua = GAME.lua .. ' object.fill.effect.numPixels = ' .. numPixels
    GAME.lua = GAME.lua .. ' object.fill.effect.angle = ' .. angle
    GAME.lua = GAME.lua .. ' object.fill.effect.scale = ' .. scale
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[13], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[9], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.opTile\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.opTile\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.opTile\''
    GAME.lua = GAME.lua .. ' object.fill.effect.numPixels = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.angle = ' .. angle
    GAME.lua = GAME.lua .. ' object.fill.effect.scale = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' numPixels = ' .. numPixels .. ', angle = ' .. angle .. ', scale = ' .. scale .. '}) end doTo(object) end end)'
end

M['setBloom'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local levelsW = '((' .. CALC(params[5]) .. ') / 100)'
    local levelsB = '((' .. CALC(params[6]) .. ') / 100)'
    local levelsG = '((' .. CALC(params[7]) .. ') / 100)'
    local addA = '((' .. CALC(params[8]) .. ') / 100)'
    local sizeH = '((' .. CALC(params[9]) .. ') * 5.1 + 2)'
    local sizeV = '((' .. CALC(params[10]) .. ') * 5.1 + 2)'
    local sigmaH = '((' .. CALC(params[11]) .. ') * 5.12)'
    local sigmaV = '((' .. CALC(params[12]) .. ') * 5.12)'
    local onComplete, onPause = CALC(params[14], 'a', true), CALC(params[15], 'a', true)
    local onResume, onCancel = CALC(params[16], 'a', true), CALC(params[17], 'a', true)
    local onRepeat = CALC(params[18], 'a', true)
    local easing = CALC(params[13], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    if levelsW == levelsB and levelsW ~= '(((50)) / 100)' then
        levelsB = '(1 - ' .. levelsW .. ')'
    elseif levelsW == levelsB and levelsW == '(((50)) / 100)' then
        levelsW = '(0.505)'
        levelsB = '(0.495)'
    end

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.bloom\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.bloom\''
    GAME.lua = GAME.lua .. ' object.fill.effect.levels.white = ' .. levelsW
    GAME.lua = GAME.lua .. ' object.fill.effect.levels.black = ' .. levelsB
    GAME.lua = GAME.lua .. ' object.fill.effect.levels.gamma = ' .. levelsG
    GAME.lua = GAME.lua .. ' object.fill.effect.add.Alpha = ' .. addA
    GAME.lua = GAME.lua .. ' object.fill.effect.blur.horizontal.blurSize = ' .. sizeH
    GAME.lua = GAME.lua .. ' object.fill.effect.blur.horizontal.sigma = ' .. sigmaH
    GAME.lua = GAME.lua .. ' object.fill.effect.blur.vertical.blurSize = ' .. sizeV
    GAME.lua = GAME.lua .. ' object.fill.effect.blur.vertical.sigma = ' .. sigmaV
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[18], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[14], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.bloom\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.bloom\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.bloom\''
    GAME.lua = GAME.lua .. ' object.fill.effect.levels.white = 0.55'
    GAME.lua = GAME.lua .. ' object.fill.effect.levels.black = 0.85'
    GAME.lua = GAME.lua .. ' object.fill.effect.levels.gamma = 1'
    GAME.lua = GAME.lua .. ' object.fill.effect.add.Alpha = 1'
    GAME.lua = GAME.lua .. ' object.fill.effect.blur.horizontal.blurSize = 2'
    GAME.lua = GAME.lua .. ' object.fill.effect.blur.horizontal.sigma = 2'
    GAME.lua = GAME.lua .. ' object.fill.effect.blur.vertical.blurSize = 2'
    GAME.lua = GAME.lua .. ' object.fill.effect.blur.vertical.sigma = 2 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect.levels, {'
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' white = ' .. levelsW .. ', black = ' .. levelsB .. ', gamma = ' .. levelsG .. '})'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect.add, {'
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' alpha = ' .. addA .. '})'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect.blur.horizontal, {'
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' blurSize = ' .. sizeH .. ', sigma = ' .. sigmaH .. '})'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect.blur.vertical, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' blurSize = ' .. sizeV .. ', sigma = ' .. sigmaV .. '}) end doTo(object) end end)'
end

M['setColorChannelOffset'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local texelsX = '(' .. CALC(params[5]) .. ')'
    local texelsY = '(' .. CALC(params[6]) .. ')'
    local onComplete, onPause = CALC(params[8], 'a', true), CALC(params[9], 'a', true)
    local onResume, onCancel = CALC(params[10], 'a', true), CALC(params[11], 'a', true)
    local onRepeat = CALC(params[12], 'a', true)
    local easing = CALC(params[7], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.colorChannelOffset\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.colorChannelOffset\''
    GAME.lua = GAME.lua .. ' object.fill.effect.xTexels = ' .. texelsX
    GAME.lua = GAME.lua .. ' object.fill.effect.yTexels = ' .. texelsY
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[12], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[8], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.colorChannelOffset\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.colorChannelOffset\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.colorChannelOffset\''
    GAME.lua = GAME.lua .. ' object.fill.effect.xTexels = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.yTexels = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' xTexels = ' .. texelsX .. ', yTexels = ' .. texelsY .. '}) end doTo(object) end end)'
end

M['setCrosshatch'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local grain = '(' .. CALC(params[5]) .. ')'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.crosshatch\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.crosshatch\''
    GAME.lua = GAME.lua .. ' object.fill.effect.grain = ' .. grain
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.crosshatch\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.crosshatch\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.crosshatch\''
    GAME.lua = GAME.lua .. ' object.fill.effect.grain = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' grain = ' .. grain .. '}) end doTo(object) end end)'
end

M['setDissolve'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local threshold = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.dissolve\''
    GAME.lua = GAME.lua .. ' object.fill.effect.threshold = ' .. threshold
    GAME.lua = GAME.lua .. ' object._effect = \'filter.dissolve\''
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.dissolve\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.dissolve\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.dissolve\''
    GAME.lua = GAME.lua .. ' object.fill.effect.threshold = 1 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' threshold = ' .. threshold .. '}) end doTo(object) end end)'
end

M['setEmboss'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 25)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.emboss\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.emboss\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.emboss\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.emboss\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.emboss\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. '}) end doTo(object) end end)'
end

M['setFostedGlass'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local scale = '(' .. CALC(params[5]) .. ')'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.frostedGlass\''
    GAME.lua = GAME.lua .. ' object.fill.effect.scale = ' .. scale
    GAME.lua = GAME.lua .. ' object._effect = \'filter.frostedGlass\''
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.frostedGlass\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.frostedGlass\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.frostedGlass\''
    GAME.lua = GAME.lua .. ' object.fill.effect.scale = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' scale = ' .. scale .. '}) end doTo(object) end end)'
end

M['setWoodCut'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.woodCut\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.woodCut\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.woodCut\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.woodCut\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.woodCut\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. '}) end doTo(object) end end)'
end

M['setZoomBlur'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 100)'
    local sigmaH = '(' .. CALC(params[6]) .. ' / 100)'
    local sigmaV = '(' .. CALC(params[7]) .. ' / 100)'
    local onComplete, onPause = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onResume, onCancel = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
    local onRepeat = CALC(params[13], 'a', true)
    local easing = CALC(params[8], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.zoomBlur\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.zoomBlur\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' object.fill.effect.u = ' .. sigmaH
    GAME.lua = GAME.lua .. ' object.fill.effect.v = ' .. sigmaV
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[13], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[9], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.zoomBlur\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.zoomBlur\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.zoomBlur\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.u = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.v = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. ', u = ' .. sigmaH .. ', v = ' .. sigmaV .. '}) end doTo(object) end end)'
end

M['setVingette'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local radius = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.vignette\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.vignette\''
    GAME.lua = GAME.lua .. ' object.fill.effect.radius = ' .. radius
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.vignette\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.vignette\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.vignette\''
    GAME.lua = GAME.lua .. ' object.fill.effect.radius = 1 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' radius = ' .. radius .. '}) end doTo(object) end end)'
end

M['setVingetteMask'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local radiusInner = '(' .. CALC(params[5]) .. ' / 100)'
    local radiusOuter = '(' .. CALC(params[6]) .. ' / 100)'
    local onComplete, onPause = CALC(params[8], 'a', true), CALC(params[9], 'a', true)
    local onResume, onCancel = CALC(params[10], 'a', true), CALC(params[11], 'a', true)
    local onRepeat = CALC(params[12], 'a', true)
    local easing = CALC(params[7], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.vignetteMask\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.vignetteMask\''
    GAME.lua = GAME.lua .. ' object.fill.effect.innerRadius = ' .. radiusInner
    GAME.lua = GAME.lua .. ' object.fill.effect.OuterRadius = ' .. radiusOuter
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[12], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[8], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.vignetteMask\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.vignetteMask\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.vignetteMask\''
    GAME.lua = GAME.lua .. ' object.fill.effect.innerRadius = 1'
    GAME.lua = GAME.lua .. ' object.fill.effect.OuterRadius = 1 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' innerRadius = ' .. radiusInner .. ', outerRadius = ' .. radiusOuter .. '}) end doTo(object) end end)'
end

M['setSwirl'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.swirl\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.swirl\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.swirl\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.swirl\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.swirl\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. '}) end doTo(object) end end)'
end

M['setStraighten'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local angle = '(' .. CALC(params[5]) .. ')'
    local width = '(' .. CALC(params[6]) .. ' / 100)'
    local height = '(' .. CALC(params[7]) .. ' / 100)'
    local onComplete, onPause = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onResume, onCancel = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
    local onRepeat = CALC(params[13], 'a', true)
    local easing = CALC(params[8], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.straighten\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.straighten\''
    GAME.lua = GAME.lua .. ' object.fill.effect.angle = ' .. angle
    GAME.lua = GAME.lua .. ' object.fill.effect.width = ' .. width
    GAME.lua = GAME.lua .. ' object.fill.effect.height = ' .. height
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[13], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[9], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.straighten\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.straighten\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.straighten\''
    GAME.lua = GAME.lua .. ' object.fill.effect.angle = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.width = 1'
    GAME.lua = GAME.lua .. ' object.fill.effect.height = 1 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' angle = ' .. angle .. ', width = ' .. width .. ', height = ' .. height .. '}) end doTo(object) end end)'
end

M['setBulge'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.bulge\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.bulge\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.bulge\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.bulge\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.bulge\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 1 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. '}) end doTo(object) end end)'
end

M['setLinearWipe'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local angle = '(' .. CALC(params[5]) .. ')'
    local smoothness = '(' .. CALC(params[6]) .. ' / 100)'
    local progress = '(' .. CALC(params[7]) .. ' / 100)'
    local onComplete, onPause = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onResume, onCancel = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
    local onRepeat = CALC(params[13], 'a', true)
    local easing = CALC(params[8], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' local angle = {_G.math.sin(_G.math.rad(' .. angle .. ')), _G.math.cos(_G.math.rad(' .. angle .. '))}'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.linearWipe\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.linearWipe\''
    GAME.lua = GAME.lua .. ' object.fill.effect.direction = angle'
    GAME.lua = GAME.lua .. ' object.fill.effect.smoothness = ' .. smoothness
    GAME.lua = GAME.lua .. ' object.fill.effect.progress = ' .. progress
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[13], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[9], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.linearWipe\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.linearWipe\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.linearWipe\''
    GAME.lua = GAME.lua .. ' object.fill.effect.smoothness = 1'
    GAME.lua = GAME.lua .. ' object.fill.effect.progress = 1 end'
    GAME.lua = GAME.lua .. ' object.fill.effect.direction = angle'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' smoothness = ' .. smoothness .. ', progress = ' .. progress .. '}) end doTo(object) end end)'
end

M['setIris'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local center = '{((' .. CALC(params[5]) .. ') / 100), (1 - (' .. CALC(params[6]) .. ') / 100)}'
    local smoothness = '((' .. CALC(params[7]) .. ') / 100)'
    local aspectRatio = '(' .. CALC(params[8]) .. ')'
    local aperture = '((' .. CALC(params[9]) .. ') / 100)'
    local onComplete, onPause = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
    local onResume, onCancel = CALC(params[13], 'a', true), CALC(params[14], 'a', true)
    local onRepeat = CALC(params[15], 'a', true)
    local easing = CALC(params[10], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.iris\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.iris\''
    GAME.lua = GAME.lua .. ' object.fill.effect.aperture = ' .. aperture
    GAME.lua = GAME.lua .. ' object.fill.effect.aspectRatio = ' .. aspectRatio
    GAME.lua = GAME.lua .. ' object.fill.effect.smoothness = ' .. smoothness
    GAME.lua = GAME.lua .. ' object.fill.effect.center = ' .. center
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[15], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.iris\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.iris\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.iris\''
    GAME.lua = GAME.lua .. ' object.fill.effect.aperture = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.smoothness = 0 end'
    GAME.lua = GAME.lua .. ' object.fill.effect.aspectRatio = ' .. aspectRatio
    GAME.lua = GAME.lua .. ' object.fill.effect.center = ' .. center
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' aperture = ' .. aperture .. ', smoothness = ' .. smoothness .. '}) end doTo(object) end end)'
end

M['setPolkaDots'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local numPixels = '(' .. CALC(params[5]) .. ')'
    local dotRadius = '(' .. CALC(params[6]) .. ' / 100)'
    local aspectRatio = '(' .. CALC(params[7]) .. ')'
    local onComplete, onPause = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onResume, onCancel = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
    local onRepeat = CALC(params[13], 'a', true)
    local easing = CALC(params[8], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.polkaDots\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.polkaDots\''
    GAME.lua = GAME.lua .. ' object.fill.effect.numPixels = ' .. numPixels
    GAME.lua = GAME.lua .. ' object.fill.effect.dotRadius = ' .. dotRadius
    GAME.lua = GAME.lua .. ' object.fill.effect.aspectRatio = ' .. aspectRatio
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[13], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[9], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.polkaDots\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.polkaDots\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.polkaDots\''
    GAME.lua = GAME.lua .. ' object.fill.effect.dotRadius = 1'
    GAME.lua = GAME.lua .. ' object.fill.effect.numPixels = 0 end'
    GAME.lua = GAME.lua .. ' object.fill.effect.aspectRatio = ' .. aspectRatio
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' numPixels = ' .. numPixels .. ', dotRadius = ' .. dotRadius .. '}) end doTo(object) end end)'
end

M['setRadialWipe'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local center = '{((' .. CALC(params[5]) .. ') / 100), (1 - (' .. CALC(params[6]) .. ') / 100)}'
    local axisOrientation = '((' .. CALC(params[7]) .. ') / 100)'
    local smoothness = '((' .. CALC(params[8]) .. ') / 100)'
    local progress = '((' .. CALC(params[9]) .. ') / 100)'
    local onComplete, onPause = CALC(params[11], 'a', true), CALC(params[12], 'a', true)
    local onResume, onCancel = CALC(params[13], 'a', true), CALC(params[14], 'a', true)
    local onRepeat = CALC(params[15], 'a', true)
    local easing = CALC(params[10], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.radialWipe\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.radialWipe\''
    GAME.lua = GAME.lua .. ' object.fill.effect.center = ' .. center
    GAME.lua = GAME.lua .. ' object.fill.effect.axisOrientation = ' .. axisOrientation
    GAME.lua = GAME.lua .. ' object.fill.effect.smoothness = ' .. smoothness
    GAME.lua = GAME.lua .. ' object.fill.effect.progress = ' .. progress
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[15], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.radialWipe\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.radialWipe\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.radialWipe\''
    GAME.lua = GAME.lua .. ' object.fill.effect.smoothness = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.progress = 0 end'
    GAME.lua = GAME.lua .. ' object.fill.effect.axisOrientation = ' .. axisOrientation
    GAME.lua = GAME.lua .. ' object.fill.effect.center = ' .. center
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' smoothness = ' .. smoothness .. ', progress = ' .. progress .. '}) end doTo(object) end end)'
end

M['setWobble'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local amplitude = '(' .. CALC(params[5]) .. ')'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.wobble\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.wobble\''
    GAME.lua = GAME.lua .. ' object.fill.effect.amplitude = ' .. amplitude
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.wobble\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.wobble\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.wobble\''
    GAME.lua = GAME.lua .. ' object.fill.effect.amplitude = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' amplitude = ' .. amplitude .. '}) end doTo(object) end end)'
end

M['setBrightness'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.brightness\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.brightness\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.brightness\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.brightness\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.brightness\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. '}) end doTo(object) end end)'
end

M['setСontrast'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local contrast = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.contrast\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.contrast\''
    GAME.lua = GAME.lua .. ' object.fill.effect.contrast = ' .. contrast
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.contrast\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.contrast\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.contrast\''
    GAME.lua = GAME.lua .. ' object.fill.effect.contrast = 1 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' contrast = ' .. contrast .. '}) end doTo(object) end end)'
end

M['setSaturate'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.saturate\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.saturate\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.saturate\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.saturate\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.saturate\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 1 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. '}) end doTo(object) end end)'
end

M['setSharpenLuminance'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local sharpness = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.sharpenLuminance\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.sharpenLuminance\''
    GAME.lua = GAME.lua .. ' object.fill.effect.sharpness = ' .. sharpness
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.sharpenLuminance\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.sharpenLuminance\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.sharpenLuminance\''
    GAME.lua = GAME.lua .. ' object.fill.effect.sharpness = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' sharpness = ' .. sharpness .. '}) end doTo(object) end end)'
end

M['setSobel'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. CALC(params[1]) .. '].fill.effect = \'filter.sobel\' end)'
end

M['setSepia'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local intensity = '(' .. CALC(params[5]) .. ' / 100)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.sepia\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.sepia\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = ' .. intensity
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.sepia\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.sepia\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.sepia\''
    GAME.lua = GAME.lua .. ' object.fill.effect.intensity = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' intensity = ' .. intensity .. '}) end doTo(object) end end)'
end

M['setPosterize'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local colorsPerChannel = '(' .. CALC(params[5]) .. ')'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.posterize\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.posterize\''
    GAME.lua = GAME.lua .. ' object.fill.effect.colorsPerChannel = ' .. colorsPerChannel
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.posterize\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.posterize\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.posterize\''
    GAME.lua = GAME.lua .. ' object.fill.effect.colorsPerChannel = 100 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' colorsPerChannel = ' .. colorsPerChannel .. '}) end doTo(object) end end)'
end

M['setMonotone'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local r = '((' .. CALC(params[5]) .. ') / 255)'
    local g = '((' .. CALC(params[6]) .. ') / 255)'
    local b = '((' .. CALC(params[7]) .. ') / 255)'
    local a = '((' .. CALC(params[8]) .. ') / 100)'
    local onComplete, onPause = CALC(params[10], 'a', true), CALC(params[11], 'a', true)
    local onResume, onCancel = CALC(params[12], 'a', true), CALC(params[13], 'a', true)
    local onRepeat = CALC(params[14], 'a', true)
    local easing = CALC(params[9], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.monotone\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.monotone\''
    GAME.lua = GAME.lua .. ' object.fill.effect.r = ' .. r
    GAME.lua = GAME.lua .. ' object.fill.effect.g = ' .. g
    GAME.lua = GAME.lua .. ' object.fill.effect.b = ' .. b
    GAME.lua = GAME.lua .. ' object.fill.effect.a = ' .. a
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[14], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[10], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.monotone\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.monotone\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.monotone\''
    GAME.lua = GAME.lua .. ' object.fill.effect.r = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.g = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.b = 0'
    GAME.lua = GAME.lua .. ' object.fill.effect.a = 1 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' r = ' .. r .. ', g = ' .. g .. ', b = ' .. b .. ', a = ' .. a .. '}) end doTo(object) end end)'
end

M['setHue'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local angle = '(' .. CALC(params[5]) .. ')'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.hue\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.hue\''
    GAME.lua = GAME.lua .. ' object.fill.effect.angle = ' .. angle
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.hue\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.hue\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.hue\''
    GAME.lua = GAME.lua .. ' object.fill.effect.angle = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' angle = ' .. angle .. '}) end doTo(object) end end)'
end

M['setExposure'] = function(params)
    local name = CALC(params[1])
    local direction, count, time = CALC(params[2]), CALC(params[3], '1'), CALC(params[4], '1')
    local exposure = '(' .. CALC(params[5]) .. ' / 10)'
    local onComplete, onPause = CALC(params[7], 'a', true), CALC(params[8], 'a', true)
    local onResume, onCancel = CALC(params[9], 'a', true), CALC(params[10], 'a', true)
    local onRepeat = CALC(params[11], 'a', true)
    local easing = CALC(params[6], 'nil')

    local easing = easing == '(select[\'loop\']())' and 'continuousLoop' or (UTF8.match(easing, '%(select%[\'(.+)\'%]') or 'linear')
    local direction = direction == '(select[\'bounce\']())' and 'loop' or 'to'

    local onComplete = setTransitionListener(onComplete)
    local onCancel = setTransitionListener(onCancel)
    local onPause = setTransitionListener(onPause)
    local onResume = setTransitionListener(onResume)
    local onRepeat = setTransitionListener(onRepeat)

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' if ' .. time .. ' <= 0 then'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.exposure\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.exposure\''
    GAME.lua = GAME.lua .. ' object.fill.effect.exposure = ' .. exposure
    GAME.lua = GAME.lua .. ' for i = 2, ' .. count .. ' do'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[11], 'a', true) .. '() end) end'
    GAME.lua = GAME.lua .. ' pcall(function() ' .. CALC(params[7], 'a', true) .. '() end)'
    GAME.lua = GAME.lua .. ' else'
    GAME.lua = GAME.lua .. ' if object._effect ~= \'filter.exposure\' then'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.exposure\''
    GAME.lua = GAME.lua .. ' object._effect = \'filter.exposure\''
    GAME.lua = GAME.lua .. ' object.fill.effect.exposure = 0 end'
    GAME.lua = GAME.lua .. ' local function doTo(object)'
    GAME.lua = GAME.lua .. ' transition.' .. direction .. '(object.fill.effect, {onComplete = ' .. onComplete .. ', onRepeat = ' .. onRepeat .. ', onPause'
    GAME.lua = GAME.lua .. ' = ' .. onPause .. ', onResume = ' .. onResume .. ', onCancel = ' .. onCancel .. ','
    GAME.lua = GAME.lua .. ' time = ' .. time .. ' * 1000, iterations = ' .. count .. ', transition = easing.' .. easing .. ','
    GAME.lua = GAME.lua .. ' exposure = ' .. exposure .. '}) end doTo(object) end end)'
end

M['setDuotone'] = function(params)
    local name = CALC(params[1])
    local lightColor = CALC(params[2], '{63, 0, 0, 50}')
    local darkColor = CALC(params[3], '{191, 127, 255, 100}')

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object._effect = \'filter.duotone\''
    GAME.lua = GAME.lua .. ' local lightColor = ' .. lightColor
    GAME.lua = GAME.lua .. ' local darkColor = ' .. darkColor
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.duotone\''
    GAME.lua = GAME.lua .. ' object.fill.effect.lightColor = { lightColor[1] / 255, lightColor[2] / 255, lightColor[3] / 255, lightColor[4] / 100}'
    GAME.lua = GAME.lua .. ' object.fill.effect.darkColor = { darkColor[1] / 255, darkColor[2] / 255, darkColor[3] / 255, darkColor[4] / 100}'
    GAME.lua = GAME.lua .. ' end)'
end

M['setColorPolynomial'] = function(params)
    local name = CALC(params[1])
    local CoefficientR = CALC(params[2], '{0, 0, 255, 0}')
    local CoefficientG = CALC(params[3], '{0, 0, 255, 0}')
    local CoefficientB = CALC(params[4], '{0, 255, 0, 0}')
    local CoefficientA = CALC(params[5], '{0, 0, 0, 100}')

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object._effect = \'filter.colorPolynomial\''
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.colorPolynomial\''
    GAME.lua = GAME.lua .. ' local CoefficientR = ' .. CoefficientR
    GAME.lua = GAME.lua .. ' local CoefficientG = ' .. CoefficientG
    GAME.lua = GAME.lua .. ' local CoefficientB = ' .. CoefficientB
    GAME.lua = GAME.lua .. ' local CoefficientA = ' .. CoefficientA
    GAME.lua = GAME.lua .. ' object.fill.effect.coefficients = {CoefficientR[1] / 255, CoefficientR[2] / 255, CoefficientR[3] / 255, CoefficientR[4] / 100,'
    GAME.lua = GAME.lua .. ' CoefficientG[1] / 255, CoefficientG[2] / 255, CoefficientG[3] / 255, CoefficientG[4] / 100,'
    GAME.lua = GAME.lua .. ' CoefficientB[1] / 255, CoefficientB[2] / 255, CoefficientB[3] / 255, CoefficientB[4] / 100,'
    GAME.lua = GAME.lua .. ' CoefficientA[1] / 255, CoefficientA[2] / 255, CoefficientA[3] / 255, CoefficientA[4] / 100}'
    GAME.lua = GAME.lua .. ' end)'
end

M['setColorMatrix'] = function(params)
    local name = CALC(params[1])
    local CoefficientR = CALC(params[2], '{0, 0, 255, 0}')
    local CoefficientG = CALC(params[3], '{0, 0, 255, 0}')
    local CoefficientB = CALC(params[4], '{0, 255, 0, 0}')
    local CoefficientA = CALC(params[5], '{0, 0, 0, 100}')

    GAME.lua = GAME.lua .. ' pcall(function() local name = ' .. name
    GAME.lua = GAME.lua .. ' local object = GAME.group.objects[name]'
    GAME.lua = GAME.lua .. ' object.fill.effect = nil'
    GAME.lua = GAME.lua .. ' object._effect = \'filter.colorMatrix\''
    GAME.lua = GAME.lua .. ' object.fill.effect = \'filter.colorMatrix\''
    GAME.lua = GAME.lua .. ' local CoefficientR = ' .. CoefficientR
    GAME.lua = GAME.lua .. ' local CoefficientG = ' .. CoefficientG
    GAME.lua = GAME.lua .. ' local CoefficientB = ' .. CoefficientB
    GAME.lua = GAME.lua .. ' local CoefficientA = ' .. CoefficientA
    GAME.lua = GAME.lua .. ' object.fill.effect.coefficients = {CoefficientR[1] / 255, CoefficientR[2] / 255, CoefficientR[3] / 255, CoefficientR[4] / 100,'
    GAME.lua = GAME.lua .. ' CoefficientG[1] / 255, CoefficientG[2] / 255, CoefficientG[3] / 255, CoefficientG[4] / 100,'
    GAME.lua = GAME.lua .. ' CoefficientB[1] / 255, CoefficientB[2] / 255, CoefficientB[3] / 255, CoefficientB[4] / 100,'
    GAME.lua = GAME.lua .. ' CoefficientA[1] / 255, CoefficientA[2] / 255, CoefficientA[3] / 255, CoefficientA[4] / 100}'
    GAME.lua = GAME.lua .. ' end)'
end

return M
