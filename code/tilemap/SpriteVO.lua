SpriteVO = {}

function SpriteVO:new()

	local sprite = {}
	sprite.classType = "SpriteVO"

	sprite.currentRow = 0
	sprite.currentCol = 0
	sprite.direction = "south"

	return sprite

end

return SpriteVO