
local function testGrid()
	require "tilemap.Grid"
	local grid = Grid:new(10, 10, 0)
	local t = {}
	function t:onChange(event)
		print(event.oldValue, event.value)
	end
	grid:addEventListener("onChange", t)
	grid:setTile(5, 5, 2)
end

local function testSpriteGrid()
	require "tilemap.Grid"
	require "tilemap.SpriteGrid"
	require "tilemap.SpriteVO"
	local grid = Grid:new(10, 10, 0)
	local jxl = SpriteVO:new()
	local spriteGrid = SpriteGrid:new(grid)
	local t = {}
	function t:onAdded(event)
		print("onAdded")
	end
	function t:onRemoved(event)
		print("onRemoved")
	end
	function t:onMoved(event)
		print("onMoved")
	end
	spriteGrid:addEventListener("onAdded", t)
	spriteGrid:addEventListener("onRemoved", t)
	spriteGrid:addEventListener("onMoved", t)
	spriteGrid:addSprite(jxl, 2, 2)
end

local function testDebugGridView()
	require "tilemap.Grid"
	require "tilemap.DebugGridView"
	local grid = Grid:new(10, 10, 0)
	local view = DebugGridView:new(grid, 32, 32)
	view.x = 30
	view.y = 30

	local t = {}
	function t:timer(e)
		grid:setTile(3, 3, TileTypes.ACTION)
		grid:setTile(5, 5, TileTypes.IMPASSABLE)
	end
	timer.performWithDelay(2 * 1000, t)

end

local function testSpriteGridView()
	require "tilemap.Grid"
	require "tilemap.SpriteGrid"
	require "tilemap.SpriteVO"
	require "tilemap.SpriteGridView"
	require "tilemap.DebugGridView"
	require "tilemap.TileTypes"
	local grid = Grid:new(10, 10, 0)
	local jxl = SpriteVO:new()
	local cow = SpriteVO:new()
	local spriteGrid = SpriteGrid:new(grid)
	spriteGrid:addSprite(jxl, 2, 2)
	local spriteGridView = SpriteGridView:new(spriteGrid, 16, 16)
	spriteGridView.x = 30
	spriteGridView.y = 30

	local mapGrid = Grid:new(10, 10, 0)
	mapGrid:setTile(3, 3, TileTypes.IMPASSABLE)
	local debugGridView = DebugGridView:new(mapGrid, 16, 16)
	debugGridView.x = 30
	debugGridView.y = 30

	local t = {}
	function t:timer(e)
		spriteGrid:addSprite(cow, 5, 5)
	end
	timer.performWithDelay(2 * 1000, t)

	local later = {}
	function later:timer()
		spriteGrid:moveNorth(jxl)
	end
	timer.performWithDelay(4 * 1000, later)

end


--testGrid()
--testSpriteGrid()
--testDebugGridView()
testSpriteGridView()
