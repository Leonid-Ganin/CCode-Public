local lib_perspective = {}

local display_newGroup = display.newGroup
local display_remove = display.remove
local type = type
local table_insert = table.insert
local math_huge = math.huge
local math_nhuge = -math.huge

local clamp = function(v, l, h) return (v < l and l) or (v > h and h) or v end

lib_perspective.createView = function(layerCount)
	local view = display_newGroup()
	view.damping = 1
	view.snapWhenFocused = true

	local isTracking
	local prependedLayers = 0

	local internal
	internal = {
		trackingLevel = 1,
		damping = 1,
		scaleBoundsToScreen = true,
		xScale = 1,
		yScale = 1,
		xOffset = 0,
		yOffset = 0,
		addX = CENTER_X,
		addY = CENTER_Y,
		bounds = {
			xMin = math_nhuge,
			xMax = math_huge,
			yMin = math_nhuge,
			yMax = math_huge
		},
		scaledBounds = {
			xMin = math_nhuge,
			xMax = math_huge,
			yMin = math_nhuge,
			yMax = math_huge
		},
		trackFocus = true,
		focus = nil,
		viewX = 0,
		viewY = 0,
		getViewXY = function() if internal.focus then return internal.focus.x, internal.focus.y else return internal.viewX, internal.viewY end end,
		layer = {},
		updateAddXY = function() internal.addX = CENTER_X / view.xScale internal.addY = CENTER_Y / view.yScale end
	}

	local layers = {}

	internal.scaleBounds = function(doX, doY)
		if internal.scaleBoundsToScreen then
			local xMin = internal.bounds.xMin
			local xMax = internal.bounds.xMax
			local yMin = internal.bounds.yMin
			local yMax = internal.bounds.yMax

			local doX = doX and not ((xMin == math_nhuge) or (xMax == math_huge))
			local doY = doY and not ((yMin == math_nhuge) or (yMax == math_huge))

			if doX then
				local scaled_xMin = xMin / view.xScale
				local scaled_xMax = xMax - (scaled_xMin - xMin)

				if scaled_xMax < scaled_xMin then
					local hopDist = scaled_xMin - scaled_xMax
					local halfDist = hopDist * 0.5
					scaled_xMax = scaled_xMax + halfDist
					scaled_xMin = scaled_xMin - halfDist
				end

				internal.scaledBounds.xMin = scaled_xMin
				internal.scaledBounds.xMax = scaled_xMax
			end

			if doY then
				local scaled_yMin = yMin / view.yScale
				local scaled_yMax = yMax - (scaled_yMin - yMin)

				if scaled_yMax < scaled_yMin then
					local hopDist = scaled_yMin - scaled_yMax
					local halfDist = hopDist * 0.5
					scaled_yMax = scaled_yMax + halfDist
					scaled_yMin = scaled_yMin - halfDist
				end

				internal.scaledBounds.yMin = scaled_yMin
				internal.scaledBounds.yMax = scaled_yMax
			end
		else
			camera.scaledBounds.xMin, camera.scaledBounds.xMax, camera.scaledBounds.yMin, camera.scaledBounds.yMax = camera.bounds.xMin, camera.bounds.xMax, camera.bounds.yMin, camera.bounds.yMax
		end
	end

	internal.processViewpoint = function()
		if internal.damping ~= view.damping then internal.trackingLevel = 1 / view.damping internal.damping = view.damping end
		if internal.trackFocus then
			local x, y = internal.getViewXY()

			if view.xScale ~= internal.xScale or view.yScale ~= internal.yScale then internal.updateAddXY() end
			if view.xScale ~= internal.xScale then internal.xScale = view.xScale internal.scaleBounds(true, false) end
			if view.yScale ~= internal.yScale then internal.yScale = view.yScale internal.scaleBounds(false, true) end

			x = clamp(x, internal.scaledBounds.xMin, internal.scaledBounds.xMax)
			y = clamp(y, internal.scaledBounds.yMin, internal.scaledBounds.yMax)
			internal.viewX, internal.viewY = x, y
		end
	end

	view.appendLayer = function()
		local layer = display_newGroup()
		layer.xParallax, layer.yParallax = 1, 1
		view:insert(layer)
		layer:toBack()
		table_insert(layers, layer)

		layer._perspectiveIndex = #layers

		internal.layer[#layers] = {
			x = 0,
			y = 0,
			xOffset = 0,
			yOffset = 0
		}

		function layer:setCameraOffset(x, y) internal.layer[layer._perspectiveIndex].xOffset, internal.layer[layer._perspectiveIndex].yOffset = x, y end
	end

	view.prependLayer = function()
		view.appendLayer()

		layers[#layers]:toFront()
		layers[-prependedLayers] = layers[#layers]
		internal.layer[-prependedLayers] = internal.layer[#internal.layer]
		table.remove(layers, #layers)
		table.remove(internal.layer, #internal.layer)
		layers[-prependedLayers]._perspectiveIndex = -prependedLayers

		prependedLayers = prependedLayers + 1
	end

	function view:add(obj, l, isFocus)
		local l = l or 4
		layers[l]:insert(obj)
		obj._perspectiveLayer = l

		if isFocus then view:setFocus(obj) end
		function obj:toLayer(newLayer) if layer[newLayer] then layer[newLayer]:insert(obj) obj._perspectiveLayer = newLayer end end
		function obj:back() if layer[obj._perspectiveLayer + 1] then layer[obj._perspectiveLayer + 1]:insert(obj) obj._perspectiveLayer = obj.layer + 1 end end
		function obj:forward() if layer[obj._perspectiveLayer - 1] then layer[obj._perspectiveLayer - 1]:insert(obj) obj._perspectiveLayer = obj.layer - 1 end end
		function obj:toCameraFront() layer[1]:insert(obj) obj._perspectiveLayer = 1 obj:toFront() end
		function obj:toCameraBack() layer[#layers]:insert(obj) obj._perspectiveLayer = #layers obj:toBack() end
	end

	function view:trackFocus()
		internal.processViewpoint()
		local viewX, viewY = internal.viewX, internal.viewY

		layers[1].xParallax, layers[1].yParallax = 1, 1

		for i = -prependedLayers + 1, #layers do
			local addX, addY = internal.addX, internal.addY
			local layerX, layerY = internal.layer[i].x, internal.layer[i].y

			local diffX = (-viewX - layerX)
			local diffY = (-viewY - layerY)
			local incrX = diffX
			local incrY = diffY
			internal.layer[i].x = layerX + incrX + internal.layer[i].xOffset + internal.xOffset
			internal.layer[i].y = layerY + incrY + internal.layer[i].yOffset + internal.yOffset

			layers[i].x = (layers[i].x - (layers[i].x - (internal.layer[i].x + addX) * layers[i].xParallax) * internal.trackingLevel)
			layers[i].y = (layers[i].y - (layers[i].y - (internal.layer[i].y + addY) * layers[i].yParallax) * internal.trackingLevel)
		end

		view.scrollX, view.scrollY = layers[1].x, layers[1].y
	end

	function view:setBounds(x1, x2, y1, y2)
		local xMin, xMax, yMin, yMax

		if x1 ~= nil then if not x1 then xMin = math_nhuge else xMin = x1 end end
		if x2 ~= nil then if not x2 then xMax = math_huge else xMax = x2 end end
		if y1 ~= nil then if not y1 then yMin = math_nhuge else yMin = y1 end end
		if y2 ~= nil then if not y2 then yMax = math_huge else yMax = y2 end end

		internal.bounds.xMin = xMin
		internal.bounds.xMax = xMax
		internal.bounds.yMin = yMin
		internal.bounds.yMax = yMax
		internal.scaleBounds(true, true)
	end

	function view:track() if not isTracking then Runtime:addEventListener("enterFrame", view.trackFocus) isTracking = true end end
	function view:cancel() if isTracking then Runtime:removeEventListener("enterFrame", view.trackFocus) isTracking = false end end
	function view:remove(obj) if obj and obj._perspectiveLayer then layers[obj._perspectiveLayer]:remove(obj) end end
	function view:setFocus(obj) if obj then internal.focus = obj end if view.snapWhenFocused then view.snap() end end
	function view:snap() local t = internal.trackingLevel local d = internal.damping internal.trackingLevel = 1 internal.damping = view.damping view:trackFocus() internal.trackingLevel = t internal.damping = d end
	function view:toPoint(x, y) view:cancel() local newFocus = {x = x, y = y} view:setFocus(newFocus) view:track() return newFocus end
	function view:layer(n) return layers[n] end
	function view:layers() return layers end
	function view:destroy() view:cancel() for i = 1, #layers do display_remove(layers[i]) end display_remove(view) view = nil return true end
	function view:setParallax(...) for i = 1, #arg do if type(arg[i]) == "table" then layers[i].xParallax, layers[i].yParallax = arg[i][1], arg[i][2] else layers[i].xParallax, layers[i].yParallax = arg[i], arg[i] end end end
	function view:layerCount() return #layers end
	function view:setMasterOffset(x, y) internal.xOffset, internal.yOffset = x, y end

	for i = layerCount or 8, 1, -1 do view.appendLayer() end

	return view
end

return lib_perspective
