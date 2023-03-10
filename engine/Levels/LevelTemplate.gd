@tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export var boardWidth: int := 1 : set = update_board_width
#export var boardHeight: int := 1 : set = update_board_height
@export var board_dimensions := Vector2i(8, 5) : set = update_board_dimensions
@onready var tilemap := $TileMap
@export var total_rotations := 0
@onready var player := $Player
var moving_blocks = []
var column_block_heights = []
var fall_speed = 20
var first_frame = true
var frame_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	#for moving_block in moving_blocks:
	#	print_debug("check")
	#for moving_block in moving_blocks:
	#	column_block_heights[moving_block.board_cords.x].push_back(moving_block.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Engine.is_editor_hint() and !player.is_rotating:
		var size = $Player/StandingHitBox.shape.size
		#var size = hitbox_shape.size
		column_block_heights.clear()
		moving_blocks.clear()
		
		for child in self.get_children():
			if child.get_real_class() == "MovingBlock8x8":
				moving_blocks.push_back(child)
		
		for i in range(0, board_dimensions.x + 1):
			column_block_heights.push_back([])
		for moving_block in moving_blocks:
			column_block_heights[moving_block.board_cords.x].push_back(moving_block.position.y)
			
		var left_wall = -board_dimensions.x * 32
		var player_left_column = (int(player.position.x) - int(size.x) - left_wall) / 64
		var player_right_column = (int(player.position.x) + int(size.x) - left_wall) / 64
		
		if player_left_column == player_right_column:
			column_block_heights[player_left_column].push_back(player.position.y)
		else:
			column_block_heights[player_left_column].push_back(player.position.y)
			column_block_heights[player_right_column].push_back(player.position.y)
		
		for i in range(0, board_dimensions.x):
			column_block_heights[i].sort()
			column_block_heights[i].reverse()
			#if first_frame:
				#for height in column_block_heights[i]:
				#	print_debug(height)
				#print_debug("a")
		
		for block in moving_blocks:
			var delta_height = delta * fall_speed
			var new_block_cord_y = int(block.position.y + board_dimensions.y * 32 + delta_height - 32 - 1) / 64 + 1
			var max_height = board_dimensions.y - 1
			
			for height in column_block_heights[block.board_cords.x]:
				if height > block.position.y:
					max_height -= 1
					
			if block.position.y == max_height * 64 - board_dimensions.y * 32 + 32:
				block.is_falling = false
				continue
			if new_block_cord_y > max_height:
				block.is_falling = false
				#here the height of the block is set so that it lands on something else
				block.board_cords = Vector2i(block.board_cords.x, max_height)
			else:
				block.is_falling = true
				block.position.y += delta_height
			
		move_player(delta, player_left_column, player_right_column)
		
		manage_changing_gravity()
	first_frame = false
	frame_count += 1
			
func move_player(delta, player_left_column, player_right_column):
	var delta_height = delta * fall_speed
	var new_player_cord_y = int(player.position.y + board_dimensions.y * 32 + delta_height - 32 - 1) / 64 + 1
	var max_height_1 = board_dimensions.y - 1
	var max_height_2 = board_dimensions.y - 1
	
	for height in column_block_heights[player_left_column]:
		if frame_count < 10:
			print_debug(height)
		if height > player.position.y:
			max_height_1 -= 1
			
	for height in column_block_heights[player_right_column]:
		if height > player.position.y:
			max_height_2 -= 1
			
	var max_height = min(max_height_1, max_height_2)
	if frame_count < 10:
		print_debug(max_height)
	
	if player.position.y == max_height * 64 - board_dimensions.y * 32 + 32:
		player.is_falling = false
		return
	if new_player_cord_y > max_height:
		player.is_falling = false
		#here the height of the block is set so that it lands on something else
		player.board_cords = Vector2i(player.board_cords.x, max_height)
	else:
		player.is_falling = true
		player.position.y += delta_height
	if frame_count < 10:
		print_debug("\n")

func manage_changing_gravity():
	pass

func update_board_dimensions(newValue):
	if Engine.is_editor_hint():
		for i in range(-board_dimensions.x * 4 - 1, board_dimensions.x * 4 + 1):
			tilemap.set_cell(0, Vector2i(i, board_dimensions.y * 4), -1, Vector2i(0, 0))
			tilemap.set_cell(0, Vector2i(i, -board_dimensions.y * 4 - 1), -1, Vector2i(0, 0))
	
		for i in range(-board_dimensions.y * 4 - 1, board_dimensions.y * 4 + 1):
			tilemap.set_cell(0, Vector2i(-board_dimensions.x * 4 - 1, i), -1, Vector2i(0, 0))
			tilemap.set_cell(0, Vector2i(board_dimensions.x * 4, i), -1, Vector2i(0, 0))
			
		for i in range(-newValue.x * 4 - 1, newValue.x * 4 + 1):
			tilemap.set_cell(0, Vector2i(i, newValue.y * 4), 0, Vector2i(0, 0))
			tilemap.set_cell(0, Vector2i(i, -newValue.y * 4 - 1), 0, Vector2i(0, 0))
	
		for i in range(-newValue.y * 4 - 1, newValue.y * 4 + 1):
			tilemap.set_cell(0, Vector2i(-newValue.x * 4 - 1, i), 0, Vector2i(0, 0))
			tilemap.set_cell(0, Vector2i(newValue.x * 4, i), 0, Vector2i(0, 0))
	
	board_dimensions = newValue
	
	for child in get_children():
		#print_debug(child.get_name())
		if child.get_real_class() == "MovingBlock8x8" or child.get_real_class() == "Player":
			#print_debug("check")
			child.board_dimensions = board_dimensions
			
	print_debug(board_dimensions)
	
	return board_dimensions
