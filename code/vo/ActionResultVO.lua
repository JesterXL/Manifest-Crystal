ActionResultVO = {}

function ActionResultVO:new(attacker,
							targets,
							attackType,
							hit,
							damages,
							criticalHit)
	local result = {}
	result.classType = "ActionResultVO"
	result.attacker = attacker
	result.targets = targets
	result.attackType = attackType
	result.hit = hit
	result.damages = damages
	result.criticalHit = criticalHit

	return result
end

return ActionResultVO
