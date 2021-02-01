extends TileMap

func _ready():
#	 for child in get_children():
#		 set_cellv(world_to_map(child.position), child.type)
	pass

func requestMovePosition(cursor, direction):
	var cell_start = world_to_map(cursor.position)
	var cell_target = cell_start + direction
	return map_to_world(cell_target) + cell_size / 2

