@tool
class_name StaticBlock8x8 extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var is_falling := false : set = set_is_falling
# Always false.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_board_dimensions(newValue):
	board_dimensions = newValue
	set_board_cords(board_cords)

func set_board_cords(newValue):
	board_cords = newValue
	#print_debug(board_dimensions)
	#print_debug(board_cords)
	#print_debug("\n")
	set_position(Vector2i(board_cords.x * 64 + 32 - board_dimensions.x * 32, board_cords.y * 64 + 32 - board_dimensions.y * 32))

#func get_class():
#	return "MovingBlock8x8"

func get_real_class():
	return "StaticBlock8x8"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func set_is_falling(new_value):
	push_error("You are changing StaticBlock8x8's is_falling, which is always false.")
