Grid = {}

function Grid:new(rows, cols, initialValue)
	
	local grid = display.newGroup()

	grid.rows = nil
	grid.cols = nil
	
	grid.tiles = nil
	
	function grid:init(rows, cols, initialValue)
	    if initialValue == nil then initialValue = 0 end
	    
	    self.rows = rows
	    self.cols = cols
	    local tiles = {}
	    local row, col
	    for row=1,rows do
			tiles[row] = {}
			for col=1,cols do
			   tiles[row][col] = initialValue
			end
	    end
	    self.tiles = tiles
	end
	
	function grid:getTile(row, col)
		assert(self.tiles, "Tiles is nil")
		assert(row, "row can't be nil")
		assert(col, "col can't be nil")
		assert(row <= self.rows and row > 0, "Row out of range")
		assert(col <= self.cols and col > 0, "Col out of range")
	    return self.tiles[row][col]
	end
	
	function grid:setTile(row, col, value)
		local oldValue = self:getTile(row, col)
	    self.tiles[row][col] = value
	    self:dispatchEvent({name="onChange", target=self, oldValue=oldValue, value=value, row=row, col=col})
	end

	grid:init(rows, cols, initialValue)

	return grid
    
end

return Grid
