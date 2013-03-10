RadialMenuItem = {}

function RadialMenuItem:new(menuVO)

	local menu = display.newGroup()
	menu.menuVO = nil

	function menu:init(menuVO)
		self.menuVO = menuVO
		local field = display.newText(self, menuVO.label, 0, 0, native.systemFont, 14)
		self.field = field
		field:setTextColor(255, 255, 255)

		
		if menuVO.icon then
			local icon
			if type(menuVO.icon) == "string" then
				icon = display.newImage(menuVO.icon)
			else
				icon = menuVO.icon
			end
			self:insert(icon)
			self.icon = icon
			icon.y = field.y + field.height + icon.height / 2
		end
	end

	function menu:destroy()
		self.field:removeSelf()
		if self.icon then
			self.icon:removeSelf()
		end
		self.menuVO = nil
		self:removeSelf()
	end

	menu:init(menuVO)

	return menu

end

return RadialMenuItem