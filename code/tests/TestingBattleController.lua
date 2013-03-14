require "vo.CharacterVO"
require "vo.MonsterVO"
require "battle.BattleController"
require "gui.ProgressBar"
require "gui.BattleMenu"
TestingBattleController = {}

function TestingBattleController:new()

	local test = {}

	function test:init()
		local characters = {}
		local jesse = CharacterVO:new()
		jesse.name = "Jesse"
		local brandy = CharacterVO:new()
		brandy.name = "Brandy"
		table.insert(characters, jesse)
		table.insert(characters, brandy)
		self.characters = characters

		local monsters = {}
		local goblin1 = MonsterVO:new()
		goblin1.name = "Goblin 1"
		local goblin2 = MonsterVO:new()
		goblin2.name = "Goblin 2"
		table.insert(monsters, goblin1)
		table.insert(monsters, goblin2)
		self.monsters = monsters

		local battleController = BattleController:new(characters, monsters)
		Runtime:addEventListener("onBattleTimerProgress", self)
		Runtime:addEventListener("onCharacterReady", self)
		Runtime:addEventListener("onActionResult", self)
		Runtime:addEventListener("onBattleLost", self)
		Runtime:addEventListener("onBattleWon", self)
		self.battleController = battleController

		local startX = 100
		local startY = 200
		local createProgressBar = function(character)
			local progressBar = ProgressBar:new(255, 255, 255, 0, 242, 0, 30, 10)
			progressBar.character = character
			progressBar.x = startX
			progressBar.y = startY
			character.progressBar = progressBar
			startY = startY + 22
		end
		createProgressBar(jesse)
		createProgressBar(brandy)
		createProgressBar(goblin1)
		createProgressBar(goblin2)

		local battleMenu = BattleMenu:new()
		battleMenu:showActions()
		battleMenu:addEventListener("onBattleMenuActionTouched", self)
		battleMenu.isVisible = false
		-- TODO: make battle ground view (yeah right... 1 month... super cool story bro)
		battleController:start()
		self.battleMenu = battleMenu

	end

	function test:onBattleTimerProgress(e)
		if e.timer.character.classType == "MonsterVO" then
			return false
		end

		e.timer.character.progressBar:setProgress(e.progress, 1)
	end

	function test:onCharacterReady(e)
		if battleMenu.isVisible == false then
			battleMenu.isVisible = true
			battleMenu:showActions()
		end
	end

	function test:onActionResult(e)
		-- TODO
	end

	function test:onBattleMenuActionTouched(e)
		local action = e.action
		self.lastBattleActionChosen = action
		local hide = true
		if action == BattleMenu.ATTACK then
			-- TODO
		elseif action == BattleMenu.DEFEND then
			battleController:defend(battleController.charactersReady[0])
		elseif action == BattleMenu.ITEM then
			-- TODO
		elseif action == BattleMenu.CHANGE_ROW then
			battleController:changeRow(battleController.charactersReady[0])
		elseif action == BattleMenu.RUN then
			battleController:run(battleController.charactersReady[0])
		end
	end

	function test:onBattleLost(e)
		-- TODO
	end

	function test:onBattleWon(e)
		-- TODO
	end

	test:init()

	return test
end

return TestingBattleController