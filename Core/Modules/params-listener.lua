local COLOR = require 'Core.Modules.interface-color'
local LIST = require 'Core.Modules.interface-list'
local M = {}

M.getListButtons = function(type)
    if type == 'body' then
        return {STR['blocks.select.dynamic'], STR['blocks.select.static']}
    elseif type == 'animation' then
        return {STR['blocks.select.forward'], STR['blocks.select.bounce']}
    elseif type == 'rule' then
        return {STR['blocks.select.ruleTrue'], STR['blocks.select.ruleFalse']}
    elseif type == 'isBackground' then
        return {STR['blocks.select.backgroundTrue'], STR['blocks.select.backgroundFalse']}
    elseif type == 'textAlign' then
        return {STR['blocks.select.alignLeft'], STR['blocks.select.alignRight'], STR['blocks.select.alignCenter']}
    elseif type == 'switchType' then
        return {STR['blocks.select.switchRadio'], STR['blocks.select.switchCheckbox'], STR['blocks.select.switchToggle']}
    elseif type == 'switchState' then
        return {STR['blocks.select.switchOff'], STR['blocks.select.switchOn']}
    elseif type == 'adsType' then
        return {STR['blocks.select.adsInterstitial'], STR['blocks.select.adsRewardedVideo'], STR['blocks.select.adsVideo']}
    elseif type == 'networkProgress' then
        return {STR['blocks.select.progressDefault'], STR['blocks.select.progressDownload'], STR['blocks.select.progressUpload']}
    elseif type == 'networkRedirects' then
        return {STR['blocks.select.redirectsTrue'], STR['blocks.select.redirectsFalse']}
    elseif type == 'canvasMode' then
        return {STR['blocks.select.canvasModeAppend'], STR['blocks.select.canvasModeDiscard']}
    elseif type == 'snapshotType' then
        return {STR['blocks.select.snapshotGroup'], STR['blocks.select.snapshotCanvas']}
    elseif type == 'fileType' then
        return {STR['blocks.select.fileTypeNonBin'], STR['blocks.select.fileTypeBin']}
    elseif type == 'docType' then
        return {STR['blocks.select.docTypeDocs'], STR['blocks.select.docTypeTemps']}
    elseif type == 'spriteType' then
        return {STR['blocks.select.spriteTypePixel'], STR['blocks.select.spriteTypeLinear']}
    elseif type == 'inputType' then
        return {
            STR['blocks.select.inputDefault'],
            STR['blocks.select.inputNumber'],
            STR['blocks.select.inputDecimal'],
            STR['blocks.select.inputPhone'],
            STR['blocks.select.inputUrl'],
            STR['blocks.select.inputEmail'],
            STR['blocks.select.inputNoEmoji']
        }
    elseif type == 'noobName' then
        return {
            STR['blocks.select.pic'],
            STR['blocks.select.text'],
            STR['blocks.select.group'],
            STR['blocks.select.tag']
        }
    elseif type == 'captureName' then
        return {
            STR['blocks.select.obj'],
            STR['blocks.select.group']
        }
    elseif type == 'snapshotName' then
        return {
            STR['blocks.select.obj'],
            STR['blocks.select.text'],
            STR['blocks.select.group'],
            STR['blocks.select.tag'],
            STR['blocks.select.snapshot']
        }
    elseif type == 'cameraName' then
        return {
            STR['blocks.select.obj'],
            STR['blocks.select.text'],
            STR['blocks.select.group'],
            STR['blocks.select.snapshot']
        }
    elseif type == 'transitName' then
        return {
            STR['blocks.select.obj'],
            STR['blocks.select.text'],
            STR['blocks.select.group'],
            STR['blocks.select.tag'],
            STR['blocks.select.widget'],
            STR['blocks.select.snapshot']
        }
    elseif type == 'particlesName' then
        return {
            'air_stars', 'aurora', 'orange_flame', 'blood', 'blue_galaxy', 'blue_vortex',
            'bp_firefly', 'comet', 'crazy_blue', 'electrons', 'fireplace_flame', 'giving',
            'heart', 'hongshizi', 'im_seeing_stars', 'lava_flow', 'my_galaxy',
            'smoke', 'trippy', 'water_fountain', 'waterfall', 'wdemitter'
        }
    elseif type == 'transitEasing' then
        return {
            'linear', 'loop', 'inQuad', 'outQuad', 'inOutQuad', 'outInQuad',
            'inQuart', 'outQuart', 'inOutQuart', 'outInQuart', 'inExpo', 'outExpo', 'inOutExpo', 'outInExpo',
            'inCirc', 'outCirc', 'inOutCirc', 'outInCirc', 'inBack', 'outBack', 'inOutBack', 'outInBack',
            'inElastic', 'outElastic', 'inOutElastic', 'outInElastic', 'inBounce', 'outBounce', 'inOutBounce', 'outInBounce'
        }
    end
end

M.getListValue = function(type, text)
    if type == 'body' then
        return text == STR['blocks.select.dynamic'] and 'dynamic' or 'static'
    elseif type == 'animation' then
        return text == STR['blocks.select.forward'] and 'forward' or 'bounce'
    elseif type == 'rule' then
        return text == STR['blocks.select.ruleTrue'] and 'ruleTrue' or 'ruleFalse'
    elseif type == 'isBackground' then
        return text == STR['blocks.select.backgroundTrue'] and 'backgroundTrue' or 'backgroundFalse'
    elseif type == 'networkRedirects' then
        return text == STR['blocks.select.redirectsFalse'] and 'redirectsFalse' or 'redirectsTrue'
    elseif type == 'switchState' then
        return text == STR['blocks.select.switchOff'] and 'switchOff' or 'switchOn'
    elseif type == 'adsType' then
        return text == STR['blocks.select.adsRewardedVideo'] and 'adsRewardedVideo'
            or text == STR['blocks.select.adsVideo'] and 'adsVideo' or 'adsInterstitial'
    elseif type == 'textAlign' then
        return text == STR['blocks.select.alignLeft'] and 'alignLeft'
            or text == STR['blocks.select.alignRight'] and 'alignRight' or 'alignCenter'
    elseif type == 'switchType' then
        return text == STR['blocks.select.switchRadio'] and 'switchRadio'
            or text == STR['blocks.select.switchToggle'] and 'switchToggle' or 'switchCheckbox'
    elseif type == 'networkProgress' then
        return text == STR['blocks.select.progressUpload'] and 'progressUpload'
            or text == STR['blocks.select.progressDownload'] and 'progressDownload' or 'progressDefault'
    elseif type == 'canvasMode' then
        return text == STR['blocks.select.canvasModeDiscard'] and 'canvasModeDiscard' or 'canvasModeAppend'
    elseif type == 'snapshotType' then
        return text == STR['blocks.select.snapshotCanvas'] and 'snapshotCanvas' or 'snapshotGroup'
    elseif type == 'fileType' then
        return text == STR['blocks.select.fileTypeBin'] and 'fileTypeBin' or 'fileTypeNonBin'
    elseif type == 'docType' then
        return text == STR['blocks.select.docTypeTemps'] and 'docTypeTemps' or 'docTypeDocs'
    elseif type == 'spriteType' then
        return text == STR['blocks.select.spriteTypeLinear'] and 'spriteTypeLinear' or 'spriteTypePixel'
    elseif type == 'captureName' then
        return text == STR['blocks.select.group'] and 'group' or 'obj'
    elseif type == 'inputType' then
        return text == STR['blocks.select.inputDefault'] and 'inputDefault'
            or text == STR['blocks.select.inputNumber'] and 'inputNumber'
            or text == STR['blocks.select.inputDecimal'] and 'inputDecimal'
            or text == STR['blocks.select.inputPhone'] and 'inputPhone'
            or text == STR['blocks.select.inputUrl'] and 'inputUrl'
            or text == STR['blocks.select.inputEmail'] and 'inputEmail' or 'inputNoEmoji'
    elseif type == 'noobName' then
        return text == STR['blocks.select.pic'] and 'pic'
            or text == STR['blocks.select.text'] and 'text'
            or text == STR['blocks.select.group'] and 'group'
            or text == STR['blocks.select.tag'] and 'tag' or 'pic'
    elseif type == 'cameraName' then
        return text == STR['blocks.select.obj'] and 'obj'
            or text == STR['blocks.select.text'] and 'text'
            or text == STR['blocks.select.group'] and 'group'
            or text == STR['blocks.select.snapshot'] and 'snapshot' or 'obj'
    elseif type == 'snapshotName' then
        return text == STR['blocks.select.obj'] and 'obj'
            or text == STR['blocks.select.text'] and 'text'
            or text == STR['blocks.select.group'] and 'group'
            or text == STR['blocks.select.tag'] and 'tag'
            or text == STR['blocks.select.snapshot'] and 'snapshot' or 'obj'
    elseif type == 'transitName' then
        return text == STR['blocks.select.obj'] and 'obj'
            or text == STR['blocks.select.text'] and 'text'
            or text == STR['blocks.select.group'] and 'group'
            or text == STR['blocks.select.tag'] and 'tag'
            or text == STR['blocks.select.snapshot'] and 'snapshot'
            or text == STR['blocks.select.widget'] and 'widget' or 'obj'
    elseif type == 'particlesName' then
        return text or 'air_stars'
    elseif type == 'transitEasing' then
        return text or 'linear'
    else
        return nil
    end
end

M.open = function(target)
    local BLOCK = require 'Core.Modules.logic-block'
    local LOGIC = require 'Core.Modules.logic-input'
    local data = GET_GAME_CODE(CURRENT_LINK)
    local script = GET_GAME_SCRIPT(CURRENT_LINK, CURRENT_SCRIPT, data)
    local paramsIndex = target.index
    local blockName = target.parent.parent.data.name
    local blockY = target.parent.parent.y
    local blockIndex = target.parent.parent.getIndex(target.parent.parent)
    local scrollY = select(2, BLOCKS.scroll:getContentPosition())
    local paramsData = script.params[blockIndex].params[paramsIndex]
    local diffScrollY = BLOCKS.scroll.y - BLOCKS.scroll.height / 2
    local listDirection = blockY + target.y + scrollY + diffScrollY > CENTER_Y and 'up' or 'down'
    local listY = blockY + scrollY + target.y + diffScrollY + (listDirection == 'up' and target.height or -target.height) - 10
    local listX, type = CENTER_X + target.x + target.width / 2, INFO.listName[blockName][paramsIndex + 1][1]
    local paramsText = BLOCKS.group.blocks[blockIndex].params[paramsIndex].value.text

    if type == 'text' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        INPUT.new(STR['blocks.entertext'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                INPUT.remove(true, event.target.text)
            end
        end, function(e)
            if e.input then
                script.params[blockIndex].params[paramsIndex][1] = {e.text, 't'}
                target.parent.parent.data.params[paramsIndex][1] = {e.text, 't'}
                target.parent.parent.params[paramsIndex].value.text = BLOCK.getParamsValueText(target.parent.parent.data.params, paramsIndex)
                SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
            end BLOCKS.group[8]:setIsLocked(false, 'vertical')
        end, (paramsData[1] and paramsData[1][1]) and paramsData[1][1] or '') native.setKeyboardFocus(INPUT.box)
    elseif type == 'value' and ALERT then
        EDITOR = require 'Core.Editor.interface'
        EDITOR.create(blockName, blockIndex, paramsData, paramsIndex)
    elseif type == 'var' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        LOGIC.new('vars', blockIndex, paramsIndex, COPY_TABLE(paramsData))
    elseif type == 'vars' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        LOGIC.new('vars', blockIndex, paramsIndex, COPY_TABLE(paramsData), nil, nil, true)
    elseif type == 'localvar' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        LOGIC.new('vars', blockIndex, paramsIndex, COPY_TABLE(paramsData), true)
    elseif type == 'table' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        LOGIC.new('tables', blockIndex, paramsIndex, COPY_TABLE(paramsData))
    elseif type == 'localtable' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        LOGIC.new('tables', blockIndex, paramsIndex, COPY_TABLE(paramsData), true)
    elseif type == 'fun' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        LOGIC.new('funs', blockIndex, paramsIndex, COPY_TABLE(paramsData))
    elseif type == 'color' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        COLOR.new(COPY_TABLE((paramsData[1] and paramsData[1][1]) and JSON.decode(paramsData[1][1]) or {255, 255, 255, 255}), function(e)
            if e.input then
                script.params[blockIndex].params[paramsIndex][1] = {e.rgb, 'c'}
                target.parent.parent.data.params[paramsIndex][1] = {e.rgb, 'c'}
                target.parent.parent.params[paramsIndex].value.text = BLOCK.getParamsValueText(target.parent.parent.data.params, paramsIndex)
                SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
            end BLOCKS.group[8]:setIsLocked(false, 'vertical')
        end)
    elseif M.getListValue(type) and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        LIST.new(M.getListButtons(type), listX, listY, listDirection, function(e)
            if e.index > 0 then
                script.params[blockIndex].params[paramsIndex][1] = {M.getListValue(type, e.text), 'sl'}
                target.parent.parent.data.params[paramsIndex][1] = {M.getListValue(type, e.text), 'sl'}
                target.parent.parent.params[paramsIndex].value.text = BLOCK.getParamsValueText(target.parent.parent.data.params, paramsIndex)
                SET_GAME_SCRIPT(CURRENT_LINK, script, CURRENT_SCRIPT, data)
            end BLOCKS.group[8]:setIsLocked(false, 'vertical')
        end, paramsText)
    end
end

return M
