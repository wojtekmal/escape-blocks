@tool
class_name MovingBlock8x8 extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var is_falling : bool = true : set = set_is_falling
# How fast the block is falling down.
@export var y_speed := 0
@export var start_rotations : int = 0

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
	position = Vector2i(board_cords.x * 64 + 32 - board_dimensions.x * 32, board_cords.y * 64 + 32 - board_dimensions.y * 32)

#func get_class():
#	return "MovingBlock8x8"

func get_real_class():
	return "MovingBlock8x8"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func set_is_falling(new_value):
	is_falling = new_value

func falling_sound(y_speed):
	$Landing.volume_db = -15 + y_speed / 30
	#print($Landing.volume_db)
	$Landing.play()
