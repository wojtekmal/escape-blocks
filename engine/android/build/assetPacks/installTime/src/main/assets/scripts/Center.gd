extends Node2D
@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var start_rotations : int = 1
@export var open := false
@export var is_falling := false : set = set_is_falling
@export var y_speed := 0
@export var can_close : bool

func _ready():
	add_to_group("wasd")

func set_board_dimensions(newValue):
	board_dimensions = newValue
	set_board_cords(board_cords)

func set_board_cords(newValue):
	board_cords = newValue

func set_is_falling(new_value):
	if new_value == true:
		push_error("You are changing StaticBlock8x8's is_falling, which is always false.")
