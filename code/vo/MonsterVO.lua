require "vo.CharacterVO"
MonsterVO = {}

function MonsterVO:new()
	local vo = CharacterVO:new()
	vo.classType = "MonsterVO"
	return vo
end

return MonsterVO