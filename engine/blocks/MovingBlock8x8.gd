tool
class_name MovingBlock8x8 extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Vector2) var board_cords setget update_board_cords
export(Vector2) var board_dimensions setget update_board_dimensions


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_board_dimensions(newValue):
	board_dimensions = newValue
	update_board_cords(board_cords)
	print_debug(board_dimensions)

func update_board_cords(newValue):
	board_cords = newValue
	set_position(Vector2(-(board_dimensions.x / 2 - board_cords.x - 1) * 64 + 32, -(board_dimensions.y / 2 - board_cords.y - 1) * 64 + 32))
	print_debug(board_dimensions)

func get_class():
	return "MovingBlock8x8"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
