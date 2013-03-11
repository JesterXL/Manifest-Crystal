require "gui.RadialMenuItem"
RadialMenu = {}

function RadialMenu:new()

	local menu = display.newGroup()
	menu.classType = "RadialMenu"
	menu.offset = 90
	menu.circleSize = 360
	menu.radius = nil
	menu.menuVOArray = nil
	menu.callbackScope = nil
	menu.callbackFunction = nil
	menu.bg = nil

	function menu:getPointFromRadian(radian)
		--print("radian:", radian)
		return math.cos(radian), math.sin(radian)
	end

	function menu:getObjectPosition(index, itemsLen, offset, radius)
		local degree = self.circleSize / itemsLen * index + offset
		local pX, pY = self:getPointFromRadian(math.rad(degree))
		pX = pX * radius
		pY = pY * radius
		return pX, pY, degree
	end

	function menu:calculateRadiusBasedOnStage()
		self.radius = (math.min(stage.width, stage.height) / 3)
	end

	function menu:build(menuVOArray, buildOptions)
		assert(menuVOArray, "menuVOArray cannot be nil")
		assert(table.maxn(menuVOArray) > 0, "menuVOArray cannot be empty")
		self:destroy()


		self:calculateRadiusBasedOnStage() 
		self.menuVOArray = menuVOArray
		--print("building " .. #menuVOArray .. " items")
		local i
		local radius = self.radius
		if buildOptions and buildOptions.radiusSize == "small" then
			radius = math.min(self.radius, (math.min(stage.width, stage.height) / 6))
		end

		if buildOptions and buildOptions.area then
			local area = buildOptions.area
			if area == "topLeft" then
				self.circleSize = 180
				self.offset = 90
			elseif area == "left" then
				self.circleSize = 180
				self.offset = 70
			elseif area == "topRight" then
				self.circleSize = 180
				self.offset = 200
			elseif area == "right" then
				self.circleSize = 180
				self.offset = 245
			elseif area == "top" then
				self.circleSize = 180
				self.offset = 160
			elseif area == "bottom" then
				self.circleSize = 180
				self.offset = 340	
			else
				self.offset = 90
				self.circleSize = 360
			end
		end

		if buildOptions and buildOptions.offset then
			self.offset = buildOptions.offset
		end

		if buildOptions and buildOptions.circleSize then
			self.circleSize = buildOptions.circleSize
		end

		local offset = self.offset
		for i=1,#menuVOArray do
			local vo = menuVOArray[i]
			local item = RadialMenuItem:new(vo)
			function item:touch(event)
				--menu:dispatchEvent({name="onRadialMenuItemTouched", 
					--phase=event.phase, menuVO=self.menuVO, 
					--x=event.x, y=event.y})
				menu:executeCallback({phase=event.phase, menuVO=self.menuVO, x=event.x, y=event.y, item=self})
				return true
			end
			item:addEventListener("touch", item)

			self["item" .. i] = item
			--print("item " .. i, " item:", self["item" .. i])
			self:insert(item)

			local pX, pY, rDegree = self:getObjectPosition(i, #menuVOArray, offset, radius)
			item.degree = rDegree
			transition.to(item, {x=pX, y=pY, time=500, transition=easing.outExpo})
			--item.x = pX
			--item.y = pY
			--print(offset, radius, pX, pY)
		end

		--local bg = display.newRect(0, 0, self.width, self.height)
		--local bg = display.newCircle(0, 0, 10)
		local bg = display.newLine(0, 0, 0, 72)
		bg:setColor(0, 255, 0, 0)
		--bg:setFillColor(0, 255, 0, 0)
		self:insert(bg)
		bg:toBack()
		self.bg = bg
	end

	function menu:setCallback(scope, func)
		self.callbackScope = scope
		self.callbackFunction = func
	end

	function menu:executeCallback(args)
		if self.callbackFunction and self.callbackScope then
			--self.callbackFunction(self.callbackScope, args)
			self.callbackScope[self.callbackFunction](self.callbackScope, args)
		end
	end

	function menu:destroy()
		self.menuVOArray = nil
		if self.bg then
			self.bg:removeSelf()
			self.bg = nil
		end

		local len = self.numChildren
		while len > 0 do
			local item = self["item" .. len]
			assert(item, "Error using item naming scheme.")
			self["item" .. len] = nil
			item:removeEventListener("touch", item)
			item:removeSelf()
			len = len - 1
		end
		--self:setMenuItemTouchedCallback()
	end





	return menu

end

return RadialMenu