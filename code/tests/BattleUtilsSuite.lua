module(..., package.seeall)

function test_create()
	require "battle.BattleUtils"
	assert_not_nil(BattleUtils)
end

function test_divide()
	require "battle.BattleUtils"
	local result = BattleUtils.divide(10, 5)
	assert_equal(2, result)
end

function test_divideInteger()
	require "battle.BattleUtils"
	local result = BattleUtils.divide(10, 5)
	local isAnInt = isInteger(result)
	assert_true(isAnInt)
end

function test_getRandomNumberFromRange()
	require "battle.BattleUtils"
	local result = BattleUtils.getRandomNumberFromRange(1, 3)
	assert_gt(0, result)
	assert_lt(4, result)
end

