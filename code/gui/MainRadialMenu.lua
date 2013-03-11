require "utils.StateMachine"
require "gui.MenuVO"
require "gui.RadialMenu"

MainRadialMenu = {}

function MainRadialMenu:new()

	local menu = display.newGroup()
	menu.classType = "MainRadialMenu"
	menu.players = nil
	menu.items = nil
	menu.listMain = nil
	menu.listEquip = nil
	menu.fsm = nil
	menu.equipItemsMenu = nil
	menu.weapons = nil

	

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

		local listEquip = {}
		table.insert(listEquip, MenuVO:new("L Arm"))
		table.insert(listEquip, MenuVO:new("R Arm"))
		table.insert(listEquip, MenuVO:new("Head"))
		table.insert(listEquip, MenuVO:new("Body"))
		table.insert(listEquip, MenuVO:new("<< Back"))
		self.listEquip = listEquip

		local weapons = {}
		table.insert(weapons, MenuVO:new("Sword"))
		table.insert(weapons, MenuVO:new("Shield"))
		table.insert(weapons, MenuVO:new("Axe"))
		table.insert(weapons, MenuVO:new("Whip"))
		self.weapons = weapons

		local radialMenu = RadialMenu:new()
		self:insert(radialMenu)
		self.radialMenu = radialMenu
		--radialMenu.x = stage.width / 2 - 35
		--radialMenu.y = stage.height / 2 - 35

		local fsm = StateMachine:new(self)
		fsm:addState("main", {from={"equip", "relic", "items"}, enter=self.onEnterMainState})
		fsm:addState("items", {from={"main", "whichCharacterForItem"}, enter=self.onEnterItemsState})
		fsm:addState("whichCharacterForItem", {from="items", enter=self.onEnterWhichCharacterForItemState})
		fsm:addState("equip", {from="main", enter=self.onEnterEquipState})
		--fsm:addEventListener("onStateMachineStateChanged", self)
		--fsm:addState("equip", {from="main", parent="main"})
		--fsm:addState("")
		fsm:setInitialState("main")
		self.fsm = fsm
	end

	function menu:onEnterMainState()
		self.radialMenu:build(self.listMain)
		self.radialMenu:setCallback(self, "onMainStateRadialMenuItemTouched")
	end

	function menu:onMainStateRadialMenuItemTouched(event)
		if event.phase == "ended" then
			local label = event.menuVO.label
			if label == "<< Back" then
				self.radialMenu:destroy()
			elseif label == "Items" then
				self.fsm:changeState("items")
			elseif label == "Equip" then
				self.fsm:changeState("equip")
			end
		end
	end

	function menu:onEnterItemsState()
		self.radialMenu:setCallback(self, "onItemsStateRadialMenuItemTouched")
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
		self.radialMenu:setCallback(self, "onWhichCharacterForItemStateRadialMenuItemTouched")
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

	function menu:onEnterEquipState()
		self.radialMenu:setCallback(self, "onEquipRadialMenuItemTouched")
		self.radialMenu.radius = (math.min(stage.width, stage.height) / 4)
		self.radialMenu:build(self.listEquip)
	end

	function menu:onEquipRadialMenuItemTouched(event)
		if event.phase == "ended" then
			local equipItemsMenu 
			if self.equipItemsMenu == nil then
				equipItemsMenu = RadialMenu:new()
				self.equipItemsMenu = equipItemsMenu
				self:insert(equipItemsMenu)
			else
				equipItemsMenu = self.equipItemsMenu
			end

			local label = event.menuVO.label
			local props = {radiusSize="small", circleSize=360}
			local build = true
			if label == "L Arm" then
				--props.offset = -10
			elseif label == "R Arm" then
				--props.offset = 70
			elseif label == "Head" then
				--props.offset = 200
			elseif label == "Body" then
				--props.offset = 270
			else
				build = false
				equipItemsMenu:destroy()
			end

			if build then
				equipItemsMenu:build(self.weapons, props)
			end

			--local pX, pY = menu:localToContent(event.item.x, event.item.y)
			--pX, pY = menu:contentToLocal(pX, pY)
			local pX = event.item.x
			local pY = event.item.y
			print(pX, pY)
			equipItemsMenu.x = pX
			equipItemsMenu.y = pY

		end
	end

	menu:init()

	return menu

end

return MainRadialMenu