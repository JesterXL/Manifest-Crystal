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
	local ROWS = 40
	local COLS = 40

	local grid = Grid:new(ROWS, COLS, 0)
	local jxl = SpriteVO:new()
	local cow = SpriteVO:new()
	local spriteGrid = SpriteGrid:new(grid)
	spriteGrid:addSprite(jxl, 2, 2)
	local spriteGridView = SpriteGridView:new(spriteGrid, jxl, TILE_WIDTH, TILE_HEIGHT)
	--spriteGridView.x = stage.width / 2 - (TILE_WIDTH * COLS) / 2
	spriteGridView.x = 60
	spriteGridView.y = 60

	local mapGrid = Grid:new(ROWS, COLS, 0)
	mapGrid:setTile(3, 3, TileTypes.IMPASSABLE)
	local debugGridView = DebugGridView:new(mapGrid, TILE_WIDTH, TILE_HEIGHT)
	--debugGridView.x = stage.width / 2 - (TILE_WIDTH * COLS) / 2
	debugGridView.x = 60
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
	button.isVisible = false

	require "tilemap.SpriteGridViewPM"
	local pm = SpriteGridViewPM:new(spriteGridView)
end

local function testRadials()
	local items = 5
	local radius = 40

	local getPointFromRadian = function(radian)
		return math.cos(radian), math.sin(radian)
	end
	local offset = 90

	local holder = display.newGroup()
	for i=1,items do
		local circle = display.newCircle(0, 0, 10)
		holder:insert(circle)
		holder["circle" .. i] = circle
	end

	holder.x = 100
	holder.y = 100

	local getObjectPosition = function(index, itemsLen, offset, radius)
		local degree = 360 / itemsLen * index + offset
		local pX, pY = getPointFromRadian(math.rad(degree))
		pX = pX * radius
		pY = pY * radius
		return pX, pY
	end

	local position = function()
		--offset = offset + 1
		for i=1,items do
			local pX, pY = getObjectPosition(i, items, offset, radius)
			local circle = holder["circle" .. i]
			circle.x = pX
			circle.y = pY
		end
	end
	
	for i=1,items do
		local pX, pY = getObjectPosition(i, items, offset, radius)
		local circle = holder["circle" .. i]
		transition.to(circle, {x=pX, y=pY, time=500, transition=easing.outExpo})
	end
end

local function testRadialMenu()
	require "gui.RadialMenu"
	require "gui.MenuVO"

	local list = {}
	table.insert(list, MenuVO:new("Items", "gui/radialmenuimages/menu-item-items.png"))
	table.insert(list, MenuVO:new("Equip", "gui/radialmenuimages/menu-item-equip.png"))
	table.insert(list, MenuVO:new("Relic", "gui/radialmenuimages/menu-item-relic.png"))

	local menu = RadialMenu:new()

	local buildMenu2 = function(e)
		local list2 = {}
		table.insert(list2, MenuVO:new("Quatro"))
		table.insert(list2, MenuVO:new("Cinco"))
		table.insert(list2, MenuVO:new("Ses"))
		print(e.x, e.y, menu.x, menu.y)
		menu.x = e.x
		menu.y = e.y
		menu:build(list2)
	end

	local t = {}
	function t:onRadialMenuItemTouched(e)
		if e.phase == "moved" or e.phase == "began" then
			menu:removeEventListener("onRadialMenuItemTouched", t)
			buildMenu2(e)
			return true
		end
	end

	function t:touch(e)
		if e.phase == "began" then
			
			menu.x = e.x
			menu.y = e.y
			
			menu:addEventListener("onRadialMenuItemTouched", t)
			menu:build(list)
			Runtime:removeEventListener("touch", t)
			return true
		end
	end
	Runtime:addEventListener("touch", t)
end

local function testMainRadialMenu()
	require "gui.MainRadialMenu"
	local menu = MainRadialMenu:new()
end

setupGlobals()

--testGrid()
--testSpriteGrid()
--testDebugGridView()
--testSpriteGridView()

--testRadials()
--testRadialMenu()
testMainRadialMenu()
