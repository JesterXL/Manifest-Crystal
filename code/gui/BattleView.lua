require "sprites.CharacterSprite"
require "sprites.MonsterSprite"

BattleView = {}

function BattleView:new(characters, monsters)
	assert(characters, "Characters cannot be nil")
	assert(monsters, "Monsters cannot be nil")

	local view = display.newGroup()
	view.characters = nil
	view.monsters = nil

	function view:init(characters, monsters)
		self:destroy()

		self.characters = characters
		self.monsters = monsters

		local i
		local startX = 30
		local startY = stage.height / 2
		for i=1,#monsters do
			local monster = monsters[i]
			monster:addEventListener("onHitPointsChanged", self)
			local monsterSprite = MonsterSprite:new()
			monster.battleSprite = monsterSprite
			monsterSprite.monster = monster
			monsterSprite:addEventListener("onMonsterSpriteTouched", self)
			monsterSprite.x = startX
			monsterSprite.y = startY
			startX = startX + 20
			startY = startY - monsterSprite.height - 8
		end

		startX = stage.width - 100
		startY = 64
		for i=1,#characters do
			local character = characters[i]
			character:addEventListener("onHitPointsChanged", self)
			local characterSprite = CharacterSprite:new()
			character.battleSprite = characterSprite
			characterSprite.character = character
			characterSprite:addEventListener("onCharacterSpriteTouched", self)
			characterSprite.x = startX
			characterSprite.y = startY
			startX = startX + 16
			startY = startY + characterSprite.height + 4
		end


	end

	function view:enableMonsterTouching(enable)
		print("BattleView::enableMonsterTouching, enable:", enable)
		local monsters = self.monsters
		local i
		for i=1,#monsters do
			local monster = monsters[i]
			monster.battleSprite:enableTouch(enable)
		end
	end

	function view:enableCharacterTouching(enable)
		print("BattleView::enableCharacterTouching, enable:", enable)
		local characters = self.characters
		local i
		for i=1,#characters do
			local character = characters[i]
			character.battleSprite:enableTouch(enable)
		end
	end

	function view:handleAction(actionResult)
		print("BattleView::handleAction, actionResult:", actionResult)
		local character = actionResult.targets[1]
		local targetSprite = character.battleSprite
		local attackerSprite = actionResult.attacker.battleSprite
		local completeFunc = {}
		completeFunc.actionResult = actionResult
		function completeFunc:onComplete(event)
			view:onLand(self.actionResult)
		end

		attackerSprite.tweenID = transition.to(attackerSprite, {time=500, x=targetSprite.x, y=targetSprite.y, onComplete=completeFunc})
	end

	function view:onLand(actionResult)
		print("BattleView::onLand")
		local target = actionResult.targets[1]
		local targetSprite = target.battleSprite
		if actionResult.hit == false then
			-- TODO: show hit text
		else
			-- TODO: show damage text
		end

		local attackerSprite = actionResult.attacker.battleSprite
		attackerSprite.tweenID = transition.to(attackerSprite, {time=500, x=0, y=0})
		self:dispatchEvent({name="onBattleViewActionAnimationComplete", actionResult=actionResult})
	end

	function view:onHitPointsChanged(event)
		-- TODO: show hitpoints text
	end

	function view:onMonsterSpriteTouched(event)
		print("BattleView::onMonsterSpriteTouched")
		local target = event.target
		self:dispatchEvent({name="onBattleViewMonsterTouched", target=self, monster=target.monster})
	end

	function view:onCharacterSpriteTouched(event)
		local target = event.target
		self:dispatchEvent({name="onBattleViewCharacterTouched", target=self, character=target.character})
	end

	function view:destroy()

	end

	view:init(characters, monsters)

	return view
end

return BattleView