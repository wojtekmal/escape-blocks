@tool
class_name LevelTemplate
extends Node2D
@warning_ignore("integer_division")

signal retry_this_level
signal change_to_next_level
signal pause

@export var board_dimensions : Vector2i : set = set_board_dimensions
@export var total_rotations : int = 0
@export var now_rotations : int
@export var level_name : String
@export var rotation_limit_1 : int
@export var rotation_limit_2 : int
@export var time_limit_1 : float
@export var time_limit_2 : float
@export var rotation_disabled : bool = false
@export var end_screen_disabled : bool = false
@export_multiline var walls_source : String

#children
@onready var tilemap := $BoardLimits
@onready var overlay := $Overlay
@onready var player := $Player
@onready var rotation_timer = $RotationTimer
@onready var walls := $Walls
@onready var counter := $Counter
@onready var level_map_button := $EndPanel/MarginContainer/MyPanel/VBoxContainer/ButtonsBox/HBoxContainer/Map
@onready var next_level_button := $EndPanel/MarginContainer/MyPanel/VBoxContainer/ButtonsBox/HBoxContainer/Next
@onready var retry_level_button := $EndPanel/MarginContainer/MyPanel/VBoxContainer/ButtonsBox/HBoxContainer/Retry
@onready var timer := $Timer
@onready var part_box_1 := $EndPanel/MarginContainer/MyPanel/VBoxContainer/PartsBox/HBoxContainer/PartBox1
@onready var part_box_2 := $EndPanel/MarginContainer/MyPanel/VBoxContainer/PartsBox/HBoxContainer/PartBox2
@onready var part_box_3 := $EndPanel/MarginContainer/MyPanel/VBoxContainer/PartsBox/HBoxContainer/PartBox3
@onready var part_box_4 := $EndPanel/MarginContainer/MyPanel/VBoxContainer/PartsBox/HBoxContainer/PartBox4
@onready var part_box_5 := $EndPanel/MarginContainer/MyPanel/VBoxContainer/PartsBox/HBoxContainer/PartBox5
@onready var camera := $Camera2D
@onready var background := $Camera2D/CanvasLayer/CenterContainer/Container/background
@onready var backblock = preload("res://board_stuff/backgroundblock.tscn")

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
var game_started := false : set = set_started
var column_top_entities = []
var y_friction = 0.99;
var start_phone_rotation : int = 0
#var phone_rotation : int = 0 # 0 - bottom down, 1 - right down, 2 - top down, 3 - left down
#var newer_phone_rotation : int = 0

# BLOCKS LIBRARY 👍
var tile_blocks := {
	"moving" : {
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
	"static" : {
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
	"button" : {
		"resource" : preload("res://board_stuff/Button.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 7
	},
	"negative button" : {
		"resource" : preload("res://board_stuff/NegativeButton.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 8
	},
	"door" : { #must be below buttons
		"resource" : preload("res://board_stuff/Door.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 9
	},
	"laser" : { #must be below buttons
		"resource" : preload("res://board_stuff/laser.tscn"),
		"adress" : Vector2i(0, 0),
		"layer" : 0,
		"id" : 5
	},
}

# Letters to blocks.
var letters_to_blocks := {
	"#" : {
		"name" : "static",
		"rotation" : 0,
	},
	"B" : {
		"name" : "moving",
		"rotation" : 0,
	},
	"P" : {
		"name" : "button",
		"rotation" : 1,
	},
	"D" : {
		"name" : "door",
		"rotation" : 1,
	},
	"G" : {
		"name" : "player",
		"rotation" : 0,
	},
	"M" : {
		"name" : "finish",
		"rotation" : 0,
	},
	"W" : {
		"name" : "finish",
		"rotation" : 2,
	},
	"3" : {
		"name" : "finish",
		"rotation" : 1,
	},
	"E" : {
		"name" : "finish",
		"rotation" : 3,
	},
}

var door_blocks := {}

func _ready():
	add_to_group("level")
	rotation_timer.timeout.connect(rotation_ended)
	
	#calls the setter function
	board_dimensions = board_dimensions
	tilemap.board_dimensions = board_dimensions
	#overlay.board_dimensions = board_dimensions
	size = $Player/StandingHitBox.shape.size
	game_ended = false
	global.reset_phone_rotation()
	
	if Engine.is_editor_hint(): return
	
	if walls_source != "":
		load_blocks_from_walls_source()
	
	load_blocks_from_tilemap()
	
	$PhoneHUD/Control/Menu.pressed.connect(emit_pause)
	
	if OS.get_name() != "Android":
		$PhoneHUD.visible = false
	
	start_phone_rotation = global.phone_rotation
	$Camera2D.rotation = PI / 2 * start_phone_rotation

func _physics_process(delta):
	# We won't be loading frames in the editor.
	if Engine.is_editor_hint() || game_ended: return
	
	if Input.is_action_just_pressed("quick_finish"):
		_on_player_finished(-total_rotations)
	
	manage_changing_gravity()
	manage_falling_entities(delta)
	manage_doors()
	
	first_frame = false
	frame_count += 1
	
	if randf_range(0, 213.7) <= delta:
		add_child(backblock.instantiate())

func _process(delta):
	if Engine.is_editor_hint(): return
	move_camera()
	
	if game_ended:
		if Input.is_action_just_pressed("next_level"):
			actually_go_to_next_level()
		if Input.is_action_just_pressed("map"):
			go_to_map()
		if get_viewport().gui_get_focus_owner() == null || \
		!get_viewport().gui_get_focus_owner().is_visible_in_tree():
			next_level_button.grab_focus()

func manage_falling_entities(delta):
	if !rotation_timer.is_stopped():
		return
	
	column_top_still_blocks.clear()
	column_top_entities.clear()
	moving_entities = get_tree().get_nodes_in_group("interacting_entities")
	moving_entities.sort_custom(compare_entity_heights)
	
	for i in range(0, board_dimensions.x):
		column_top_still_blocks.push_back(board_dimensions.y)
		# Counter is a placeholder for now.
		column_top_entities.push_back(counter)
	
	for entity in moving_entities:
		if entity.is_in_group("moving_blocks"):
			move_block(delta, entity)
		elif entity.is_in_group("player"):
			move_player(delta)
		elif entity.is_in_group("static_blocks"):
			manage_static_block(delta, entity)
		elif entity.is_in_group("doors") && !entity.open:
			manage_static_block(delta, entity)
#			column_top_still_blocks[entity.board_cords.x] = entity.board_cords.y
#			var entity_below = column_top_entities[entity.board_cords.x]
#			entity.y_speed = 0
#
#			if (entity_below != counter && (entity.y_speed - entity_below.y_speed) * delta >=
#				entity_below.position.y - entity.position.y - 32 - get_y_size(entity_below) / 2):
#				entity_below.y_speed = entity.y_speed
#			column_top_entities[entity.board_cords.x] = entity

func compare_entity_heights(a, b): # Sorts the entities in decreasing order according to their height.
	return a.position.y > b.position.y

func manage_static_block(delta, block):
	column_top_still_blocks[block.board_cords.x] = block.board_cords.y
	var entity_below = column_top_entities[block.board_cords.x]
	block.y_speed = 0
	
	if (entity_below != counter && (block.y_speed - entity_below.y_speed) * delta >=
		entity_below.position.y - block.position.y - 32 - entity_below.y_size / 2):
		entity_below.y_speed = block.y_speed
	
	if (entity_below != counter && entity_below.position.y - block.position.y < 
	32 + entity_below.y_size / 2):
		entity_below.position.y = block.position.y + 32 + entity_below.y_size / 2
	
	column_top_entities[block.board_cords.x] = block
	
	#for i in range(1,2001):
	#	pass

func move_block(delta, block):
	block.y_speed *= y_friction
	if block.is_falling:
		block.y_speed += 1000 * delta
	else:
		block.y_speed = 0
	
	var delta_height = delta * block.y_speed
	var new_block_cord_y = floori(block.position.y - top_wall + delta_height - 32 - 1) / 64 + 1
	# Ceiling division.
	var max_height = column_top_still_blocks[block.board_cords.x] - 1
	
	var entity_below = column_top_entities[block.board_cords.x]
	
	if (entity_below != counter && (block.y_speed - entity_below.y_speed) * delta >
	entity_below.position.y - block.position.y - 32 - get_y_size(entity_below) / 2):
		entity_below.y_speed = block.y_speed
	
	if (entity_below != counter && entity_below.position.y - block.position.y < 
	32 + get_y_size(entity_below) / 2):
		entity_below.position.y = block.position.y + 32 + get_y_size(entity_below) / 2
	
	column_top_entities[block.board_cords.x] = block
	column_top_still_blocks[block.board_cords.x] = max_height
	
	if block.position.y == top_wall + max_height * 64 + 32:
		block.board_cords.y = max_height
		block.is_falling = false
		return
	
	if new_block_cord_y > max_height:
		if block.is_falling:
			block.falling_sound(block.y_speed)
		
		block.is_falling = false
		# Here the height of the block is set so that it lands on something else.
		block.board_cords.y = max_height
	else:
		block.is_falling = true
		block.position.y += delta_height
	
#	if block.position.y == top_wall + max_height * 64 + 32:
#		#column_top_still_blocks[block.board_cords.x] = max_height
#	WAaaaaaaaaaaaWWWAaaaaaaaaaaaWWWAaaaaaaa	block.board_cords.y = max_height
#		blaaaaaaaaaaWWaock.is_falling = false
#		return

func move_player(delta):
	player.y_speed *= y_friction
	if player.is_falling:
		player.y_speed += 1000 * delta
	else:
		player.y_speed = 0
	
	# First I move the player left/right.
	
	if Input.is_action_pressed("move_left"):
		player.x_speed -= player.WALK_SPEED
		game_started = true
	if Input.is_action_pressed("move_right"):
		game_started = true
		player.x_speed += player.WALK_SPEED
	
	player.x_speed *= player.friction
	
	# The furthest to the left that the player can go.
	var min_left = left_wall + (size.x / 2)
	var max_right = -left_wall - (size.x / 2)
	var player_left_column = floori(player.position.x - (size.x / 2) - left_wall) / 64
	var player_right_column = my_floor(player.position.x + (size.x / 2) - left_wall) / 64
	
	moving_entities = get_tree().get_nodes_in_group("interacting_entities")
	for entity in moving_entities:
		if entity.is_in_group("player"):
			continue
		if entity.is_in_group("doors") && entity.open:
			continue
		
		var to_the_left_or_right = entity.board_cords.x != player_left_column and entity.board_cords.x != player_right_column
		
		if abs(entity.position.y - player.position.y) < 32 + size.y / 2 and to_the_left_or_right:
			if entity.position.x < player.position.x:
				min_left = max(min_left, entity.position.x + 32 + (size.x / 2))
			else:
				max_right = min(max_right, entity.position.x - 32 - (size.x / 2))
	
	var wasd := get_tree().get_nodes_in_group("wasd")
	var delta_x = delta * player.x_speed
	
	if player.position.x + delta_x < min_left:
		player.position.x = min_left
	elif player.position.x + delta_x >= max_right:
		player.position.x = max_right
	else:
		player.position.x += delta_x
	
	player_left_column = floori(player.position.x - (size.x / 2) - left_wall) / 64
	player_right_column = my_floor(player.position.x + (size.x / 2) - left_wall) / 64
	var max_height_1 = column_top_still_blocks[player_left_column] - 1
	var max_height_2 = column_top_still_blocks[player_right_column] - 1
	var max_height = min(max_height_1, max_height_2)
	#print("max_height, new_player_cord_y:")
	#print(max_height)
	
	var coyote_timer = $Player/CoyoteTimer
	
	if Input.is_action_pressed("jump") and player.getjumptime() > 0:
		if player.flying:
			player.y_speed = lerp(player.y_speed, -431, delta * 10)
		else:
			player.y_speed -= (player.jump_speed) * delta
		coyote_timer.stop()
	elif Input.is_action_pressed("jump") and (!player.is_falling or coyote_timer.time_left > 0 or player.flying):
		if(player.y_speed > 0):
			player.y_speed = 0
		game_started = true
		if player.flying:
			player.y_speed = lerp(player.y_speed, -431, delta * 10)
		else:
			player.y_speed -= (player.jump_speed) * delta
		player.setjumptime()
	
	
	
	var delta_height = delta * player.y_speed
	var new_player_cord_y = floor_div(player.position.y - top_wall + delta_height - 32 - 1, 64) + 1
	#print(new_player_cord_y)
	#print((-1) / 64)
	
	var entity_below_left = column_top_entities[player_left_column]
	var entity_below_right = column_top_entities[player_right_column]
	
	if (entity_below_left != counter && (player.y_speed - entity_below_left.y_speed) * delta >
		entity_below_left.position.y - player.position.y - size.y / 2 - get_y_size(entity_below_left) / 2):
		entity_below_left.y_speed = player.y_speed
	
	if (entity_below_right != counter && (player.y_speed - entity_below_right.y_speed) * delta >
		entity_below_right.position.y - player.position.y - size.y / 2 - get_y_size(entity_below_right) / 2):
		#print("right_detected")
		entity_below_right.y_speed = player.y_speed
	
	column_top_entities[player_left_column] = player
	column_top_entities[player_right_column] = player
	column_top_still_blocks[player_left_column] = max_height
	column_top_still_blocks[player_right_column] = max_height
	
	if player.y_speed < 0:
		if player.position.y + delta_height < top_wall + size.y / 2:
			player.position.y = top_wall + size.y / 2
			player.y_speed = 0
			player.is_falling = true
			return
		
		player.position.y += delta_height
		player.is_falling = true
		return
	
	if player.position.y == top_wall + max_height * 64 + 32:
		player.board_cords.y = max_height
		player.is_falling = false
		coyote_timer.start(coyote_timer.wait_time)
		return
	
	if new_player_cord_y > max_height:
		if player.is_falling:
			player.falling_sound()
		
		player.is_falling = false
		# Here the height of the block is set so that it lands on something else.
		player.board_cords.y = max_height
		coyote_timer.start(coyote_timer.wait_time)
	else:
		player.is_falling = true
		player.position.y += delta_height
	
#	if player.position.y == top_wall + max_height * 64 + 32:
#		player.board_cords.y = max_height
#		player.is_falling = false
#		coyote_timer.start(coyote_timer.wait_time)
#		return

func manage_changing_gravity():
	# We won't be loading frames in the editor.
	if Engine.is_editor_hint() || rotation_disabled:
		return
	
	var rotations : int = 0
	
	if OS.get_name() == "Android":# || true:
		if rotation_timer.is_stopped() && all_not_falling():
			rotations += ((global.phone_rotation - total_rotations - start_phone_rotation) % 4 + 5) % 4 - 1
			#global.control_manage_phone_rotation($EndPanel/MarginContainer)
			#global.control_manage_phone_rotation($PhoneHUD/VirtualJoystick)
			#global.control_manage_phone_rotation($PhoneHUD/Control)
			
			#if has_node("TutorialFloat"):
			#	$TutorialFloat.manage_phone_rotation()
	
	if(Input.is_action_pressed("gravity_right") && !global.settings["switch_rotation"] ||
	Input.is_action_pressed("gravity_left") && global.settings["switch_rotation"]):
		game_started = true
		rotations += 1
		#("Adding one 90 degrees rotation.")
	elif(Input.is_action_pressed("gravity_up")):
		game_started = true
		rotations += 2
	elif(Input.is_action_pressed("gravity_left") && !global.settings["switch_rotation"] ||
	Input.is_action_pressed("gravity_right") && global.settings["switch_rotation"]):
		game_started = true
		rotations -= 1
	
	var wasd := get_tree().get_nodes_in_group("wasd")
		
	if all_not_falling() and rotation_timer.is_stopped() and rotations != 0:
		$RotationSound.play()
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
	tilemap.rotation = change_angle
	overlay.rotation = (total_rotations - now_rotations) % 4 * PI / 2 + change_angle
	background.rotation = (total_rotations - now_rotations) % 4 * PI / 2 + change_angle
	
	if OS.get_name() == "Android":# || true:
		camera.rotation = (total_rotations - now_rotations + start_phone_rotation) % 4 * PI / 2 + change_angle
	
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
	moving_entities = get_tree().get_nodes_in_group("interacting_entities")
	for entity in moving_entities:
		if entity.is_falling:
			return false
		
	return true

func rotation_ended():
	tilemap.rotation = 0
	overlay.rotation = total_rotations * PI / 2
	background.rotation = total_rotations * PI / 2
	if OS.get_name() == "Android":# || true:
		camera.rotation = total_rotations * PI / 2
	
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
		
		entity.y_speed = 0
	
	for entity in moving_entities:
		if "is_falling" in entity:
			entity.is_falling = true
	
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
	var player_left_column = floori(player.position.x - (size.x / 2) - left_wall) / 64
	var player_right_column = floori(player.position.x + (size.x / 2) - left_wall - 1) / 64
	
	for entity in moving_entities:
		if (entity.is_in_group("player") ||
			entity.is_in_group("doors") && entity.open):
			continue
		var to_the_left_or_right = abs(entity.position.x - player.position.x) < 32 + size.x / 2
		
		if abs(entity.position.y - player.position.y) < 32 + size.y / 2 and to_the_left_or_right:
			if entity.position.x < player.position.x:
				min_left = max(min_left, entity.position.x + 32 + (size.x / 2))
			else:
				max_right = min(max_right, entity.position.x - 32 - (size.x / 2))
	
	player.position.x = min(player.position.x, max_right)
	player.position.x = max(player.position.x, min_left)
	player.x_speed = 0
	
func set_board_dimensions(newValue):
	board_dimensions = newValue
	left_wall = -board_dimensions.x * 32
	top_wall = -board_dimensions.y * 32
	
	for child in get_children():
		if child.is_in_group("interacting_entities"):
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
	if (total_rotations + start_rotations) % 4 == 0 && !game_ended && !rotation_timer.time_left:
		game_ended = true
		timer.stop()
		#get_tree().paused = true
		print("End game.\nTotal rotations: " + str(rotations_number))
		$EndPanel/MarginContainer/MyPanel/VBoxContainer/FinishLabelBox/FinishLabel.text = "LEVEL COMPLETE\nTotal rotations: " + str(rotations_number)
		
		if !end_screen_disabled:
			$EndPanel.visible = true
		
		if end_screen_disabled:
			emit_signal("change_to_next_level", level_name)
			return
		
		if !global.levels.has(level_name):
			print("This level\'s name is\'nt in global.levels.")
			return
		
		$PhoneHUD/VirtualJoystick.visible = false
		
		#var time_parts = 0
		var rotation_parts = 0
		
		if rotations_number <= rotation_limit_2:
			rotation_parts = 2
		elif rotations_number <= rotation_limit_1:
			rotation_parts = 1
		
#		if timer._time <= time_limit_1:
#			time_parts = 2
#		elif timer._time <= time_limit_2:
#			time_parts = 1
		
		part_box_1.label_text = "FINISHED"
#		part_box_2.label_text = str(time_limit_1) + "s"
#		part_box_3.label_text = str(time_limit_2) + "s"
		part_box_4.label_text = str(rotation_limit_1) + "\nROTATIONS"
		part_box_5.label_text = str(rotation_limit_2) + "\nROTATIONS"
		
		if global.levels[level_name]["finished_parts"] >= 1:
			part_box_1.part_visible = true
#		if global.levels[level_name]["time_parts"] >= 1:
#			part_box_2.part_visible = true
#		if global.levels[level_name]["time_parts"] >= 2:
#			part_box_3.part_visible = true
		if global.levels[level_name]["rotation_parts"] >= 1:
			part_box_4.part_visible = true
		if global.levels[level_name]["rotation_parts"] >= 2:
			part_box_5.part_visible = true
		
		if !part_box_1.part_visible:
			part_box_1.part_new = true
			part_box_1.part_visible = true
			global.part_count += 1
#		if !part_box_2.part_visible && time_parts >= 1:
#			part_box_2.part_new = true
#			part_box_2.part_visible = true
#			global.part_count += 1
#		if !part_box_3.part_visible && time_parts >= 2:
#			part_box_3.part_new = true
#			part_box_3.part_visible = true
#			global.part_count += 1
		if !part_box_4.part_visible && rotation_parts >= 1:
			part_box_4.part_new = true
			part_box_4.part_visible = true
			global.part_count += 1
		if !part_box_5.part_visible && rotation_parts >= 2:
			part_box_5.part_new = true
			part_box_5.part_visible = true
			global.part_count += 1
		
		global.levels[level_name]["finished_parts"] = 1
#		global.levels[level_name]["time_parts"] = max(global.levels[level_name]["time_parts"], time_parts)
		global.levels[level_name]["rotation_parts"] = max(global.levels[level_name]["rotation_parts"], rotation_parts)
		
		#print(level_name + "aaa")
		#print(preload("res://levels/wojtekmal_1.tscn"))
		#print(global.levels_data.size())
		
		for unlocked_level in global.levels_data[level_name]["unlocks"]:
			print("level unlocked: " + unlocked_level)
			#print(global.levels)
			global.levels[unlocked_level]["unlocked"] = max(1, global.levels[unlocked_level]["unlocked"])
			
			if global.levels_data[unlocked_level]["part_price"] == 0:
				global.levels[unlocked_level]["unlocked"] = 2
		
		global.save()
		
		level_map_button.pressed.connect(go_to_map)
		retry_level_button.pressed.connect(retry_level)
		next_level_button.pressed.connect(actually_go_to_next_level)
		#next_level_button_text.add_font_override("normal_font", load("res://fonts/conthrax/conthrax-sb.otf"))
		
		var next_level_name := "NULL"
		
		if global.levels_data[level_name]["unlocks"].size():
			next_level_name = global.levels_data[level_name]["unlocks"][0]
		
		#next_level_button_text.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
		#next_level_button_text.push_font(load("res://fonts/conthrax/conthrax-sb.otf"), 36)
		#next_level_button_text.push_color(Color(0,0,0,1))
		
#		if next_level_name == "NULL":
#			next_level_button.label_text = "Next (Enter)"
#			next_level_button.disabled = true
#			next_level_button.modulate = Color8(255,255,255,100)
#		elif global.levels_data[next_level_name]["part_price"] == 0:
#			next_level_button.label_text = "Next (Enter)"
#			next_level_button.grab_focus()
#		else:
#			next_level_button.label_text = "NEXT (" + str(global.levels_data[next_level_name]["part_price"]) + "[img=36x36]res://textures/temporary_part.png[/img])"
#			#next_level_button_text.pop()

func manage_doors():
	if !rotation_timer.is_stopped():
		return
	
	for door in moving_entities:
		if !door.is_in_group("doors"):
			continue
		
		door.can_close = true
		
		for entity in moving_entities:
			if entity.is_in_group("doors"):
				continue
			
			var entity_size = Vector2(64, 64)
			
			if entity.is_in_group("player"):
				entity_size = $Player/StandingHitBox.shape.size
			
			if (abs(door.position.x - entity.position.x) < 32 + entity_size.x / 2 &&
				abs(door.position.y - entity.position.y) < 32 + entity_size.y / 2):
					door.can_close = false
					break

func my_floor(value) -> int:
	if floori(value) == value:
		return floori(value - 1)	
	return floor(value)

func set_started(value : bool):
	if game_started == false && value == true:
		timer.stop(false)
	game_started = value
	return floori(value)

func get_y_size(entity):
	if entity.is_in_group("player"):
		return size.y
	else:
		return 64

func go_to_map():
	get_tree().change_scene_to_file("res://map_stuff/level_map.tscn")

func retry_level():
	emit_signal("retry_this_level")

func go_to_next_level():
	next_level_button.release_focus()
	next_level_button.modulate = Color(1,1,1)
#	print("going to next level")
	var next_level_name := "NULL"
	if global.levels_data[level_name]["unlocks"].size():
		next_level_name = global.levels_data[level_name]["unlocks"][0]
	
	if global.levels_data[next_level_name]["part_price"] > global.part_count:
		print("Not enough parts.")
		return
	
	var confirmation_popup = load("res://menu_stuff/confirmation_popup.tscn").instantiate()
	confirmation_popup.label_text = "Open level " + next_level_name +\
	"\nfor " + str(global.levels_data[next_level_name]["part_price"]) + " parts?"
	confirmation_popup.ok_pressed.connect(actually_go_to_next_level)
	confirmation_popup.cancel_pressed.connect(cancel_go_to_next_level)
	get_tree().get_root().add_child(confirmation_popup)

func actually_go_to_next_level():
	var next_level_name := "NULL"
	if global.levels_data[level_name]["unlocks"].size():
		next_level_name = global.levels_data[level_name]["unlocks"][0]
	
	global.levels[next_level_name]["unlocked"] = 2
	global.part_count -= global.levels_data[next_level_name]["part_price"]
	global.save()
	emit_signal("change_to_next_level", level_name)

func cancel_go_to_next_level():
	$EndPanel/MarginContainer/MyPanel/VBoxContainer/ButtonsBox/HBoxContainer/Next.grab_focus()

func floor_div(a, b):
	if a >= 0 || a == floori(a) && floori(a) % floori(b) == 0:
		return floori(a) / floori(b)
	else:
		return floori(a) / floori(b) - 1

func move_camera():
	#print(camera.position)
	#print(background.position)
	global_position = Vector2.ZERO
	camera.position = lerp(player.position, $Center.position, 0.7)
	while (camera.position - player.position).length() * camera.zoom.x > 200:
		camera.position = lerp(camera.position, player.position, 0.01)

func load_blocks_from_walls_source():
	var copy = walls_source
	var x_size = copy.left(copy.findn(" "))
	copy = copy.right(copy.length() - x_size.length() - 1)
	x_size = x_size.to_int()
	var y_size = copy.left(copy.findn("\n"))
	copy = copy.right(copy.length() - y_size.length() - 1)
	y_size = y_size.to_int()
	copy = copy + "\n"
	
	walls.clear()
	set_board_dimensions(Vector2i(x_size, y_size))
	
	for row in y_size:
		for i in x_size:
			var char_num = i + row * (x_size + 1)
			var letter = copy[char_num]
			
			if letter == '.':
				continue

			var block_type = letters_to_blocks[letter]["name"]
			var rotation = letters_to_blocks[letter]["rotation"]
			walls.set_cell(tile_blocks[block_type]["layer"], Vector2i(i, row), tile_blocks[block_type]["id"], tile_blocks[block_type]["adress"], rotation)

func _exit_tree():
	if randi() % 420 == 0:
		get_window().title = "Enter Blocks"
	else:
		get_window().title = "Escape Blocks"

func emit_pause():
	emit_signal("pause")