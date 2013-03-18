require "constants.BattleState"

CharacterVO = {}
CharacterVO.ROW_BACK = 0
CharacterVO.ROW_FRONT = 1

-- Terra
-- *****
-- Vigor --------- 31
-- Speed --------- 33
-- Stamina ------- 28
-- Magic Power --- 39
-- Battle Power -- 22
-- Defense ------- 42
-- Evade --------- 5%
-- Magic Defense - 33
-- Magic Block --- 7%



function CharacterVO:new()

	local character = display.newGroup()
	character.classType = "CharacterVO"
	character.name = nil
	character.vigor = 31
	character.speed = 33
	character.stamina = 28
	character.magicPower = 39
	character.battlePower = 22
	character.defense = 5
	character.evade = 5
	character.magicDefense = 33
	character.magicBlock = 7
	character.level = 1
	character.magicPoints = 100
	character.experience = 100
	character.maxHitPoints = 700
	character.maxMagicPoints = 200
	character.row = CharacterVO.ROW_FRONT
	character.hitPoints = 700
	character.battleState = BattleState.NORMAL
	character.equippedRightArm = nil
	character.equippedLeftArm = nil
	character.equippedAccessory = nil
	character.equippedBody = nil

	function character:setAndDispatchChange(propName, value, eventName)
		if value ~= self[propName] then
			local oldValue = self[propName]
			self[propName] = value
			local event = {name=eventName, old=oldValue, value=value}
			self:dispatchEvent(event)
		end
	end

	function character:setEquippedRightArm(value)
		self:setAndDispatchChange("equippedRightArm", value, "onEqippedRightArmChanged")
	end

	function character:setEquippedLeftArm(value)
		self:setAndDispatchChange("equippedLeftArm", value, "onEqippedLeftArmChanged")
	end

	function character:setEquippedAccessory(value)
		self:setAndDispatchChange("equippedAccessory", value, "onEqippedAccessoryChanged")
	end

	function character:setEquippedBody(value)
		self:setAndDispatchChange("equippedBody", value, "onEquippedBodyChanged")
	end

	function character:setRow(value)
		self:setAndDispatchChange("row", value, "onRowChanged")
	end

	-- TODO: doesn't handle Zombie status
	function character:setHitPoints(value)
		if value ~= self.hitPoints then
			local oldValue = self.hitPoints
			if oldValue <= 0 and self.hitPoints >= 1 then
				self:dispatchEvent({name="onRevived", target=self})
			end
			local difference = self.hitPoints - oldValue
			if self.hitPoints < 0 then
				self.hitPoints = 0
				if oldValue > 0 then
					self:dispatchEvent({name="onDeath", target=self})
				end
			end
			self:dispatchEvent({name="onHitPointsChanged", target=self, oldValue=oldValue, hitPoints=self.hitPoints, difference=difference})
		end
	end

	function character:setBattleState(value)
		self:setAndDispatchChange("battleState", value, "onBattleStateChanged")
	end


	return character
end

return CharacterVO