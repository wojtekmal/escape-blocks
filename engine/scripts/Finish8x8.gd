extends Area2D
signal player_reached_finish_area

@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var is_falling := true : set = set_is_falling
@export var start_rotations : int = 0

func _ready():
	add_to_group("wasd")

func _process(delta):
	if has_overlapping_bodies():
		emit_signal("player_reached_finish_area", start_rotations)

func set_is_falling(new_value):
	if new_value == true:
		push_error("You are changing Finish's is_falling, which is always false.")
	
func set_board_dimensions(newValue):
	board_dimensions = newValue
	set_board_cords(board_cords)

func set_board_cords(newValue):
	board_cords = newValue
	set_position(Vector2i(board_cords.x * 64 + 32 - board_dimensions.x * 32, board_cords.y * 64 + 32 - board_dimensions.y * 32))

func get_real_class():
	return "Finish"
