@tool
class_name LevelTemplate
extends Node2D

@export var board_dimensions : Vector2i : set = set_board_dimensions
@export var total_rotations : int = 0
@export var now_rotations : int
#children
@onready var tilemap := $BoardLimits
@onready var overlay := $Overlay
@onready var player := $Player
@onready var rotation_timer = $RotationTimer
@onready var walls := $Walls
@onready var counter := $Counter

var rotations_number : int : set = update_counter
var moving_entities = []
var column_top_still_blocks = []
var fall_speed = 100
var first_frame = true
var frame_count = 0
var left_wall = -board_dimensions.x * 32
var top_wall = -board_dimensions.y * 32
var positions_before_rotations = []
var size : Vector2
var positions_before_rotations_wasd = []
var game_ended := false

# BLOCKS LIBRARY 👍
var tile_blocks := {
	"static" : {
		"resource" : preload("res://board_stuff/MovingBlock8x8.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 1,
	},
	"finish" : {
		"resource" : preload("res://board_stuff/Finish8x8.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 4,
	},
	"moving" : {
		"resource" : preload("res://board_stuff/StaticBlock8x8.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 2,
	},
	"barrier" : {
		"resource" : preload("res://board_stuff/Barrier8x8.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 0,
	},
	"player" : {
		"resource" : preload("res://board_stuff/Player.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 6
	},
}

func _ready():
	rotation_timer.timeout.connect(rotation_ended)
	#calls the setter function
	board_dimensions = board_dimensions
	tilemap.board_dimensions = board_dimensions
	overlay.board_dimensions = board_dimensions
	size = $Player/StandingHitBox.shape.size
	game_ended = false

	if Engine.is_editor_hint(): return
	
	load_blocks_from_tilemap()

func _process(delta):
	# We won't be loading frames in the editor.
	if Engine.is_editor_hint(): return 
		
	manage_changing_gravity()
	manage_falling_entities(delta)
		
	first_frame = false
	frame_count += 1

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

func compare_entity_heights(a, b): # Sorts the entities in decreasing order according to their height.
	return a.position.y > b.position.y

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
		
		if abs(entity.position.y - player.position.y) < 32 + size.y / 2 and to_the_left_or_right:
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
	
	var delta_height = delta * player.y_speed
	var new_player_cord_y = int(player.position.y - top_wall + delta_height - 32 - 1) / 64 + 1
	
	if player.position.y + delta_height <= min_pos_y:
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
		# Here the height of the block is set so that it lands on something else.
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
	# We won't be loading frames in the editor.
	if Engine.is_editor_hint(): return
	
	var rotations = 0
	if(Input.is_action_just_pressed("gravity_right")):
		rotations += 1
	if(Input.is_action_just_pressed("gravity_up")):
		rotations += 2
	if(Input.is_action_just_pressed("gravity_left")):
		rotations += 3
	
	var wasd := get_tree().get_nodes_in_group("wasd")
		
	if all_not_falling() and rotation_timer.is_stopped() and rotations != 0:
		rotations_number += 1
		counter.update(rotations_number)
		now_rotations = rotations
		total_rotations += now_rotations
		rotation_timer.start(rotation_timer.wait_time)
		positions_before_rotations.clear()
		
		for entity in moving_entities:
			positions_before_rotations.push_back(entity.position)
		
		positions_before_rotations_wasd.clear()
		for w in wasd:
			positions_before_rotations_wasd.push_back(w.position)
	
	if rotation_timer.is_stopped():
		# If there is no rotation now, skip the rest.
		return
	
	var change_angle = PI * now_rotations * (rotation_timer.wait_time - rotation_timer.time_left) / rotation_timer.wait_time / 2
	tilemap.rotation = (total_rotations - now_rotations) % 4 * PI / 2 + change_angle
	overlay.rotation = (total_rotations - now_rotations) % 4 * PI / 2 + change_angle
	
	for i in range(0, moving_entities.size()):
		var entity = moving_entities[i]
		var position_before_rotation = positions_before_rotations[i]
		entity.position = position_before_rotation.rotated(change_angle)
		if !entity.is_in_group("player"):
			entity.rotation = (entity.start_rotations + total_rotations - now_rotations) % 4 * PI / 2 + change_angle
	
	for i in range(0, wasd.size()):
		var w = wasd[i]
		var position_before_rotation_w = positions_before_rotations_wasd[i]
		w.position = position_before_rotation_w.rotated(change_angle)
		w.rotation = (total_rotations - now_rotations) % 4 * PI / 2 + change_angle

func update_counter(x):
	rotations_number = x
	counter.update(rotations_number)

func all_not_falling():
	for entity in moving_entities:
		if entity.is_falling:
			return false
		
	return true

func rotation_ended():
	tilemap.rotation = total_rotations * PI / 2
	overlay.rotation = total_rotations * PI / 2
	var wasd := get_tree().get_nodes_in_group("wasd")
	
	if now_rotations % 2:
		board_dimensions = Vector2i(board_dimensions.y, board_dimensions.x)
	else:
		board_dimensions = board_dimensions
	
	for i in range(0, moving_entities.size()):
		var entity = moving_entities[i]
		if entity.is_in_group("player"):
			entity.rotation = 0
		else:
			entity.rotation = (entity.start_rotations + total_rotations) * PI / 2
		var position_before_rotation = positions_before_rotations[i]
		entity.position = Vector2(position_before_rotation.x, position_before_rotation.y).rotated(now_rotations * PI / 2)
		
		entity.board_cords = Vector2i(
			round((entity.position.x - left_wall - 32) / 64),
			round((entity.position.y - top_wall - 32) / 64)
		)
	
	for i in range(0, wasd.size()):
		var w = wasd[i]
		w.rotation = PI / 2 * (total_rotations % 4)
		var position_before_rotation_w = positions_before_rotations_wasd[i]
		w.position = Vector2(position_before_rotation_w.x, position_before_rotation_w.y).rotated(now_rotations * PI / 2)
		w.board_cords = Vector2i(
			round((w.position.x - left_wall - 32) / 64),
			round((w.position.y - top_wall - 32) / 64)
		)
	
	var min_left = left_wall + (size.x / 2)
	var max_right = -left_wall - (size.x / 2)
	var player_left_column = int(player.position.x - (size.x / 2) - left_wall) / 64
	var player_right_column = int(player.position.x + (size.x / 2) - left_wall - 1) / 64
	
	for entity in moving_entities:
		if entity.get_real_class() == "Player":
			continue
		var to_the_left_or_right = abs(entity.position.x - player.position.x) < 32 + size.x / 2
		
		if abs(entity.position.y - player.position.y) < 32 + size.y / 2 and to_the_left_or_right:
			if entity.position.x < player.position.x:
				min_left = max(min_left, entity.position.x + 32 + (size.x / 2))
			else:
				max_right = min(max_right, entity.position.x - 32 - (size.x / 2))
	
	player.position.x = min(player.position.x, max_right)
	player.position.x = max(player.position.x, min_left)
	
func set_board_dimensions(newValue):
	board_dimensions = newValue
	left_wall = -board_dimensions.x * 32
	top_wall = -board_dimensions.y * 32
	
	for child in get_children():
		#print_debug(child.get_name())
		if child.is_in_group("interacting_entities"):
			#print_debug("check")
			child.board_dimensions = board_dimensions
		elif child.is_in_group("wasd"):
			child.board_dimensions = board_dimensions
		elif child.is_in_group("walls"):
			child.position = Vector2(left_wall, top_wall)
		elif child.is_in_group("board_limits"):
			child.board_dimensions = board_dimensions

func load_blocks_from_tilemap():
	var block_type = tile_blocks["player"]
	var block_resource = block_type["resource"]
	var wall_tiles = walls.get_used_cells_by_id(
		block_type["layer"],
		block_type["id"],
		block_type["adress"],
		-1,
	)
	
	if wall_tiles.size() != 1:
		assert(false, "There has to be one player in the tilemap. There is: " + str(wall_tiles.size()) + " Players")
	
	for block_key in tile_blocks:
		for start_rotations in range(0, 4):
			block_type = tile_blocks[block_key]
			block_resource = block_type["resource"]
			wall_tiles = walls.get_used_cells_by_id(
				block_type["layer"],
				block_type["id"],
				block_type["adress"],
				start_rotations,
			)
			
			if block_key == "player" && wall_tiles.size() > 0:
				player.board_cords.y = wall_tiles[0].y
				player.position.x = left_wall + wall_tiles[0].x * 64 + 32
				player.visible = true
				continue
			
			for wall_tile in wall_tiles:
				var new_block = block_resource.instantiate()
				new_block.board_cords = wall_tile
				new_block.board_dimensions = board_dimensions
				new_block.start_rotations = start_rotations
				
				if block_key == "finish":
					new_block.player_reached_finish_area.connect(_on_player_finished)
				
				add_child(new_block)
	
	walls.visible = false

func _on_player_finished(start_rotations):
	#print("finished signal recived")
	if (total_rotations + start_rotations) % 4 == 0 && !game_ended:
		game_ended = true
		print("End game. Total rotations: " + str(rotations_number))
	if $CanvasLayer/RichTextLabel != null:
		$CanvasLayer/RichTextLabel.text = "End game. Total rotations: " + str(rotations_number)
		$CanvasLayer/RichTextLabel.visible = true
