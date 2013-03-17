-- Holy Grail of algorithms right here, y'all! This is sacred ground.
-- It was an honor to attempt to duplicate these hallowed maths. #FF6
--
-- The Aboriginees of Australia have a curious tradition that I now completely now understand.
-- They have cave drawings there that are thousands of years old. They pass down their
-- traditions through stories and pictures. They'll actually paint and touch up on these
-- drawings. To scientists and those of us who get the scientific and historical
-- significance of those drawings, you're immediately shocked, demanding answers.
-- They respond that they're simply ensuring the drawings don't fade away, are brought to a modern context, and keep fresh, alive.
--
-- For those of us who have experienced these adnventures, we know they'll NEVER die in us.
-- However, there are generatations who haven't. Efforts like this, through legal means,
-- are a moral duty we must, all who are capable, devote ourselves too.

require "battle.AttackTypes"
BattleUtils = {}

BattleUtils.PERFECT_HIT_RATE = 255

-- Number, Number : Number
BattleUtils.divide = function(valueA, valueB)
	return math.floor(valueA / valueB)
end
		
-- unit, uint : uint
BattleUtils.getRandomNumberFromRange = function(startValue, endValue)
	local range = endValue - startValue
	return math.floor(math.random() * range) + startValue
end
		
--[[
For physical attacks made by characters :

Step 1a. Vigor2 = Vigor * 2
If Vigor >= 128 then Vigor2 = 255 instead

Step 1b. Attack = Battle Power + Vigor2

Step 1c. If equipped with Gauntlet, Attack = Attack + Battle Power * 3 / 4

Step 1d. Damage = Battle Power + ((Level * Level * Attack) / 256) * 3 / 2

Step 1e. If character is equipped with an Offering:

Damage = Damage / 2

Step 1f. If the attack is a standard fight attack and the character is
equipped with a Genji Glove, but only one or zero weapons:

Damage = ceil(Damage * 3 / 4)
]]--

-- Number, Number, uint, Boolean, Boolean, Boolean, Boolean, Boolean : Number
BattleUtils.getCharacterPhysicalDamageStep1 = function(strength,
													   battlePower, 
													   level, 
													   equippedWithGauntlet, 
													   equippedWithOffering,
										 			   standardFightAttack, 
													   genjiGloveEquipped, 
													   oneOrZeroWeapons)
	local strength2 = strength * 2
	if(strength >= 128) then
		strength2 = 255
	end
	
	local attack = battlePower + strength2
	
	if(equippedWithGauntlet) then
		attack = attack + battlePower * 3 / 4
	end
	
	local damage = battlePower + ( (level * level * attack) / 256) * 3 / 2
	
	if(equippedWithOffering) then
		damage = damage / 2
	end
	
	if(standardFightAttack and genjiGloveEquipped and oneOrZeroWeapons) then
		damage = math.ceil(damage * 3 / 4)
	end
	
	return damage
end
		
--[[
For physical attacks made by monsters :

Step 1a. Damage = Level * Level * (Battle Power * 4 + Vigor) / 256

Note that vigor for each monster is randomly determined at the beginning of
the battle as [56..63]
]]--
		
-- : int (or uint?)
BattleUtils.getRandomMonsterStrength = function()
	local strength = BattleUtils.getRandomNumberFromRange(56, 63)
	return strength
end

-- uint, Number, int : Number
BattleUtils.getMonsterPhysicalDamageStep1 = function(level, battlePower, strength)
	local damage = level * level * (battlePower * 4 + strength) / 256
	return damage
end
		
		
--[[
Step 2. Atlas Armlet / Earring

Step 2a. If physical attack and attacker is equipped with Atlas Armlet or
Hero Ring:

Damage = Damage * 5/4

Step 2b. If magical attack and attacker is equipped with 1 Earring or
Hero Ring:

Damage = Damage * 5/4 

Step 2c. If magical attack and attacker is equipped with 2 Earrings / Hero
Rings:

Damage = Damage + (Damage / 4) + (Damage / 4)
]]--
		
-- Number, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean : Number
BattleUtils.getCharacterDamageStep2 = function(damage, 
												 isMagicalAttacker,
												 isPhysicalAttack,
												 isMagicalAttack,
												 equippedWithAtlasArmlet, 
												 equippedWith1HeroRing,
												 equippedWith2HeroRings,
												 equippedWith1Earring,
												 equippedWith2Earrings)
	if(isPhysicalAttack and (equippedWithAtlasArmlet or equippedWith1HeroRing) ) then
		damage = damage * 5/4
	end
	
	if(isMagicalAttack and (equippedWith1Earring or equippedWith1HeroRing) ) then
		damage = damage * 5/4
	end
	
	if(isMagicalAttack and (equippedWith2Earrings or equippedWith2HeroRings) ) then
		damage = damage + (damage / 4) + (damage / 4)
	end

	return damage
end
		
--[[
Step 3. Multiple targets

If magical attack and the attack is targeting more than one target:

Damage = Damage / 2

Note: Some spells skip this step
]]--
	
-- Number : Number
BattleUtils.getMagicalMultipleTargetsAttack = function(damage)
	damage = damage / 2
	return damage
end
		
--[[
Step 4. Attacker's row

If Fight command and the attacker is in the back row:

Damage = Damage / 2
]]--

BattleUtils.getAttackerBackRowFightCommand = function(damage)
	damage = damage / 2
	return damage
end
		
--[[
Step 5. Damage Multipliers #1

The damage multiplier starts out = 0.

The following add to the damage multiplier:

Morph (attacker) - If Attacker has morph status add 2 to damage multiplier

Berserk - If physical attack and attacker has berserk status add 1 to damage
multiplier

Critical hit -
Standard attacks have a 1 in 32 chance of being a critical hit. If attack
is a critical hit add 2 to damage multiplier

Step 5a. Damage = Damage + ((Damage / 2) * damage multiplier)
]]--
		
-- : Boolean
BattleUtils.getCriticalHit = function()
	local digit = math.round(math.random() * 31)
	return digit == 31
end

-- Number, Boolean, Boolean : Number	
BattleUtils.getDamageMultipliers = function(damage, hasMorphStatus, hasBerserkStatus, isCriticalHit)
	local multiplier = 0
	
	if(hasMorphStatus) then
		multiplier = multiplier + 2
	end
	
	if(hasBerserkStatus) then
		multiplier = multiplier +  1
	end
	
	if(isCriticalHit) then
		multiplier = multiplier + 2
	end
	
	damage = damage + ( (damage / 2) * damage * multiplier)
	return damage
end
		
--[[
Step 6. Damage modification

Step 6a. Random Variance

Damage = (Damage * [224..255] / 256) + 1

Step 6b. Defense modification

Damage = (Damage * (255 - Defense) / 256) + 1

Magical attacks use Magic defense

Step 6c. Safe / Shell

If magical attack and target has shell status, or physical attack and
target has safe status:

Damage = (Damage * 170 / 256) + 1

Step 6d. Target Defending

If physical attack and target is Defending:

Damage = Damage / 2

Step 6e. Target's row

If physical attack and target is in back row:

Damage = Damage / 2

Step 6f. Morph (target)

If magical attack and target has morph status:

Damage = Damage / 2

Step 6g. Self Damage

Healing attacks skip this step

If the attacker and target are both characters:

Damage = Damage / 2
]]--

-- Number, Number, Numer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean : Number
BattleUtils.getDamageModifications = function(damage, 
												defense, 
												magicalDefense, 
												isPhysicalAttack, 
												isMagicalAttack,
												targetHasSafeStatus,
												targetHasShellStatus, 
												targetDefending,
												targetIsInBackRow, 
												targetHasMorphStatus,
												targetIsSelf, 
												targetIsCharacter, 
												attackerIsCharacter)
	-- random variance
	local variance = BattleUtils.getRandomNumberFromRange(224, 255)
	damage = (damage * variance / 256) + 1
	
	-- defense modification
	local defenseToUse 
	if isPhysicalAttack then 
		defenseToUse = defense
	else 
		defenseToUse = magicalDefense
	end

	damage = (damage * (255 - defense) / 256) + 1
	
	-- safe / shell
	if((isPhysicalAttack and targetHasSafeStatus) or (isMagicalAttack and targetHasShellStatus)) then
		damage = (damage * 170 / 256) + 1
	end
	
	-- target defending
	if(isPhysicalAttack and targetDefending) then
		damage = damage / 2
	end
	
	-- target's row
	if(isPhysicalAttack and targetIsInBackRow) then
		damage = damage / 2
	end
	
	-- morph
	if(isMagicalAttack and targetHasMorphStatus) then
		damage = damage / 2
	end
	
	-- self damage (healing attack skips this step)
	if(targetIsSelf and targetIsCharacter and attackerIsCharacter) then
		damage = damage / 2
	end
	
	return damage
end
		
--[[
Step 7. Damage multipliers #2

The damage multiplier starts out = 0.

The following add to the damage multiplier:

Hitting target in back - If physical attack and attack hits the back of the
target, then 1 is added to the damage multiplier

Step 7a. Damage = Damage + ((Damage / 2) * damage multiplier)
]]--

-- Number, Boolean, Boolean : Number
BattleUtils.getDamageMultiplierStep7 = function(damage, hittingTargetsBack, isPhysicalAttack)
	local multiplier = 0
	
	if(isPhysicalAttack and hittingTargetsBack) then
		multiplier = multiplier + 1
	end
	
	damage = damage + ( (damage / 2) * damage * multiplier)
	
	return damage
end
		
--[[
Step 8. Petrify damage

If the target has petrify status, then damage is set to 0.
]]--

-- Number, Boolean : Number
BattleUtils.getDamageStep8 = function(damage, targetHasPetrifyStatus)
	if(targetHasPetrifyStatus) then
		damage = 0
	end
	return damage
end
		
--[[
Step 9. Elemental resistance

For each step, if the condition is met, no further steps are checked. So for
example, if the target absorbs the element, then steps 9c to 9e are not
checked.

Step 9a. If the element has been nullified (by Force Field), then: Damage = 0.

Step 9b. If target absorbs the element of the attack, then damage is
unchanged, but it heals HP instead of dealing damage

Step 9c. If target is immune to the element of the attack: Damage = 0

Step 9d. If target is resistant to the element of the attack:
Damage = Damage / 2

Step 9e. If target is weak to the element of the attack: Damage = Damage * 2
]]--
	
-- Number, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean : Number	
BattleUtils.getDamageStep9 = function(damage,
										elementHasBeenNullified,
										targetAbsorbsElement,
										targetIsImmuneToElement,
										targetIsResistantToElement,
										targetIsWeakToElement,
										attackCanBeBlockedByStamina)
	if(elementHasBeenNullified) then
		return 0
	end
	
	if(targetAbsorbsElement) then
		return -damage
	end
	
	if(targetIsImmuneToElement) then
		return 0
	end
	
	if(targetIsResistantToElement) then
		damage = damage / 2
		return damage
	end
	
	if(targetIsWeakToElement) then
		damage = damage * 2
		return damage
	end
	
	return damage
end
		
--[[

If at any step the attack always hits or always misses, then any further
steps are skipped.

Step 1. Clear

If physical attack and the target has clear status, the attack always misses
If magical attack and the target has clear status, the attack always hits.
]]--

-- Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Booolean, Boolea,n Boolea,n Boolean, Boolea,n uint, Boolean, Number, String, Boolean : Boolean
BattleUtils.getHit = function(isPhysicalAttack, 
								isMagicalAttack,
								targetHasClearStatus,
								protectedFromWound,
								attackMissesDeathProtectedTargets,
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
	if(isPhysicalAttack and targetHasClearStatus) then
		--print("1")
		return false
	end
	
	if(isMagicalAttack and targetHasClearStatus) then
		--print("2")
		return true
	end
	
	--[[
	Step 2. Death Protection
	
	If the target is protected from Wound status, and the attack misses death
	protected targets, then the attack always misses.
	]]--
	
	if(protectedFromWound and attackMissesDeathProtectedTargets) then
		--print("3")
		return false
	end
	
	--[[
	Step 3. Unblockable attacks
	
	If the spell is unblockable, then it always hits.
	]]--
	if(isMagicalAttack and spellUnblockable) then
		--print("4")
		return true
	end
	
	--[[
	
	Step 4. Check to hit for normal attacks
	
	Attacks which can be blocked by Stamina skip this step, and instead use
	step 5.
	
	Step 4a. If target has Sleep, Petrify, Freeze, or Stop status, then the
	attack always hits.
	
	Step 4b. If attack is physical and hits the back of the target, then it
	always hits.
	
	Step 4c. If perfect (255) hit rate, then the attack always hits.
	
	Step 4d. If physical attack, and target has Image status, then the attack
	always misses, and there is a 1 in 4 chance of removing the
	Image status.
	
	Step 4e. Chance to hit
	
	1. BlockValue = (255 - MBlock * 2) + 1
	
	2. If BlockValue > 255 then BlockValue = 255
	If BlockValue < 1 then BlockValue = 1
	
	3. If ((Hit Rate * BlockValue) / 256) > [0..99] then you hit otherwise,
	you miss.
	
	]]--

	local match = false
	if specialAttackType ~= nil then
		local attackTypes = {AttackTypes.BREAK,
								AttackTypes.DOOM,
								AttackTypes.DEMI,
								AttackTypes.QUARTR,
								AttackTypes.X_ZONE,
								AttackTypes.W_WIND,
								AttackTypes.SHOAT,
								AttackTypes.ODIN,
								AttackTypes.RAIDEN,
								AttackTypes.ANTLION,
								AttackTypes.SNARE,
								AttackTypes.X_FER,
								AttackTypes.GRAV_BOMB}
		local i
		for i=1,#attackTypes do
			if specialAttackType == attackTypes[i] then
				match = true
				break
			end
		end
	end
	

	if match == false then
		if(targetHasSleepStatus or targetHasPetrifyStatus or targetHasFreezeStatus or targetHasStopStatus) then
			--print("5")
			return true
		end
		
		if(isPhysicalAttack and backOfTarget) then
			--print("6")
			return true
		end
		
		if(hitRate == BattleUtils.PERFECT_HIT_RATE) then
			--print("7")
			return true
		end
		
		if(isPhysicalAttack and targetHasImageStatus) then
			-- TODO: 1 in 4 chance of removing Image status
			local result = BattleUtils.getRandomNumberFromRange(0, 3)
			if(result == 0) then
				--print("8")
				return false, true
			else
				--print("9")
				return false
			end
		end

		local blockValue = math.floor(255 - magicBlock * 2) + 1
		if blockValue > 255 then
			blockValue = 255
		end
		if blockValue < 1 then
			blockValue = 1
		end
		if((hitRate * blockValue) / 256) > BattleUtils.getRandomNumberFromRange(0, 99) then
			return true
		else
			return false
		end
	end
	
	--[[
	Step 5. Check to hit for attacks that can be blocked by Stamina
	
	Most attacks use step 4 instead of this step. Only Break, Doom, Demi,
	Quartr, X-Zone, W Wind, Shoat, Odin, Raiden, Antlion, Snare, X-Fer, and
	Grav Bomb use this step.
	
	Step 5a. Chance to hit
	
	1. BlockValue = (255 - MBlock * 2) + 1
	
	2. If BlockValue > 255 then BlockValue = 255
	If BlockValue < 1 then BlockValue = 1
	
	3. If ((Hit Rate * BlockValue) / 256) > [0..99] then you hit, otherwise
	you miss.
	]]--
	
	
	local blockValue = math.floor((255 - magicBlock * 2) + 1)
	
	if(blockValue > 255) then
		blockValue = 255
	end
	
	if(blockValue < 1) then
		blockValue = 1
	end
	
	if(((hitRate * blockValue) / 256) > BattleUtils.getRandomNumberFromRange(0, 99)) then
		--[[
		Step 5b. Check if Stamina blocks
		
		If target's stamina >= [0..127] then the attack misses (even if it hit in
		step 5a) otherwise, the attack hits as long as it hit in step 5a.
		]]--
		
		if(targetStamina >= BattleUtils.getRandomNumberFromRange(0, 127)) then
			--print("10")
			return false
		else
			--print("11")
			return true
		end
	else
		--print("12")
		return false
	end
	--print("13")
	return false
end

return BattleUtils