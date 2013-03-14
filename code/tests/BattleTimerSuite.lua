module(..., package.seeall)

function test_create()
	local BattleTimer = require "battle.BattleTimer"
	local timer = BattleTimer:new(BattleTimer.MODE_CHARACTER)
	assert_not_nil(timer)
end

