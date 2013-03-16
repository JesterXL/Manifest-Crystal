-- Makes fixtures/mocks

require "vo.CharacterVO"
require "vo.MonsterVO"

Generator = {}

Generator.getCharactersAndMonsters = function()
	local characters = {}
	local jesse = CharacterVO:new()
	jesse.name = "Jesse"
	local brandy = CharacterVO:new()
	brandy.name = "Brandy"
	table.insert(characters, jesse)
	table.insert(characters, brandy)

	local monsters = {}
	local goblin1 = MonsterVO:new()
	goblin1.name = "Goblin 1"
	local goblin2 = MonsterVO:new()
	goblin2.name = "Goblin 2"
	table.insert(monsters, goblin1)
	table.insert(monsters, goblin2)

	return characters, monsters
end

return Generator