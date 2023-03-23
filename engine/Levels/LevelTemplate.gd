@tool
class_name LevelTemplate
extends Node2D

#export var boardWidth: int := 1 : set = update_board_width
#export var boardHeight: int := 1 : set = update_board_height
@export var board_dimensions : Vector2i : set = set_board_dimensions
@export var total_rotations : int = 0
@export var now_rotations : int
@onready var tilemap := $BoardLimits
@onready var player := $Player
@onready var rotation_timer = $RotationTimer
@onready var walls := $Walls
@onready var finish_area := $FinishArea
var moving_entities = []
var column_top_still_blocks = []
var fall_speed = 100
var first_frame = true
var frame_count = 0
var left_wall = -board_dimensions.x * 32
var top_wall = -board_dimensions.y * 32
var positions_before_rotations = []
var finish_area_position_before_rotation
#var finish_area_start_rotation
var static_block = preload("res://blocks/StaticBlock8x8.tscn")
var moving_block = preload("res://blocks/MovingBlock8x8.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_timer.timeout.connect(rotation_ended)
	board_dimensions = board_dimensions
	tilemap.board_dimensions = board_dimensions
	#finish_area_start_rotation = finish_area.rotation
	#calls the setter function
	finish_area.player_reached_finish.connect(maybe_end_game)
	
	var wall_tiles = walls.get_used_cells_by_id(0, 0, Vector2i(0,0), -1)
	
	if Engine.is_editor_hint():
		return
	
	for wall_tile in wall_tiles:
		#print_debug("check")
		var new_static_block_8x8 = static_block.instantiate()
		new_static_block_8x8.board_cords = wall_tile
		new_static_block_8x8.board_dimensions = board_dimensions
		add_child(new_static_block_8x8)
	
	walls.visible = false
	
	load_blocks_from_tilemap()
	#for moving_block in moving_blocks:
	#	print_debug("check")
	#for moving_block in moving_blocks:
	#	column_block_heights[moving_block.board_cords.x].push_back(moving_block.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		# We won't be loading frames in the editor.
		return
		
	manage_changing_gravity()
	manage_falling_entities(delta)
		
	first_frame = false
	frame_count += 1


func maybe_end_game():
	#print_debug(player.rotation)
	#print_debug(finish_area.rotation)
	if (finish_area.initial_rotations + total_rotations) % 4 == 0:
		print_debug("End game.")


func manage_falling_entities(delta):
	if !rotation_timer.is_stopped():
		return
	
	column_top_still_blocks.clear()
	moving_entities.clear()
	
	for child in self.get_children():
		if child.is_in_group("interacting_entities"):
			moving_entities.push_back(child)

	moving_entities.sort_custom(compare_entity_heights)
	
	for i in range(0, board_dimensions.x):
		column_top_still_blocks.push_back(board_dimensions.y)
	
	for entity in moving_entities:
		if entity.get_real_class() == "MovingBlock8x8":
			move_block(delta, entity)
		elif entity.get_real_class() == "Player":
			move_player(delta)
		elif entity.get_real_class() == "StaticBlock8x8":
			column_top_still_blocks[entity.board_cords.x] = entity.board_cords.y


func compare_entity_heights(a, b):
	return a.position.y > b.position.y
	# Sorts the entities in decreasing order according to their height.

func move_block(delta, block):
	if block.is_falling:
		block.y_speed += 1000 * delta
	else:
		block.y_speed = 0
	var delta_height = delta * block.y_speed
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
	if player.is_falling:
		player.y_speed += 1000 * delta
	else:
		player.y_speed = 0
	var size = $Player/StandingHitBox.shape.size
	
	# First I move the player left/right.
	var x_speed = 0
	
	if Input.is_action_pressed("move_left"):
		x_speed -= 200
	if Input.is_action_pressed("move_right"):
		x_speed += 200
	
	# The furthest to the left that the player can go.
	var min_left = left_wall + (size.x / 2)
	var max_right = -left_wall - (size.x / 2)
	var player_left_column = int(player.position.x - (size.x / 2) - left_wall) / 64
	var player_right_column = int(player.position.x + (size.x / 2) - left_wall - 1) / 64
	
	for entity in moving_entities:
		if entity.get_real_class() == "Player":
			continue
		var to_the_left_or_right = entity.board_cords.x != player_left_column and entity.board_cords.x != player_right_column
		
		if abs(entity.position.y - player.position.y) < 64 and to_the_left_or_right:
			if entity.position.x < player.position.x:
				min_left = max(min_left, entity.position.x + 32 + (size.x / 2))
			else:
				max_right = min(max_right, entity.position.x - 32 - (size.x / 2))
	
	var delta_x = delta * x_speed
	
	if player.position.x + delta_x < min_left:
		player.position.x = min_left
	elif player.position.x + delta_x >= max_right:
		player.position.x = max_right
	else:
		player.position.x += delta_x
	
	player_left_column = int(player.position.x - (size.x / 2) - left_wall) / 64
	player_right_column = int(player.position.x + (size.x / 2) - left_wall - 1) / 64
	var max_height_1 = column_top_still_blocks[player_left_column] - 1
	var max_height_2 = column_top_still_blocks[player_right_column] - 1
	var max_height = min(max_height_1, max_height_2)
	var min_pos_y = top_wall + size.y / 2
	var speed_of_ceiling := 0
	var ceiling_y_pos = top_wall
	
	for entity in moving_entities:
		if (entity.get_real_class() == "Player" or
			(entity.board_cords.x != player_left_column and 
			entity.board_cords.x != player_right_column) or 
			entity.position.y > player.position.y):
			continue
		
		if (player.position.y - size.y / 2 + entity.position.y + 32) / 2 + size.y / 2 >= min_pos_y:
			min_pos_y = (player.position.y - size.y / 2 + entity.position.y + entity.y_speed * delta + 32) / 2 + size.y / 2
			speed_of_ceiling = entity.y_speed
	
	var coyote_timer = $Player/CoyoteTimer
	
	if Input.is_action_just_pressed("jump") and (!player.is_falling or coyote_timer.time_left > 0):
		player.y_speed = -400
		coyote_timer.stop()
		#rise_timer.start(rise_timer.wait_time)
	
	#print_debug(rise_timer.time_left)
	var delta_height = delta * player.y_speed
	var new_player_cord_y = int(player.position.y - top_wall + delta_height - 32 - 1) / 64 + 1
	
	if player.position.y + delta_height <= min_pos_y:
		#rise_timer.stop()
		player.y_speed = speed_of_ceiling
	elif player.y_speed < 0:
		player.position.y += delta_height
		player.is_falling = true
		return
	
	if player.position.y == top_wall + max_height * 64 + 32:
		column_top_still_blocks[player_left_column] = max_height
		column_top_still_blocks[player_right_column] = max_height
		player.board_cords.y = max_height
		player.is_falling = false
		coyote_timer.start(coyote_timer.wait_time)
		return
	
	if new_player_cord_y > max_height:
		player.is_falling = false
		#here the height of the block is set so that it lands on something else
		player.board_cords.y = max_height
		coyote_timer.start(coyote_timer.wait_time)
	else:
		player.is_falling = true
		player.position.y += delta_height
	
	if player.position.y == top_wall + max_height * 64 + 32:
		column_top_still_blocks[player_left_column] = max_height
		column_top_still_blocks[player_right_column] = max_height
		player.board_cords.y = max_height
		player.is_falling = false
		coyote_timer.start(coyote_timer.wait_time)
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
		finish_area_position_before_rotation = finish_area.position
		positions_before_rotations.clear()
		
		for entity in moving_entities:
			positions_before_rotations.push_back(entity.position)
	
	if rotation_timer.is_stopped():
		# If there is no rotation now, skip the rest.
		return
	
	var change_angle = PI * now_rotations * (rotation_timer.wait_time - rotation_timer.time_left) / rotation_timer.wait_time / 2
	tilemap.rotation = (total_rotations - now_rotations) * PI / 2 + change_angle
	#print_debug((total_rotations - now_rotations) * PI / 2 + change_angle)
	
	finish_area.position = finish_area_position_before_rotation.rotated(change_angle)
	finish_area.rotation = (finish_area.initial_rotations + total_rotations - now_rotations) * PI / 2 + change_angle
	
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
	tilemap.rotation = total_rotations * PI / 2
	
	if now_rotations % 2:
		board_dimensions = Vector2i(board_dimensions.y, board_dimensions.x)
	else:
		board_dimensions = board_dimensions
	
	finish_area.rotation = (finish_area.initial_rotations + total_rotations) * PI / 2
	#print_debug(finish_area.rotation)
	finish_area.position = finish_area_position_before_rotation.rotated(now_rotations * PI / 2)
	
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
#	board_dimensions = newValue
#	if Engine.is_editor_hint():
#		for i in range(-board_dimensions.x * 4 - 1, board_dimensions.x * 4 + 1):
#			tilemap.set_cell(0, Vector2i(i, board_dimensions.y * 4), -1, Vector2i(0, 0))
#			tilemap.set_cell(0, Vector2i(i, -board_dimensions.y * 4 - 1), -1, Vector2i(0, 0))
#		
#		for i in range(-board_dimensions.y * 4 - 1, board_dimensions.y * 4 + 1):
#			tilemap.set_cell(0, Vector2i(-board_dimensions.x * 4 - 1, i), -1, Vector2i(0, 0))
#			tilemap.set_cell(0, Vector2i(board_dimensions.x * 4, i), -1, Vector2i(0, 0))
#			
#		for i in range(-newValue.x * 4 - 1, newValue.x * 4 + 1):
#			tilemap.set_cell(0, Vector2i(i, newValue.y * 4), 0, Vector2i(0, 0))
#			tilemap.set_cell(0, Vector2i(i, -newValue.y * 4 - 1), 0, Vector2i(0, 0))
#	
#		for i in range(-newValue.y * 4 - 1, newValue.y * 4 + 1):
#			tilemap.set_cell(0, Vector2i(-newValue.x * 4 - 1, i), 0, Vector2i(0, 0))
#			tilemap.set_cell(0, Vector2i(newValue.x * 4, i), 0, Vector2i(0, 0))
#	
	board_dimensions = newValue
	left_wall = -board_dimensions.x * 32
	top_wall = -board_dimensions.y * 32
	#tilemap.set_board_dimensions(board_dimensions)
	#walls = get_node("Walls")
	#walls.position = Vector2(left_wall, top_wall)
	
	for child in get_children():
		#print_debug(child.get_name())
		if child.is_in_group("interacting_entities"):
			#print_debug("check")
			child.board_dimensions = board_dimensions
		elif child.is_in_group("walls"):
			child.position = Vector2(left_wall, top_wall)
		elif child.is_in_group("board limits"):
			child.board_dimensions = board_dimensions
	
	#return board_dimensions

func load_blocks_from_tilemap():
	var wall_tiles = walls.get_used_cells_by_id(0, 0, Vector2i(0,0), -1)
	var moving_block_tiles = walls.get_used_cells_by_id(0, 1, Vector2i(0,0), -1)
	var static_block_tiles = walls.get_used_cells_by_id(0, 2, Vector2i(0,0), -1)
	
	for wall_tile in wall_tiles:
		var new_static_block_8x8 = static_block.instantiate()
		new_static_block_8x8.board_cords = wall_tile
		new_static_block_8x8.board_dimensions = board_dimensions
		new_static_block_8x8.visible = false
		add_child(new_static_block_8x8)

	for wall_tile in moving_block_tiles:
		var new_moving_block_8x8 = moving_block.instantiate()
		new_moving_block_8x8.board_cords = wall_tile
		new_moving_block_8x8.board_dimensions = board_dimensions
		add_child(new_moving_block_8x8)

	for wall_tile in static_block_tiles:
		var new_static_block_8x8 = static_block.instantiate()
		new_static_block_8x8.board_cords = wall_tile
		new_static_block_8x8.board_dimensions = board_dimensions
		add_child(new_static_block_8x8)
	walls.visible = false
