tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export(int) var boardWidth := 1 setget update_board_width
#export(int) var boardHeight := 1 setget update_board_height
export(Vector2) var board_dimensions := Vector2(8, 5) setget update_board_dimensions
onready var tilemap := $TileMap
export var total_rotations := 0
onready var player := $Player
onready var moving_blocks = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_children():
		print_debug(child.get_class())
		if child.get_class() == "MovingBlock8x8":
			moving_blocks.push_back(child)
#	 # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	manage_changing_gravity()

func manage_changing_gravity():
	if !Engine.editor_hint:
		var rotations = 0
		if(Input.is_action_just_pressed("gravity_right")):
			rotations += 1
		if(Input.is_action_just_pressed("gravity_up")):
			rotations += 2
		if(Input.is_action_just_pressed("gravity_left")):
			rotations += 3
		total_rotations += rotations
		if Input.is_action_just_pressed("debug1"):
			total_rotations += 1

func update_board_dimensions(newValue):
	tilemap = $TileMap
	
	if Engine.editor_hint:
		for i in range(-board_dimensions.x * 4 - 1, board_dimensions.x * 4 + 1):
			tilemap.set_cell(i, board_dimensions.y * 4, -1)
			tilemap.set_cell(i, -board_dimensions.y * 4 - 1, -1)
	
		for i in range(-board_dimensions.y * 4 - 1, board_dimensions.y * 4 + 1):
			tilemap.set_cell(-board_dimensions.x * 4 - 1, i, -1)
			tilemap.set_cell(board_dimensions.x * 4, i, -1)
			
		for i in range(-newValue.x * 4 - 1, newValue.x * 4 + 1):
			tilemap.set_cell(i, newValue.y * 4, 0)
			tilemap.set_cell(i, -newValue.y * 4 - 1, 0)
	
		for i in range(-newValue.y * 4 - 1, newValue.y * 4 + 1):
			tilemap.set_cell(-newValue.x * 4 - 1, i, 0)
			tilemap.set_cell(newValue.x * 4, i, 0)
	
	board_dimensions = newValue
	
	for child in self.get_children():
		if child.get_class() == "MovingBlock8x8":
			child.update_board_dimensions(board_dimensions)
			
	print_debug(board_dimensions)
