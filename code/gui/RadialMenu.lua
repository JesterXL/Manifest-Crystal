require "gui.RadialMenuItem"
RadialMenu = {}

function RadialMenu:new()

	local menu = display.newGroup()
	menu.offset = 90
	menu.radius = 100
	menu.menuVOArray = nil

	function menu:getPointFromRadian(radian)
		return math.cos(radian), math.sin(radian)
	end

	function menu:getObjectPosition(index, itemsLen, offset, radius)
		local degree = 360 / itemsLen * index + offset
		local pX, pY = self:getPointFromRadian(math.rad(degree))
		pX = pX * radius
		pY = pY * radius
		return pX, pY
	end

	function menu:build(menuVOArray)
		assert(menuVOArray, "menuVOArray cannot be nil")
		assert(table.maxn(menuVOArray) > 0, "menuVOArray cannot be empty")
		self:destroy()

		self.menuVOArray = menuVOArray
		local i
		local offset = self.offset
		local radius = self.radius
		for i=1,#menuVOArray do
			local vo = menuVOArray[i]
			local item = RadialMenuItem:new(vo)
			function item:touch(event)
				menu:dispatchEvent({name="onRadialMenuItemTouched", phase=event.phase, menuVO=self.menuVO, x=event.x, y=event.y})
				return true
			end
			item:addEventListener("touch", item)

			self["item" .. i] = item
			self:insert(item)

			local pX, pY = self:getObjectPosition(i, #menuVOArray, offset, radius)
			transition.to(item, {x=pX, y=pY, time=500, transition=easing.outExpo})
		end
	end

	function menu:destroy()
		self.menuVOArray = nil
		local len = self.numChildren
		while len > 0 do
			local item = self["item" .. len]
			self["item" .. len] = nil
			item:removeEventListener("touch", item)
			item:removeSelf()
			len = len - 1
		end
	end





	return menu

end

return RadialMenu