MonsterSprite = {}

function MonsterSprite:new()
	local sprite = display.newCircle(0, 0, 30)
	sprite:setFillColor(255, 0, 0, 150)
	sprite.monster = nil
	sprite.enabled = false
	sprite.originalX = 0
	sprite.originalY = 0

	function sprite:touch(event)
		if event.phase == "ended" then
			self:dispatchEvent({name="onMonsterSpriteTouched", target=self})
			return true
		end
	end

	function sprite:enableTouch(enable)
		if enable ~= self.enabled then
			self.enabled = enable
			if enable then
				self.strokeWidth = 3
				self:setStrokeColor(255, 255, 0)
				self:addEventListener("touch", self)
			else
				self:removeEventListener("touch", self)
				self.strokeWidth = 0
			end
		end
	end

	return sprite
end

return MonsterSprite