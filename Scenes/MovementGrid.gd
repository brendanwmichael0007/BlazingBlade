extends TileMap

func requestMovePosition(cursor, direction):
	var cell_start = world_to_map(owner.position)
	var cell_target = cell_start + direction
	return map_to_world(cell_target) + cell_size / 2
