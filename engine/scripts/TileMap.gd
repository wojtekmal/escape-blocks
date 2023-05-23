@tool
class_name MyTileMap
extends TileMap
@export var board_dimensions : Vector2i : set = set_board_dimensions

#var conections := {
#	Vector2i(0, 0) : [1, 1, 1, 1],
#	Vector2i(1, 0) : [0, 1, 1, 1],
#	Vector2i(2, 0) : [1, 0, 1, 1],
#	Vector2i(3, 0) : [0, 0, 1, 1],
#
#	Vector2i(0, 1) : [1, 1, 0, 1],
#	Vector2i(1, 1) : [0, 1, 0, 1],
#	Vector2i(2, 1) : [1, 0, 0, 1],
#	Vector2i(3, 1) : [0, 0, 0, 1],
#
#	Vector2i(0, 2) : [1, 1, 1, 0],
#	Vector2i(1, 2) : [0, 1, 0, 0],
#	Vector2i(2, 2) : [1, 0, 1, 0],
#	Vector2i(3, 2) : [0, 0, 0, 0],
#
#	Vector2i(0, 3) : [1, 1, 1, 0],
#	Vector2i(1, 3) : [0, 1, 0, 0],
#	Vector2i(2, 3) : [1, 0, 1, 0],
#	Vector2i(3, 3) : [0, 0, 0, 0],
#}

var conections := {
	Vector2i(0, 0) : [1, 1, 1, 1],
	Vector2i(1, 0) : [0, 1, 1, 1],
	Vector2i(2, 0) : [1, 0, 1, 1],
	Vector2i(3, 0) : [0, 0, 1, 1],

	Vector2i(0, 1) : [1, 1, 0, 1],
	Vector2i(1, 1) : [0, 1, 0, 1],
	Vector2i(2, 1) : [1, 0, 0, 1],
	Vector2i(3, 1) : [0, 0, 0, 1],

	Vector2i(0, 2) : [1, 1, 1, 0],
	Vector2i(1, 2) : [0, 1, 1, 0],
	Vector2i(2, 2) : [1, 0, 1, 0],
	Vector2i(3, 2) : [0, 0, 1, 0],

	Vector2i(0, 3) : [1, 1, 0, 0],
	Vector2i(1, 3) : [0, 1, 0, 0],
	Vector2i(2, 3) : [1, 0, 0, 0],
	Vector2i(3, 3) : [0, 0, 0, 0],
}

func get_real_class():
	return "TileMap"

func set_board_dimensions(newValue):
	if !Engine.is_editor_hint():
		return
	
	for i in range(-board_dimensions.x * 4 - 1, board_dimensions.x * 4 + 1):
		set_cell(0, Vector2i(i, board_dimensions.y * 4), -1, Vector2i(0, 0))
		set_cell(0, Vector2i(i, -board_dimensions.y * 4 - 1), -1, Vector2i(0, 0))
	
	for i in range(-board_dimensions.y * 4 - 1, board_dimensions.y * 4 + 1):
		set_cell(0, Vector2i(-board_dimensions.x * 4 - 1, i), -1, Vector2i(0, 0))
		set_cell(0, Vector2i(board_dimensions.x * 4, i), -1, Vector2i(0, 0))
		
	for i in range(-newValue.x * 4 - 1, newValue.x * 4 + 1):
		set_cell(0, Vector2i(i, newValue.y * 4), 0, Vector2i(0, 0))
		set_cell(0, Vector2i(i, -newValue.y * 4 - 1), 0, Vector2i(0, 0))

	for i in range(-newValue.y * 4 - 1, newValue.y * 4 + 1):
		set_cell(0, Vector2i(-newValue.x * 4 - 1, i), 0, Vector2i(0, 0))
		set_cell(0, Vector2i(newValue.x * 4, i), 0, Vector2i(0, 0))
	
	board_dimensions = newValue

func correct(tile: Vector2i, position : Vector2i):
	var con = conections[tile];
	
	if(conections.has(get_cell_atlas_coords(0, position + Vector2i.UP)) and 
		conections[get_cell_atlas_coords(0, position + Vector2i.UP)][2] != con[0]):
#		print(get_cell_atlas_coords(0, position + Vector2i.UP), " wrong")
		return false
		
	if(conections.has(get_cell_atlas_coords(0, position + Vector2i.DOWN)) and 
		conections[get_cell_atlas_coords(0, position + Vector2i.DOWN)][0] != con[2]):
#		print(get_cell_atlas_coords(0, position + Vector2i.DOWN), " wrong")
		return false
	
	if(conections.has(get_cell_atlas_coords(0, position + Vector2i.LEFT)) and 
		conections[get_cell_atlas_coords(0, position + Vector2i.LEFT)][1] != con[3]):
#		print(get_cell_atlas_coords(0, position + Vector2i.LEFT), " wrong")
		return false
	
	if(conections.has(get_cell_atlas_coords(0, position + Vector2i.RIGHT)) and 
		conections[get_cell_atlas_coords(0, position + Vector2i.RIGHT)][3] != con[1]):
#		print(get_cell_atlas_coords(0, position + Vector2i.RIGHT), " wrong")
		return false
	
	return true

func collapse():
	
	var toFill := get_used_cells_by_id(0)
	toFill.shuffle()
	
	for tile in toFill:
#		print(tile)
		
		
#		while(!correct(newTile, tile)):
#			newTile = Vector2i(randi() % 4, randi() % 4);
#		var found = false;
		for i in range(0, 500):
			var newTile := Vector2i(randi() % 4, randi() % 4)
			if(correct(newTile, tile)):
				set_cell(0, tile, 2, newTile)
				break
	
