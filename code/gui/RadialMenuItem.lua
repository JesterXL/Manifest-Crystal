RadialMenuItem = {}

function RadialMenuItem:new(menuVO)

	local menu = display.newGroup()
	menu.menuVO = nil

	function menu:init(menuVO)
		local bg = display.newRect(0, 0, 72, 72)
		--local bg = display.newCircle(0, 0, 10)
		bg:setFillColor(0, 0, 255, 0)
		self:insert(bg)
		self.bg = bg

		self.menuVO = menuVO
		local field = display.newText(self, menuVO.label, 0, 0, native.systemFont, 18)
		field:setReferencePoint(display.TopLeftReferencePoint)
		self.field = field
		field:setTextColor(255, 255, 255)

		
		local icon
		if menuVO.icon then
			if type(menuVO.icon) == "string" then
				icon = display.newImage(menuVO.icon)
			else
				icon = menuVO.icon
			end
		else
			icon = display.newCircle(0, 0, 20)
			icon.x = icon.width / 2
		end
		self:insert(icon)
		self.icon = icon


		field.x = 72 / 2 - field.width / 2
		icon.y = field.y + field.height + icon.height / 2 + 4
		icon.x = 72 / 2


	end

	function menu:destroy()
		self.bg:removeSelf()
		self.field:removeSelf()
		if self.icon then
			self.icon:removeSelf()
			self.icon = nil
		end
		self.menuVO = nil
		self:removeSelf()
	end

	menu:init(menuVO)

	return menu

end

return RadialMenuItem