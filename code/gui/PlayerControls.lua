require "gui.NorthButton"
require "gui.SouthButton"
require "gui.EastButton"
require "gui.WestButton"
require "gui.InteractButton"

PlayerControls = {}

function PlayerControls:new()

	local controls = display.newGroup()

	function controls:init()
		local background = display.newImage("gui/compass-table.png")
		background:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(background)
		self.background = background
		background.x = stage.width / 2 - background.width / 2
		background.y = stage.height - background.height

		local north = NorthButton:new()
		local south = SouthButton:new()
		local east = EastButton:new()
		local west = WestButton:new()

		self:insert(north)
		self:insert(south)
		self:insert(east)
		self:insert(west)

		local centerToBackground = function(button)
			button.x = background.x + background.width / 2 - button.width / 2
		end
		centerToBackground(north)
		centerToBackground(south)
		north.y = background.y + north.height - 10
		south.y = background.y + background.height - south.height - 80
		east.x = background.x + background.width - east.width - 100
		east.y = background.y + background.height / 2 - east.height / 2
		west.x = background.x + west.width + 20
		west.y = background.y + background.height / 2 - west.height / 2

		local interact = InteractButton:new()
		self:insert(interact)
		interact.x = background.x + background.width / 2 - interact.width / 2
		interact.y = background.y + background.height / 2 - interact.height / 2 - 2
	end

	controls:init()

	return controls

end

return PlayerControls