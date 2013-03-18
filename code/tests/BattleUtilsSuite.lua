--[[

	All unit tests for the core Final Fantasy 6 algorithms,
	specifically around battle. I've done my best to get coverage
	on all functions and put in values that matter. Some have a TON
	of different parameters that we'll need to have different tests
	for which is great.

	For now, all functions are covered as a first step.

]]--

module(..., package.seeall)

function setup()
	require "battle.BattleUtils"
end

function test_create()
	assert_not_nil(BattleUtils)
end

function test_divide()
	local result = BattleUtils.divide(10, 5)
	assert_equal(2, result)
end

function test_divideInteger()
	local result = BattleUtils.divide(10, 5)
	local isAnInt = isInteger(result)
	assert_true(isAnInt)
end

function test_getRandomNumberFromRange()
	local result = BattleUtils.getRandomNumberFromRange(1, 3)
	assert_gt(0, result)
	assert_lt(4, result)
end

function test_getCharacterPhysicalDamageStep1()
	local vigor                = 31
	local battlePower          = 28
	local level                = 1
	local equippedWithGauntlet = false
	local equippedWithOffering = false
	local standardFightAttack  = true
	local genjiGloveEquipped   = false
	local oneOrZeroWeapons     = true
	local damage = BattleUtils.getCharacterPhysicalDamageStep1(vigor,
																battlePower,
																level,
																equippedWithGauntlet,
																equippedWithOffering,
																standardFightAttack,
																genjiGloveEquipped,
																oneOrZeroWeapons)
	assert_gt(0, damage)
end

function test_getRandomMonsterStrength()
	local vigor = BattleUtils.getRandomMonsterStrength()
	assert_gte(56, vigor)
	assert_lte(63, vigor)
end

function test_getMonsterPhysicalDamageStep1()
	local level       = 1
	local battlePower = 28
	local vigor       = 31
	local damage = BattleUtils.getMonsterPhysicalDamageStep1(level, battlePower, vigor)
	assert_gt(0, damage)
end

function test_getCharacterDamageStep2()
	local damage                  = 0
	local isMagicalAttacker       = false
	local isPhysicalAttack        = true
	local isMagicalAttack         = false
	local equippedWithAtlasArmlet = false
	local equippedWith1HeroRing   = false
	local equippedWith2HeroRings  = false
	local equippedWith1Earring    = false
	local equippedWith2Earrings   = false
	damage = BattleUtils.getCharacterDamageStep2(damage,
													isMagicalAttacker,
													isPhysicalAttack,
													isMagicalAttack,
													equippedWithAtlasArmlet,
													equippedWith1HeroRing,
													equippedWith2HeroRings,
													equippedWith1Earring,
													equippedWith2Earrings)
	assert_equal(0, damage)
end

function test_getCharacterDamageStep2WithNonZeroValue()
	local damage                  = 1
	local isMagicalAttacker       = false
	local isPhysicalAttack        = true
	local isMagicalAttack         = false
	local equippedWithAtlasArmlet = false
	local equippedWith1HeroRing   = false
	local equippedWith2HeroRings  = false
	local equippedWith1Earring    = false
	local equippedWith2Earrings   = false
	damage = BattleUtils.getCharacterDamageStep2(damage,
													isMagicalAttacker,
													isPhysicalAttack,
													isMagicalAttack,
													equippedWithAtlasArmlet,
													equippedWith1HeroRing,
													equippedWith2HeroRings,
													equippedWith1Earring,
													equippedWith2Earrings)
	assert_gte(1, damage)
end

function test_getMagicalMultipleTargetsAttack_ShouldHalveMagicalDamage()
	local damage = 2
	damage = BattleUtils.getMagicalMultipleTargetsAttack(damage)
	assert_equal(1, damage)
end

function test_getAttackerBackRowFightCommand_ThoseInBackRowGetHalfDamage()
	local damage = 2
	damage = BattleUtils.getAttackerBackRowFightCommand(damage)
	assert_equal(1, damage)
end

function test_getCriticalHit()
	local crit = BattleUtils.getCriticalHit()
	assert_boolean(crit)
end

function test_getDamageMultipliers()
	local damage           = 0
	local hasMorphStatus   = false
	local hasBerserkStatus = false
	local isCriticalHit    = false
	damage = BattleUtils.getDamageMultipliers(damage, hasMorphStatus, hasBerserkStatus, isCriticalHit)
	assert_equal(0, damage)
end

function test_getDamageMultipliers_critDoublesDamage()
	local damage           = 1
	local hasMorphStatus   = false
	local hasBerserkStatus = false
	local isCriticalHit    = true
	damage = BattleUtils.getDamageMultipliers(damage, hasMorphStatus, hasBerserkStatus, isCriticalHit)
	assert_equal(2, damage)
end

function test_getDamageModifications()
	local damage               = 1
	local defense              = 0
	local magicalDefense       = 33 
	local isPhysicalAttack     = true
	local isMagicalAttack      = false
	local targetHasSafeStatus  = false
	local targetHasShellStatus = false
	local targetDefending      = false
	local targetIsInBackRow    = false
	local targetHasMorphStatus = false
	local targetIsSelf         = false
	local targetIsCharacter    = false
	local attackerIsCharacter  = false
	damage = BattleUtils.getDamageModifications(damage,
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
	assert_gt(1, damage)
end

function test_getDamageMultiplierStep7()
	local damage             = 1
	local hittingTargetsBack = true
	local isPhysicalAttack   = true
	damage = BattleUtils.getDamageMultiplierStep7(damage, hittingTargetsBack, isPhysicalAttack)
	assert_equal(1.5, damage)
end

function test_getDamageStep8()
	local damage             = 9001
	local hasPetrifiedStatus = true
	damage = BattleUtils.getDamageStep8(damage, hasPetrifiedStatus)
	assert_equal(0, damage)
end

function test_getDamageStep9()
	local damage                      = 9001
	local elementHasBeenNullified     = true
	local targetAbsorbsElement        = false
	local targetIsImmuneToElement     = false
	local targetIsResistantToElement  = false
	local targetIsWeakToElement       = false
	local attackCanBeBlockedByStamina = false
	damage = BattleUtils.getDamageStep9(damage,
										elementHasBeenNullified,
										targetAbsorbsElement,
										targetIsImmuneToElement,
										targetIsResistantToElement,
										targetIsWeakToElement,
										attackCanBeBlockedByStamina)
	assert_equal(0, damage)
end


function test_hit()
	local isPhysicalAttack                  = true
	local isMagicalAttack                   = false
	local targetHasClearStatus              = false
	local protectedFromWound                = false
	local attackMissesDeathProtectedTargets = false
	local spellUnblockable                  = false
	local targetHasSleepStatus              = false
	local targetHasPetrifyStatus            = false
	local targetHasFreezeStatus             = false
	local targetHasStopStatus               = false
	local backOfTarget                      = false
	local hitRate                           = 180
	local targetHasImageStatus              = false
	local magicBlock                        = 53
	local specialAttackType                 = nil
	local targetStamina                     = 39
	
	local hit, removedImageStatus = BattleUtils.getHit(isPhysicalAttack,
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
	assert_true(hit)
end

function test_allDamageSteps()
	require "vo.CharacterVO"
	local character            = CharacterVO:new()
	
	local battlePower          = 28
	
	local equippedWithGauntlet = false
	local equippedWithOffering = false
	local standardFightAttack  = true
	local genjiGloveEquipped   = false
	local oneOrZeroWeapons     = true

	damage = BattleUtils.getCharacterPhysicalDamageStep1(character.vigor,
															battlePower,
															character.level,
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
	assert_gt(0, damage)
end


