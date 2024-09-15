extends TileMapLayer

@onready var obstacles : TileMapLayer = $"../Walls"

func _use_tile_data_runtime_update(coords: Vector2i) -> bool: # So that the tiles with obstacles on them update on runtime
	if coords in obstacles.get_used_cells_by_id(2):
		return true
	return false


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void: # So that there's now navigation polygon on those tiles
	if coords in obstacles.get_used_cells_by_id(2):
		tile_data.set_navigation_polygon(0, null)
