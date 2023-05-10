local M = {}

M['dynamic'] = function()
    return 'dynamic'
end

M['static'] = function()
    return 'static'
end

M['forward'] = function()
    return 'forward'
end

M['bounce'] = function()
    return 'bounce'
end

M['backgroundTrue'] = function()
    return true
end

M['backgroundFalse'] = function()
    return false
end

M['canvasModeAppend'] = function()
    return 'append'
end

M['canvasModeDiscard'] = function()
    return 'discard'
end

M['snapshotGroup'] = function()
    return 'group'
end

M['snapshotCanvas'] = function()
    return 'canvas'
end

M['ruleTrue'] = function()
    return true
end

M['ruleFalse'] = function()
    return false
end

M['alignLeft'] = function()
    return 'left'
end

M['alignRight'] = function()
    return 'right'
end

M['alignCenter'] = function()
    return 'center'
end

M['inputDefault'] = function()
    return 'default'
end

M['inputNumber'] = function()
    return 'number'
end

M['inputDecimal'] = function()
    return 'decimal'
end

M['inputPhone'] = function()
    return 'phone'
end

M['inputUrl'] = function()
    return 'url'
end

M['inputEmail'] = function()
    return 'email'
end

M['inputNoEmoji'] = function()
    return 'noemoji'
end

M['pic'] = function()
    return 'objects'
end

M['obj'] = function()
    return 'objects'
end

M['text'] = function()
    return 'texts'
end

M['group'] = function()
    return 'groups'
end

M['widget'] = function()
    return 'widgets'
end

M['snapshot'] = function()
    return 'snapshots'
end

M['tag'] = function()
    return 'tags'
end

M['switchRadio'] = function()
    return 'radio'
end

M['switchToggle'] = function()
    return 'onOff'
end

M['switchCheckbox'] = function()
    return 'checkbox'
end

M['switchOn'] = function()
    return true
end

M['switchOff'] = function()
    return false
end

M['fileTypeBin'] = function()
    return true
end

M['fileTypeNonBin'] = function()
    return false
end

M['docTypeDocs'] = function()
    return 'Documents'
end

M['docTypeTemps'] = function()
    return 'Temps'
end

M['spriteTypeLinear'] = function()
    return 'linear'
end

M['spriteTypePixel'] = function()
    return 'nearest'
end

M['adsInterstitial'] = function()
    return 'interstitial'
end

M['adsRewardedVideo'] = function()
    return 'rewardedVideo'
end

M['adsVideo'] = function()
    return 'video'
end

return M
