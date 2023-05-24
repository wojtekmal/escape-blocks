@tool
class_name MyTileMap
extends TileMap
@export var board_dimensions : Vector2i : set = set_board_dimensions

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
