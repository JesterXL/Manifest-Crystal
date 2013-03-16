require "battle.BattleTimer"
require "battle.BattleUtils"
require "vo.ActionResultVO"
require "battle.AttackTypes"

BattleController = {}

function BattleController:new(characters, monsters)

	local battle = display.newGroup()
	battle.charactersReady = {}
	battle.characters = nil
	battle.monsters = nil
	battle.battleTimers = nil
	battle.battleResults = nil
	battle.battleOver = false

	function battle:init(characters, monsters)
		print("BattleController::init")
		self.characters = characters
		self.monsters = monsters
		self.battleTimers = {}
		self.battleResults = {}
		self.charactersReady = {}

		local i, timer
		for i=1,#characters do
			local character = characters[i]

			timer = BattleTimer:new(BattleTimer.MODE_CHARACTER)
			timer:addEventListener("onBattleTimerProgress", self)
			timer:addEventListener("onBattleTimerComplete", self)
			timer.character = character
			timer.speed = character.speed
			character:addEventListener("onHitPointsChanged", self)
			character.timer = timer

			table.insert(self.battleTimers, timer)
		end

		for i=1,#monsters do
			local monster = monsters[i]
			monster.strength = BattleUtils.getRandomMonsterStrength()
			monster:addEventListener("onHitPointsChanged", self)

			timer = BattleTimer:new(BattleTimer.MODE_MONSTER)
			timer:addEventListener("onBattleTimerProgress", self)
			timer:addEventListener("onBattleTimerComplete", self)
			timer.character = monster
			timer.speed = monster.speed
			monster.timer = timer

			table.insert(self.battleTimers, timer)
		end
	end

	function battle:start()
		if self.battleOver then
			return false
		end

		print("BattleController::start")
		local timers = self.battleTimers
		local i
		for i=1,#timers do
			local timer = timers[i]
			timer:reset()
			timer:start()
		end
	end

	function battle:pause()
		print("BattleController::pause")
		local timers = self.battleTimers
		local i
		for i=1,#timers do
			timers[i]:stop()
		end
	end

	function battle:resume()
		print("BattleController::resume")
		local timers = self.battleTimers
		local i
		for i=1,#timers do
			timers[i]:start()
		end
	end

	function battle:resolveActionResult(actionResult)
		if self.battleOver then
			return false
		end

		print("BattleController::resolveActionResult")
		local i
		if actionResult.hit then
			local targets = actionResult.targets
			local damages = actionResult.damages
			for i=1,#targets do
				local target = targets[i]
				local damage = damages[i]
				target:setHitPoints(target.hitPoints - damage)
			end
		end

		i = table.indexOf(self.battleResults, actionResult)
		table.remove(self.battleResults, i)

		if actionResult.attacker.classType == "MonsterVO" then
			self:resume()
		else
			i = table.indexOf(self.charactersReady, actionResult.attacker)
			table.remove(self.charactersReady, i)
			self:resume()
		end
	end

	function battle:attack(attacker, targets, attackType)
		if self.battleOver then
			return false
		end

		print("BattleController::attack")

		assert(attacker, "Attacker cannot be nil")
		assert(targets, "targets cannot be nil")
		assert(#targets > 0, "targets cannot be empty")

		if table.indexOf(self.charactersReady, attacker) == nil then
			error("BattleController::attack, unknown attacker, he's not in our ready list.")
		end

		local target = targets[1]

		local isPhysicalAttack = true
		local isMagicalAttack = false
		local targetHasClearStatus = false
		local protectedFromWound = false
		local attackMissesDeathProtectedTargets = false
		local attackCanBeBlockedByStamina = true
		local spellUnblockable = false
		local targetHasSleepStatus = false
		local targetHasPetrifyStatus = false
		local targetHasFreezeStatus = false
		local targetHasStopStatus = false
		local backOfTarget = false
		local hitRate = 180 -- TODO: need weapon's info, this is where hitRate comes from
		local targetHasImageStatus = false
		local magicBlock = target.magicBlock
		local specialAttackType = attackType
		local targetStamina = target.stamina
		
		-- TODO: remove image status on target if 2nd return value is true
		local hit, removedImageStatus = BattleUtils.getHit(isPhysicalAttack,
										isMagicalAttack,
										targetHasClearStatus,
										protectedFromWound,
										attackMissesDeathProtectedTargets,
										attackCanBeBlockedByStamina,
										spellUnblockable,
										targetHasSleepStatus,
										targetHasPetrifyStatus,
										targetHasFreezeStatus,
										targetHasStopStatus,
										backOfTarget,
										hitRate,
										targetHasImageStatus,
										magicBlock,
										specialAttackType,
										targetStamina)
		local damage = 0
		local criticalHit = false
		if hit then
			local battlePower = 28 -- TODO: need weapon info, battle power comes from it

			local equippedWithGauntlet = false -- TODO: is the character?
			local equippedWithOffering = false -- TODO: is the character? 
			local standardFightAttack = true  -- TODO: is the character?
			local genjiGloveEquipped = false  -- TODO: is the character?
			local oneOrZeroWeapons = true  -- TODO: is the character?

			damage = BattleUtils.getCharacterPhysicalDamageStep1(attacker.vigor,
																	battlePower,
																	attacker.level,
																	equippedWithGauntlet,
																	equippedWithOffering,
																	standardFightAttack,
																	genjiGloveEquipped,
																	oneOrZeroWeapons)


			-- damage, 
			-- isMagicalAttacker,
			-- isPhysicalAttack,
			-- isMagicalAttack,
			-- equippedWithAtlasArmlet, 
			-- equippedWith1HeroRing,
			-- equippedWith2HeroRings,
			-- equippedWith1Earring,
			-- equippedWith2Earrings)
			damage = BattleUtils.getCharacterDamageStep2(damage, 
															false, 
															true, 
															false,
															false,
															false,
															false,
															false,
															false)

			criticalHit = BattleUtils.getCriticalHit()
			-- damage, hasMorphStatus, hasBerserkStatus
			damage = BattleUtils.getDamageMultipliers(damage, false, false, criticalHit)
			-- TODO: need armor of target so we can calculate defense
			-- damage, 
			-- defense, 
			-- magicalDefense, 
			-- isPhysicalAttack, 
			-- isMagicalAttack,
			-- targetHasSafeStatus,
			-- targetHasShellStatus, 
			-- targetDefending,
			-- targetIsInBackRow, 
			-- targetHasMorphStatus,
			-- targetIsSelf, 
			-- targetIsCharacter, 
			-- attackerIsCharacter)
			damage = BattleUtils.getDamageModifications(damage,
														16,
														0,
														true,
														false,
														false,
														false,
														false,
														false,
														false,
														false,
														false,
														true)

			-- damage, hittingTargetsBack, isPhysicalAttack)
			damage = BattleUtils.getDamageMultiplierStep7(damage, false, true)
			if damage > 9999 then
				error("What, 9000!?!")
			end
		end
		local damages = {damage}
		self:onBattleResults(attacker, targets, attackType, hit, criticalHit, damages)
	end

	function battle:defend(character)
		if self.battleOver then
			return false
		end

		print("BattleController::defend")

		local i = table.indexOf(self.charactersReady, character)
		if i == nil then
			error("BattleController::defend, unknown attacker; he's not in our charactersReady list.")
		end

		character.battleState = BattleState.DEFENDING
		table.remove(self.charactersReady, i)
		self:resume()
	end

	function battle:changeRow(character)
		print("BattleController::changeRow")
		local i = table.indexOf(self.charactersReady, character)
		if i == nil then
			error("BattleController::changeRow, unknown attacker; he's not in our charactersReady list.")
		end

		if character.row == CharacterVO.ROW_FRONT then
			character.row = CharacterVO.ROW_BACK
		else
			character.row = CharacterVO.ROW_FRONT
		end

		table.remove(self.charactersReady, i)
		self:resume()
	end

	function battle:useItem(attacker, targets, item)
		print("BattleController::useItem")
		local i = table.indexOf(self.charactersReady, character)
		if i == nil then
			error("BattleController::useItem, unknown attacker; he's not in our charactersReady list.")
		end

		-- TODO: apply item
		attacker.battleState = BattleState.NORMAL
		table.remove(self.charactersReady, i)
		self:resume()
	end

	function battle:run(character)
		print("BattleController::run")
		local i = table.indexOf(self.charactersReady, character)
		if i == nil then
			error("BattleController::run, unknown attacker; he's not in our charactersReady list.")
		end

		character.battleState = BattleState.RUNNING
		table.remove(self.charactersReady, i)
		self:resume()
	end

	function battle:onBattleTimerProgress(event)
		-- this allows progress bars to update
		self:dispatchEvent({name="onBattleTimerProgress",
								target=self,
								timer=event.target,
								progress=event.progress})
	end

	function battle:onBattleTimerComplete(event)
		print("BattleController::onBattleTimerComplete")
		self:onCharacterReady(event.target)
	end

	function battle:onCharacterReady(battleTimer)
		print("BattleController::onCharacterReady")
		local character = battleTimer.character
		print("it's a " .. character.classType)
		if character.classType == "MonsterVO" then
			local monsterTarget = self:getRandomCharacterForMonster()
			if monsterTarget then
				local isPhysicalAttack = true
				local isMagicalAttack = false
				local targetHasClearStatus = false
				local protectedFromWound = false
				local attackMissesDeathProtectedTargets = false
				local attackCanBeBlockedByStamina = true
				local spellUnblockable = false
				local targetHasSleepStatus = false
				local targetHasPetrifyStatus = false
				local targetHasFreezeStatus = false
				local targetHasStopStatus = false
				local backOfTarget = false
				local hitRate = 180 -- TODO: need monster's info, this is where hitRate comes from
				local targetHasImageStatus = false
				local magicBlock = monsterTarget.magicBlock
				-- TODO: some monsters have special attacks
				local specialAttackType = nil
				local targetStamina = monsterTarget.stamina
				
				-- TODO: remove image status on target if 2nd return value is true
				local hit, removedImageStatus = BattleUtils.getHit(isPhysicalAttack,
												isMagicalAttack,
												targetHasClearStatus,
												protectedFromWound,
												attackMissesDeathProtectedTargets,
												attackCanBeBlockedByStamina,
												spellUnblockable,
												targetHasSleepStatus,
												targetHasPetrifyStatus,
												targetHasFreezeStatus,
												targetHasStopStatus,
												backOfTarget,
												hitRate,
												targetHasImageStatus,
												magicBlock,
												specialAttackType,
												targetStamina)
				local damage = 0
				local criticalHit = false
				if hit then
					-- TODO: what is monster power?
					local monstersBattlePower = 16
					damage = BattleUtils.getMonsterPhysicalDamageStep1(character.level, monstersBattlePower, character.vigor)
					criticalHit = BattleUtils.getCriticalHit()
					damage = BattleUtils.getDamageMultipliers(damage, false, false, criticalHit)
					-- TODO: need armor of target so we can calculate defense
					-- damage, 
					-- defense, 
					-- magicalDefense, 
					-- isPhysicalAttack, 
					-- isMagicalAttack,
					-- targetHasSafeStatus,
					-- targetHasShellStatus, 
					-- targetDefending,
					-- targetIsInBackRow, 
					-- targetHasMorphStatus,
					-- targetIsSelf, 
					-- targetIsCharacter, 
					-- attackerIsCharacter)
					damage = BattleUtils.getDamageModifications(damage,
																16,
																0,
																true,
																false,
																false,
																false,
																false,
																false,
																false,
																false,
																true,
																false)
					damage = BattleUtils.getDamageMultiplierStep7(damage, false, true)
					damage = math.floor(damage)
				end
				local damages = {damage}
				self:pause()
				self:onBattleResults(character, monsterTarget, AttackTypes.ATTACK, hit, criticalHit, damages)
			else
				self:onBattleResults(character, nil, AttackTypes.ATTACK, false, false, nil)
			end
		else
			self:pause()
			table.insert(self.charactersReady, character)
			-- this allows the menu to come up for a particular
			-- character so they can choose an action
			self:dispatchEvent({name="onCharacterReady",
									target=self,
									character=character})
		end
	end

	function battle:onBattleResults(attacker,
									targets,
									attackType,
									hit,
									criticalHit,
									damages)
		print("BattleController::onBattleResults")
		local result = ActionResultVO:new(attacker, 
											targets,
											attackType,
											hit,
											criticalHit,
											damages)
		table.insert(self.battleResults, result)
		-- this allows a View to animate interations based on the result
		-- of some action, like a monster attacking a character,
		-- or a character casting a spell on the monsters
		self:dispatchEvent({name="onActionResult",
								target=self,
								actionResult=result})
	end

	function battle:onDeath(character)
		print("BattleController::onDeath")
		character.timer:setEnabled(false)
		local monsters = self.monsters
		local allMonstersDead = false
		local i
		for i=1,#monsters do
			local monster = monsters[i]
			if monster.dead == false then
				allMonstersDead = false
				break
			end
		end

		local characters = self.characters
		local allCharactersDead = true
		for i=1,#characters do
			local character = characters[i]
			if character.dead == false then
				allCharactersDead = false
				break
			end
		end

		-- TODO: handle Life 3
		if allCharactersDead then
			self:pause()
			self.battleOver = true
			self:dispatchEvent({name="onBattleLost", target=self})
			return true
		end

		if allMonstersDead then
			self:pause()
			self.battleOver = true
			self:dispatchEvent({name="onBattleWon", target=self})
			return true
		end
	end

	function battle:onHitPointsChanged(event)
		print("BattleController::onHitPointsChanged")
		local character = event.target
		if character.hitPoints <= 0 then
			onDeath(character)
		end
	end

	function battle:getRandomCharacterForMonster()
		print("BattleController::getRandomCharacterForMonster")
		local characters = self.characters
		if characters and #characters > 0 then
			local num = math.floor(#characters * math.random())
			return characters[num]
		else
			return nil
		end
	end

	battle:init(characters, monsters)

	return battle

end

return BattleController