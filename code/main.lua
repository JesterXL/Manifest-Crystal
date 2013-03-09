display.setStatusBar( display.HiddenStatusBar )

local function setupGlobals()
	require "utils.GameLoop"
	_G.gameLoop = GameLoop:new()
	gameLoop:start()

	_G.mainGroup = display.newGroup()
	mainGroup.classType = "mainGroup"
	_G.stage = display.getCurrentStage()

	--_G._ = require "utils.underscore"
end

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

	local TILE_WIDTH = 32
	local TILE_HEIGHT = 32
	local ROWS = 10
	local COLS = 10

	local grid = Grid:new(ROWS, COLS, 0)
	local jxl = SpriteVO:new()
	local cow = SpriteVO:new()
	local spriteGrid = SpriteGrid:new(grid)
	spriteGrid:addSprite(jxl, 2, 2)
	local spriteGridView = SpriteGridView:new(spriteGrid, jxl, TILE_WIDTH, TILE_HEIGHT)
	spriteGridView.x = stage.width / 2 - (TILE_WIDTH * COLS) / 2
	spriteGridView.y = 60

	local mapGrid = Grid:new(ROWS, COLS, 0)
	mapGrid:setTile(3, 3, TileTypes.IMPASSABLE)
	local debugGridView = DebugGridView:new(mapGrid, TILE_WIDTH, TILE_HEIGHT)
	debugGridView.x = stage.width / 2 - (TILE_WIDTH * COLS) / 2
	debugGridView.y = spriteGridView.y

	--[[
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
	]]--

	spriteGrid:addSprite(cow, 5, 5)

	require "gui.PlayerControls"
	local button = PlayerControls:new()

	require "tilemap.SpriteGridViewPM"
	local pm = SpriteGridViewPM:new(spriteGridView)
end


setupGlobals()

--testGrid()
--testSpriteGrid()
--testDebugGridView()
testSpriteGridView()
