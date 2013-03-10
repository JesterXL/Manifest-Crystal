require "utils.StateMachine"
require "gui.MenuVO"
require "gui.RadialMenu"

MainRadialMenu = {}

function MainRadialMenu:new()

	local menu = display.newGroup()
	menu.classType = "MainRadialMenu"
	menu.players = nil
	menu.items = nil
	menu.fsm = nil

	menu.listMain = nil

	function menu:init()
		
		local listMain = {}
		table.insert(listMain, MenuVO:new("Items", "gui/radialmenuimages/menu-item-items.png"))
		table.insert(listMain, MenuVO:new("Equip", "gui/radialmenuimages/menu-item-equip.png"))
		table.insert(listMain, MenuVO:new("Relic", "gui/radialmenuimages/menu-item-relic.png"))
		table.insert(listMain, MenuVO:new("<< Back"))
		self.listMain = listMain

		local items = {}
		table.insert(items, MenuVO:new("Potion"))
		table.insert(items, MenuVO:new("Antidote"))
		table.insert(items, MenuVO:new("Soft"))
		table.insert(items, MenuVO:new("Eyedrops"))
		table.insert(items, MenuVO:new("<< Back"))
		self.items = items

		local players = {}
		table.insert(players, MenuVO:new("Carrie", "assets/images/characters/Carrie.png"))
		table.insert(players, MenuVO:new("Prodigy", "assets/images/characters/Prodigy.png"))
		table.insert(players, MenuVO:new("Sparks", "assets/images/characters/Sparks.png"))
		table.insert(players, MenuVO:new("<< Back"))
		self.players = players

		local radialMenu = RadialMenu:new()
		self:insert(radialMenu)
		self.radialMenu = radialMenu
		print("self.radialMenu:", self.radialMenu)
		radialMenu.x = 200
		radialMenu.y = 200

		local fsm = StateMachine:new(self)
		fsm:addState("main", {from={"equip", "relic", "items"}, enter=self.onEnterMainState})
		fsm:addState("items", {from={"main", "whichCharacterForItem"}, enter=self.onEnterItemsState})
		fsm:addState("whichCharacterForItem", {from="items", enter=self.onEnterWhichCharacterForItemState})
		fsm:addEventListener("onStateMachineStateChanged", self)
		--fsm:addState("equip", {from="main", parent="main"})
		--fsm:addState("")
		fsm:setInitialState("main")
		self.fsm = fsm
	end

	function menu:onEnterMainState()
		self.radialMenu:build(self.listMain)
		self.radialMenu:setMenuItemTouchedCallback(self, "onMainStateRadialMenuItemTouched")
	end

	function menu:onMainStateRadialMenuItemTouched(event)
		if event.phase == "ended" then
			if event.menuVO.label == "<< Back" then
				self.radialMenu:destroy()
			else
				self.fsm:changeState("items")
			end
		end
	end

	function menu:onEnterItemsState()
		self.radialMenu:setMenuItemTouchedCallback(self, "onItemsStateRadialMenuItemTouched")
		self.radialMenu:build(self.items)
	end

	function menu:onItemsStateRadialMenuItemTouched(event)
		if event.phase == "ended" then
			if event.menuVO.label == "<< Back" then
				self.fsm:changeState("main")
			else
				self.fsm:changeState("whichCharacterForItem")
			end
		end
	end

	function menu:onEnterWhichCharacterForItemState()
		self.radialMenu:setMenuItemTouchedCallback(self, "onWhichCharacterForItemStateRadialMenuItemTouched")
		self.radialMenu:build(self.players)
	end

	function menu:onWhichCharacterForItemStateRadialMenuItemTouched(event)
		if event.phase == "ended" then
			if event.menuVO.label == "<< Back" then
				self.fsm:changeState("items")
			else
				self.radialMenu:destroy()
			end
		end
	end

	menu:init()

	return menu

end

return MainRadialMenu