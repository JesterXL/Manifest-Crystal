BattleMenu        = {}
BattleMenu.ATTACK = "Attack"
BattleMenu.DEFEND = "Defend"
BattleMenu.ITEM   = "Item"
BattleMenu.RUN    = "Run"

function BattleMenu:new()
	local menu = display.newGroup()

	function menu:showActions()
		self:redraw()
	end

	function menu:redraw()
		self:destroy()

		local items = {BattleMenu.ATTACK,
						BattleMenu.DEFEND,
						BattleMenu.ITEM,
						BattleMenu.RUN}
		local i
		local startX = 100
		local startY = 30
		for i=1,#items do
			local item = items[i]
			local field = display.newText(self, item, startX, startY, native.systemFont, 46)
			startY = startY + field.height + 16
			function field:touch(e)
				if e.phase == "ended" then
					menu:dispatchEvent({name="onBattleMenuActionTouched", target=self, action=self.text})
					return true
				end
			end
			field:addEventListener("touch", field)
		end
	end

	function menu:destroy()
		local len = self.numChildren
		while len > 0 do
			local field = self[len]
			field:removeSelf()
			len = len - 1
		end
	end

	return menu
end

return BattleMenu