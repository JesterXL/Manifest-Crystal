require "tilemap.TileTypes"
DebugGridView = {}


function DebugGridView:new(grid, tileWidth, tileHeight)

	local view = display.newGroup()
	view.grid = nil
	view.tileWidth = tileWidth
	view.tileHeight = tileHeight
	view.gridHolder = nil

	function view:init(grid, tileWidth, tileHeight)
		self.grid = grid
		self.grid:addEventListener("onChange", self)
		self.tileWidth = tileWidth
		self.tileHeight = tileHeight

		if self.gridHolder then
			self.gridHolder:removeSelf()
		end
		self.gridHolder = display.newGroup()
		self:insert(self.gridHolder)
		local startX = 0
		local startY = 0
		local r, c
		for r=1,grid.rows do
			for c=1,grid.cols do
				local tile = grid:getTile(r, c)
				local rect = display.newRect(0, 0, tileWidth, tileHeight)
				self.gridHolder[r .. "_" .. c] = rect
				rect:setReferencePoint(display.TopLeftReferencePoint)
				rect:setStrokeColor(0, 255, 0)
				local tileColor = self:getTileColor(tile)
				rect:setFillColor(unpack(tileColor))
				rect.strokeWidth = 1
				self.gridHolder:insert(rect)
				rect.x = startX
				rect.y = startY
				startX = startX + tileWidth
			end
			startX = 0
			startY = startY + tileHeight
		end
	end

	function view:getTileColor(tile)
		local tileColor
		if tile == TileTypes.WALKABLE then
			tileColor = {0, 255, 0, 100}
		elseif tile == TileTypes.IMPASSABLE then
			tileColor = {255, 0, 0, 100}
		elseif tile == TileTypes.ACTION then
			tileColor = {255, 255, 0, 100}
		elseif tile == TileTypes.STARTING then
			tileColor = {0, 0, 255, 100}
		end
		return tileColor
	end


	function view:onChange(event)
		local rect = self.gridHolder[event.row .. "_" .. event.col]
		rect:setFillColor(unpack(self:getTileColor(event.value)))
	end

	view:init(grid, tileWidth, tileHeight)

	return view

end

return DebugGridView