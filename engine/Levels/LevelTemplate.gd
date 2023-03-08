@tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export var boardWidth: int := 1 : set = update_board_width
#export var boardHeight: int := 1 : set = update_board_height
@export var board_dimensions: Vector2 := Vector2(8, 5) : set = update_board_dimensions
@onready var tilemap := $TileMap
@export var total_rotations := 0
@onready var player := $Player
var moving_blocks = []
var column_block_heights = []
var fall_speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_target_fps(60)
	for child in self.get_children():
		if child.get_class() == "MovingBlock8x8":
			moving_blocks.push_back(child)
	#for moving_block in moving_blocks:
	#	print_debug("check")
	#for moving_block in moving_blocks:
	#	column_block_heights[moving_block.board_cords.x].push_back(moving_block.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player := $Player
	var size = $Player/StandingHitBox.shape.size
	#var size = hitbox_shape.size
	column_block_heights.clear()
	
	for i in range(0, board_dimensions.x + 1):
		column_block_heights.push_back([])
	for moving_block in moving_blocks:
		column_block_heights[moving_block.board_cords.x].push_back(moving_block.position.y)
		
	var left_wall = -board_dimensions.x * 32
	var player_left_column = (player.position.x - size.x - left_wall) / 64
	var player_right_column = (player.position.x + size.x - left_wall) / 64
	
	if player_left_column == player_right_column:
		column_block_heights[player_left_column].push_back(player.position.y)
	else:
		column_block_heights[player_left_column].push_back(player.position.y)
		column_block_heights[player_right_column].push_back(player.position.y)
	
	for i in range(0, board_dimensions.x):
		column_block_heights[i].sort()
		
	for block in moving_blocks:
		var delta_height = delta * fall_speed
		var new_block_cord_y = (block.position.y - delta_height - 32) / 64
	
	manage_changing_gravity()

func manage_changing_gravity():
	if !Engine.is_editor_hint():
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
	
	if Engine.is_editor_hint():
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
