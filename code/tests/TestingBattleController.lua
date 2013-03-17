require "vo.CharacterVO"
require "vo.MonsterVO"
require "battle.BattleController"
require "gui.ProgressBar"
require "gui.BattleMenu"
require "gui.BattleView"

TestingBattleController = {}

function TestingBattleController:new()

	local test = {}
	test.lastBattleActionChosen = nil

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
		battleController:addEventListener("onBattleTimerProgress", self)
		battleController:addEventListener("onCharacterReady", self)
		battleController:addEventListener("onActionResult", self)
		battleController:addEventListener("onBattleLost", self)
		battleController:addEventListener("onBattleWon", self)
		self.battleController = battleController

		local startX = 100
		local startY = 200
		local createProgressBar = function(character)
			local progressBar = ProgressBar:new(255, 255, 255, 0, 242, 0, 60, 20)
			progressBar.character = character
			progressBar.x = startX
			progressBar.y = startY
			character.progressBar = progressBar
			startY = startY + 30
		end
		createProgressBar(jesse)
		createProgressBar(brandy)
		--createProgressBar(goblin1)
		--createProgressBar(goblin2)

		local battleMenu = BattleMenu:new()
		battleMenu:showActions()
		battleMenu:addEventListener("onBattleMenuActionTouched", self)
		battleMenu.isVisible = false
		-- TODO: make battle ground view (yeah right... 1 month... super cool story bro)
		battleController:start()
		self.battleMenu = battleMenu

		local battleView = BattleView:new(characters, monsters)
		battleView:addEventListener("onBattleViewMonsterTouched", self)
		battleView:addEventListener("onBattleViewCharacterTouched", self)
		battleView:addEventListener("onBattleViewActionAnimationHalfwayComplete", self)
		battleView:addEventListener("onBattleViewActionAnimationComplete", self)
		self.battleView = battleView
	end

	function test:onBattleTimerProgress(e)
		local timer = e.timer
		local character = timer.character
		local progressBar = character.progressBar
		if character.classType == "MonsterVO" then
			return false
		end
		progressBar:setProgress(e.progress, 1)
	end

	function test:onCharacterReady(e)
		print("TestingBattleController::onCharacterReady")
		local battleMenu = self.battleMenu
		if battleMenu.isVisible == false then
			battleMenu.isVisible = true
			battleMenu:showActions()
		end
	end

	function test:onActionResult(e)
		print("TestingBattleController::onActionResult")
		print("targets:", e.actionResult.targets)
		print("#targets:", table.maxn(e.actionResult.targets))
		self.battleView:handleAction(e.actionResult)
	end

	function test:onBattleMenuActionTouched(e)
		local action = e.action
		print("TestingBattleController::onBattleMenuActionTouched, action:" .. action)
		self.lastBattleActionChosen = action
		self.battleMenu.isVisible = false
		if action == BattleMenu.ATTACK then
			self.battleView:enableMonsterTouching(true)
		elseif action == BattleMenu.DEFEND then
			battleController:defend(battleController.charactersReady[1])
		elseif action == BattleMenu.ITEM then
			-- TODO
		elseif action == BattleMenu.CHANGE_ROW then
			battleController:changeRow(battleController.charactersReady[1])
		elseif action == BattleMenu.RUN then
			battleController:run(battleController.charactersReady[1])
		end
	end

	function test:onBattleViewMonsterTouched(event)
		print("test::onBattleViewMonsterTouched")
		self.battleView:enableMonsterTouching(false)
		self.battleView:enableCharacterTouching(false)
		assert(event.monster, "monster cannot be nil")
		local targets = {event.monster}
		assert(targets, "targets cannot be nil")
		assert(#targets, "targets cannot be empty")
		local battleController = self.battleController
		if self.lastBattleActionChosen == BattleMenu.ATTACK then
			print(targets)
			print(#targets)
			print("monster:", event.monster)
			battleController:attack(battleController.charactersReady[1],
									targets,
									self.lastBattleActionChosen)
		elseif self.lastBattleActionChosen == BattleMeu.ITEM then
			-- TODO: Wire up inventory
			local itemChosen
			battleController:useItem(battleController.charactersReady[1],
				targets,
				itemChosen)
		end
	end

	function test:onBattleViewActionAnimationHalfwayComplete(event)
		self.battleController:resolveActionResult(event.actionResult)
	end

	function test:onBattleViewActionAnimationComplete(event)
		self.battleController:resume()
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