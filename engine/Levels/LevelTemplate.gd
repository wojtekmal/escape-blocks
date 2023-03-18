@tool
extends Node2D

#export var boardWidth: int := 1 : set = update_board_width
#export var boardHeight: int := 1 : set = update_board_height
@export var board_dimensions := Vector2i(8, 5) : set = set_board_dimensions
@export var total_rotations : int = 0
@export var now_rotations : int
@onready var tilemap := $TileMap
@onready var player := $Player
@onready var rotation_timer = $RotationTimer
var moving_entities = []
var column_top_still_blocks = []
var fall_speed = 20
var first_frame = true
var frame_count = 0
var left_wall = -board_dimensions.x * 32
var top_wall = -board_dimensions.y * 32
var positions_before_rotations = []

func _ready():
	rotation_timer.timeout.connect(rotation_ended)
	pass
	#for moving_block in moving_blocks:
	#	print_debug("check")
	#for moving_block in moving_blocks:
	#	column_block_heights[moving_block.board_cords.x].push_back(moving_block.position.y)

func _process(delta):
	if Engine.is_editor_hint():
		# We won't be loading frames in the editor.
		return
		
	manage_changing_gravity()
	
	if !rotation_timer.is_stopped():
		return
	
	column_top_still_blocks.clear()
	moving_entities.clear()
	
	for child in self.get_children():
		if child.get_real_class() == "MovingBlock8x8" or child.get_real_class() == "Player":
			moving_entities.push_back(child)
	
	moving_entities.sort_custom(compare_entity_heights)
	
	for i in range(0, board_dimensions.x):
		column_top_still_blocks.push_back(board_dimensions.y)
	
	for entity in moving_entities:
		if entity.get_real_class() == "MovingBlock8x8":
			move_block(delta, entity)
		elif entity.get_real_class() == "Player":
			move_player(delta)
	
	first_frame = false
	frame_count += 1
	
func compare_entity_heights(a, b):
	return a.position.y > b.position.y
	# Sorts the entities in decreasing order according to their height.

func move_block(delta, block):
	var delta_height = delta * fall_speed
	var new_block_cord_y = int(block.position.y - top_wall + delta_height - 32 - 1) / 64 + 1
	# Ceiling division.
	var max_height = column_top_still_blocks[block.board_cords.x] - 1
	
	if block.position.y == top_wall + max_height * 64 + 32:
		column_top_still_blocks[block.board_cords.x] = max_height
		block.board_cords.y = max_height
		block.is_falling = false
		return
	
	if new_block_cord_y > max_height:
		block.is_falling = false
		# Here the height of the block is set so that it lands on something else.
		block.board_cords.y = max_height
	else:
		block.is_falling = true
		block.position.y += delta_height
	
	if block.position.y == top_wall + max_height * 64 + 32:
		column_top_still_blocks[block.board_cords.x] = max_height
		block.board_cords.y = max_height
		block.is_falling = false
		return

func move_player(delta):
	var delta_height = delta * fall_speed
	var new_player_cord_y = int(player.position.y - top_wall + delta_height - 32 - 1) / 64 + 1
	var size = $Player/StandingHitBox.shape.size
	var player_left_column = int(player.position.x - size.x - left_wall) / 64
	var player_right_column = int(player.position.x + size.x - left_wall) / 64
	var max_height_1 = column_top_still_blocks[player_left_column] - 1
	var max_height_2 = column_top_still_blocks[player_right_column] - 1
	var max_height = min(max_height_1, max_height_2)
	
	if player.position.y == top_wall + max_height * 64 + 32:
		column_top_still_blocks[player_left_column] = max_height
		column_top_still_blocks[player_right_column] = max_height
		player.board_cords.y = max_height
		player.is_falling = false
		return
	
	if new_player_cord_y > max_height:
		player.is_falling = false
		#here the height of the block is set so that it lands on something else
		player.board_cords.y = max_height
	else:
		player.is_falling = true
		player.position.y += delta_height
	
	if player.position.y == top_wall + max_height * 64 + 32:
		column_top_still_blocks[player_left_column] = max_height
		column_top_still_blocks[player_right_column] = max_height
		player.board_cords.y = max_height
		player.is_falling = false
		return

func manage_changing_gravity():
	if Engine.is_editor_hint():
		# We won't be loading frames in the editor.
		return
	
	var rotations = 0
	if(Input.is_action_just_pressed("gravity_right")):
		rotations += 1
	if(Input.is_action_just_pressed("gravity_up")):
		rotations += 2
	if(Input.is_action_just_pressed("gravity_left")):
		rotations += 3
		
	if all_not_falling() and rotation_timer.is_stopped() and rotations != 0:
		now_rotations = rotations
		total_rotations += now_rotations
		rotation_timer.start(rotation_timer.wait_time)
		positions_before_rotations.clear()
		
		for entity in moving_entities:
			positions_before_rotations.push_back(entity.position)
	
	if rotation_timer.is_stopped():
		# If there is no rotation now, skip the rest.
		return
	
	var change_angle = PI * now_rotations * (rotation_timer.wait_time - rotation_timer.time_left) / rotation_timer.wait_time / 2
	tilemap.rotation = change_angle
	#print_debug((total_rotations - now_rotations) * PI / 2 + change_angle)
	
	for i in range(0, moving_entities.size()):
		var entity = moving_entities[i]
		var position_before_rotation = positions_before_rotations[i]
		entity.position = position_before_rotation.rotated(change_angle)
		if entity.get_real_class() != "Player":
			entity.rotation = -(total_rotations - now_rotations) * PI / 2 + change_angle
	
	#rotation = PI / 2 * total_rotations
	
	# Now we rotate the whole board along with the player, walls and blocks.
	# We rotate the board around its center in the direction opposite to the way
	# the player is rotated. 
	
	#if now_rotations % 2:
	#	board_dimensions = Vector2i(board_dimensions.y, board_dimensions.x)
	#
	#for i in range(0, now_rotations):
	#	# I'm rotating everything 90 degrees counterclockwise 'now_rotations' times.
	#	for entity in moving_entities:
	#		pass
	#		# For the blocks I'm changing the positions and board coordinates 
	#		# and for the player I'm changing only the position.
	#		if entity.get_real_class() == "Player":
	#			entity.position = Vector2(-entity.position.y, entity.position.x)
	#			print_debug(entity.position)
	#			continue
	#		
	#		entity.board_cords = Vector2i(
	#			-entity.board_cords.y,
	#			board_dimensions.x - entity.board_cords.x - 1
	#		)
	#		print_debug(entity.board_cords)
	#		entity.position = Vector2(-entity.position.y, entity.position.x)
	#		print_debug(entity.position)

func all_not_falling():
	for entity in moving_entities:
		if entity.is_falling:
			return false
		
	return true

func rotation_ended():
	tilemap.rotation = 0
	
	if now_rotations % 2:
		board_dimensions = Vector2i(board_dimensions.y, board_dimensions.x)
	else:
		board_dimensions = board_dimensions
	
	for i in range(0, moving_entities.size()):
		var entity = moving_entities[i]
		entity.rotation = 0
		var position_before_rotation = positions_before_rotations[i]
		entity.position = Vector2(position_before_rotation.x, position_before_rotation.y).rotated(now_rotations * PI / 2)
		
		#if entity.get_real_class() == "MovingBlock8x8":
		entity.board_cords = Vector2i(
			round((entity.position.x - left_wall - 32) / 64),
			round((entity.position.y - top_wall - 32) / 64)
		)
		#print_debug("entity board_cords and position and left_wall and top_wall")
		#print_debug(entity.board_cords)
		#print_debug(entity.position)
		#print_debug(left_wall)
		#print_debug(top_wall)

func set_board_dimensions(newValue):
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
	left_wall = -board_dimensions.x * 32
	top_wall = -board_dimensions.y * 32
	
	for child in get_children():
		#print_debug(child.get_name())
		if child.get_real_class() == "MovingBlock8x8" or child.get_real_class() == "Player":
			#print_debug("check")
			child.board_dimensions = board_dimensions
	
	return board_dimensions
