CharacterSprite = {}

function CharacterSprite:new()
	local character = display.newRect(0, 0, 30, 30)
	character:setFillColor(0, 255, 0, 150)
	character.character = nil
	character.enabled = false

	function character:touch(event)
		if event.phase == "ended" then
			self:dispatchEvent({name="onCharacterSpriteTouched", target=self})
			return true
		end
	end

	function character:enableTouch(enable)
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

	return character
end

return CharacterSprite