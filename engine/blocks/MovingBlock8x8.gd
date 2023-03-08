@tool
class_name MovingBlock8x8 extends CharacterBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var board_cords: Vector2 : set = update_board_cords
@export var board_dimensions: Vector2 : set = update_board_dimensions


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_board_dimensions(newValue):
	board_dimensions = newValue
	update_board_cords(board_cords)

func update_board_cords(newValue):
	board_cords = newValue
	set_position(Vector2(-(board_dimensions.x / 2 - board_cords.x) * 64 + 32, -(board_dimensions.y / 2 - board_cords.y) * 64 + 32))

func get_class():
	return "MovingBlock8x8"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
