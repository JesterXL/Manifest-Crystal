require "tilemap.Direction"
SpriteGridViewPM = {}

function SpriteGridViewPM:new(spriteGridView)
	local model = {}
	model.spriteGridView = nil
	model.direction = nil
	model.TIMEOUT = 10
	model.lastTick = nil

	function model:init(spriteGridView)
		self.spriteGridView = spriteGridView

		Runtime:addEventListener("onSouthButtonPressed", self)
		Runtime:addEventListener("onSouthButtonReleased", self)

		Runtime:addEventListener("onNorthButtonPressed", self)
		Runtime:addEventListener("onNorthButtonReleased", self)

		Runtime:addEventListener("onEastButtonPressed", self)
		Runtime:addEventListener("onEastButtonReleased", self)

		Runtime:addEventListener("onWestButtonPressed", self)
		Runtime:addEventListener("onWestButtonReleased", self)

		Runtime:addEventListener("onInteractTouched", self)
	end

	function model:onSouthButtonPressed()
		self.direction = Direction.SOUTH
		gameLoop:addLoop(self)
		self.lastTick = self.TIMEOUT
	end

	function model:onSouthButtonReleased()
		gameLoop:removeLoop(self)
	end

	function model:onNorthButtonPressed()
		self.direction = Direction.NORTH
		gameLoop:addLoop(self)
		self.lastTick = self.TIMEOUT
	end

	function model:onNorthButtonReleased()
		gameLoop:removeLoop(self)
	end

	function model:onEastButtonPressed()
		self.direction = Direction.EAST
		gameLoop:addLoop(self)
		self.lastTick = self.TIMEOUT
	end

	function model:onEastButtonReleased()
		gameLoop:removeLoop(self)
	end

	function model:onWestButtonPressed()
		self.direction = Direction.WEST
		gameLoop:addLoop(self)
		self.lastTick = self.TIMEOUT
	end

	function model:onWestButtonReleased()
		gameLoop:removeLoop(self)
	end

	function model:onInteractTouched()
		local player = self.spriteGridView.playerSpriteVO
		local grid = self.spriteGridView.spriteGrid
		local result = grid:getWhateverYoureFacing(player)
		print("result:", result, result.classType)
	end

	function model:tick(milliseconds)
		if self.lastTick ~= nil then
			self.lastTick = self.lastTick + milliseconds
			if self.lastTick >= self.TIMEOUT then
				self.lastTick = 0
				local direction = self.direction
				local spriteGrid = self.spriteGridView.spriteGrid
				local player = self.spriteGridView.playerSpriteVO
				if direction == Direction.NORTH then
					spriteGrid:moveNorth(player)
				elseif direction == Direction.SOUTH then
					spriteGrid:moveSouth(player)
				elseif direction == Direction.EAST then
					spriteGrid:moveEast(player)
				elseif direction == Direction.WEST then
					spriteGrid:moveWest(player)
				end
			end
		else
			self.lastTick = milliseconds
		end
	end

	model:init(spriteGridView)

	return model
end

return SpriteGridViewPM