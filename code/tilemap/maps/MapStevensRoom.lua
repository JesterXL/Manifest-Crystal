require "tilemap.Grid"
require "tilemap.TileTypes"

MapStevensRoom = {}
MapStevensRoom.image = "assets/maps/stevens-room.png"
MapStevensRoom.tiles = Grid:new(5, 4, TileTypes.WALKABLE)
MapStevensRoom.offsetX = -4
MapStevensRoom.offsetY = -4
MapStevensRoom.startRow = 4
MapStevensRoom.startCol = 1

MapStevensRoom.tiles:setTile(1, 1, TileTypes.IMPASSABLE)
MapStevensRoom.tiles:setTile(1, 2, TileTypes.IMPASSABLE)
MapStevensRoom.tiles:setTile(1, 3, TileTypes.IMPASSABLE)
MapStevensRoom.tiles:setTile(1, 4, TileTypes.IMPASSABLE)

MapStevensRoom.tiles:setTile(2, 1, TileTypes.IMPASSABLE)
MapStevensRoom.tiles:setTile(2, 3, TileTypes.IMPASSABLE)
MapStevensRoom.tiles:setTile(2, 4, TileTypes.IMPASSABLE)

MapStevensRoom.tiles:setTile(5, 1, TileTypes.IMPASSABLE)
MapStevensRoom.tiles:setTile(5, 2, TileTypes.IMPASSABLE)
MapStevensRoom.tiles:setTile(5, 3, TileTypes.ACTION)
MapStevensRoom.tiles:setTile(5, 4, TileTypes.IMPASSABLE)

--MapStevensRoom.tiles:setTile(4, 1, TileTypes.STARTING)

return MapStevensRoom