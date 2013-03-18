require "vo.CharacterVO"
MonsterVO = {}


function MonsterVO:new()
	local vo = CharacterVO:new()
	vo.classType = "MonsterVO"
	vo.level = 5
	vo.hitPoits = 5
	vo.magicPoints = 0
	vo.experience = 24
	vo.gold = 45
	vo.battlePower = 13
	vo.defense = 60
	vo.speed = 30
	vo.evade = 0
	vo.hitRate = 100
	vo.magicDefense = 140
	vo.magicPower = 10
	vo.magicBlock = 0
	return vo
end

return MonsterVO