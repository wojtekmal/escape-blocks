@tool
class_name FinishBlock extends StaticBody2D

@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
# Always false.
@export var is_falling := false : set = set_is_falling
# Doesn't actually change.
@export var y_speed := 0

func _ready():
	pass # Replace with function body.

func set_board_dimensions(newValue):
	board_dimensions = newValue
	set_board_cords(board_cords)

func set_board_cords(newValue):
	board_cords = newValue
	set_position(Vector2i(board_cords.x * 64 + 32 - board_dimensions.x * 32, board_cords.y * 64 + 32 - board_dimensions.y * 32))

func get_real_class():
	return "StaticBlock8x8"

func set_is_falling(new_value):
	if new_value == true:
		push_error("You are changing StaticBlock8x8's is_falling, which is always false.")