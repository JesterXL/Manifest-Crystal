display.setStatusBar( display.HiddenStatusBar )

local function setupGlobals()
	require "utils.GameLoop"
	_G.gameLoop = GameLoop:new()
	gameLoop:start()

	_G.mainGroup = display.newGroup()
	mainGroup.classType = "mainGroup"
	_G.stage = display.getCurrentStage()

	--_G._ = require "utils.underscore"
	
	
	_G.platform = system.getInfo("platformName")
end

function isInteger(x)
	return math.floor(x)==x
end

function showProps(o)
	print("-- showProps --")
	print("o: ", o)
	for key,value in pairs(o) do
		print("key: ", key, ", value: ", value);
	end
	print("-- end showProps --")
end

function onSystemEvent(event)

	if platform == "Mac OS X" then return true end

	if event.type == "applicationExit" or event.type == "applicationSuspend" then
		os.exit()
	end

	--elseif event.type == "applicationResume"
end
Runtime:addEventListener("system", onSystemEvent)

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
			
			--menu.x = e.x
			--menu.y = e.y
			
			menu:addEventListener("onRadialMenuItemTouched", t)
			menu:build(list)
			Runtime:removeEventListener("touch", t)
			return true
		end
	end
	Runtime:addEventListener("touch", t)

	local c = {}
	function c:touch(e)
		menu.x = e.x
		menu.y = e.y
	end
	Runtime:addEventListener("touch", c)
end

local function testRadialMenuVariations()
	require "gui.RadialMenu"
	require "gui.MenuVO"
	local menu = RadialMenu:new()
	local list = {}
	table.insert(list, MenuVO:new("L Arm"))
	table.insert(list, MenuVO:new("Head"))
	table.insert(list, MenuVO:new("R Arm"))
	table.insert(list, MenuVO:new("Body"))
	table.insert(list, MenuVO:new("Back"))
	menu:build(list, {radiusSize= "small"})

	menu.x = stage.width / 2 - 35
	menu.y = stage.height / 2 - 35
	local weapons = {}
	table.insert(weapons, MenuVO:new("Sword"))
	table.insert(weapons, MenuVO:new("Shield"))
	table.insert(weapons, MenuVO:new("Axe"))
	table.insert(weapons, MenuVO:new("Whip"))

	local getRot = function(x1, y1, x2, y2)
		return math.atan2(y1 - y2, x1 - x2) / math.pi * 180 - 90
	end

	local t = {}
	function t:onCallback(e)
		if e.phase == "ended" then
			--print("degree:", e.item.degree)
			--print("rotation:", getRot(0, 0, e.item.x, e.item.y))
			--menu.bg.rotation = getRot(0, 0, e.item.x, e.item.y)
			local menuSmall 
			if self.menuSmall == nil then
				menuSmall = RadialMenu:new()
				self.menuSmall = menuSmall
			else
				menuSmall = self.menuSmall
			end
			--local rot = getRot(0, 0, e.item.x, e.item.y)
			--rot = rot + e.item.degree

			local label = e.menuVO.label
			local props = {radiusSize="small", circleSize=180}
			if label == "L Arm" then
				props.offset = 50
				menuSmall:build(weapons, props)
			elseif label == "R Arm" then
				props.offset = 200
				menuSmall:build(weapons, props)
			elseif label == "Head" then
				props.offset = 120
				menuSmall:build(weapons, props)
			elseif label == "Body" then
				props.offset = 270
				menuSmall:build(weapons, props)
			else
				menuSmall:destroy()
			end

			local pX, pY = menu:localToContent(e.item.x, e.item.y)
			--print("--------")
			--print("before:", pX, pY)
			pX, pY = menu:contentToLocal(pX, pY)
			--print("item:", e.item.x, e.item.y)
			--print("after:", pX, pY)
			--print("menu:", menu.x, menu.y)
			--pX = 30
			--pY = 30
			--pX = pX + menu.x
			--pY = pY + menu.y
			local circle
			if self.circle == nil then
				circle = display.newCircle(30, 30, 10)
				circle:setFillColor(255, 0, 0, 0)
				self.circle = circle
			else
				circle = self.circle
			end
			--pX = pX - 35
			--pY = pY - 35
			menuSmall.x = pX + menu.x
			menuSmall.y = pY + menu.y
			circle.x = pX + menu.x
			circle.y = pY + menu.y

		end
	end
	menu:setCallback(t, "onCallback")
end

local function testMainRadialMenu()
	require "gui.MainRadialMenu"
	local menu = MainRadialMenu:new()
	menu.x = stage.width / 2 - menu.width / 2
	menu.y = stage.height / 2 - menu.height / 2
end

local function testBattleTimer()
	require "battle.BattleTimer"
	local timer = BattleTimer:new(BattleTimer.MODE_CHARACTER)
	timer.speed = 80

	require "gui.ProgressBar"
	local bar = ProgressBar:new(255, 255, 255, 0, 242, 0, 60, 20)
	bar.x = 30
	bar.y = 30

	local t = {}
	function t:onBattleTimerProgress(e)
		--print("progress:" .. e.progress)
		bar:setProgress(e.progress, 1)
	end
	function t:onBattleTimerComplete(e)
		print("tick")
	end
	timer:addEventListener("onBattleTimerProgress", t)
	timer:addEventListener("onBattleTimerComplete", t)
	timer:reset()
	timer:start()
end

local function testBattleMenu()
	require "gui.BattleMenu"
	local menu = BattleMenu:new()
	menu:showActions()
	local t = {}
	function t:onBattleMenuActionTouched(e)
		print("onActionTouched, item: " .. e.action)
	end
	menu:addEventListener("onBattleMenuActionTouched", t)
end

local function testBattleController()
	require "tests.TestingBattleController"
	local dasUberTest = TestingBattleController:new()
end

local function testBattleView()
	require "gui.BattleView"
	require "utils.Generator"
	local c, m = Generator.getCharactersAndMonsters()
	local view = BattleView:new(c, m)
end

setupGlobals()

--testGrid()
--testSpriteGrid()
--testDebugGridView()
--testSpriteGridView()

--testRadials()
--testRadialMenu()
--testRadialMenuVariations()
--testMainRadialMenu()

--testBattleTimer()
--testBattleMenu()
--testBattleController()
--testBattleView()
--testBattleUtils()

require "unittests"