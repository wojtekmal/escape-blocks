@tool
class_name Player
extends CharacterBody2D
signal finished

@export var walk_speed = 60
@export var jump_speed = 300
@export var coyote_time = 0.1
@export var jump_time = 0.1
@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var is_falling : bool : set = set_is_falling

# How fast the player is falling down.
@export var y_speed := 0

#@export var is_rotating : bool : set = set_is_rotating
var offset = 10;
var crawling := false

@onready var _animated_sprite = $AnimatedSprite2D
@onready var StandingHitBox = $StandingHitBox

func _process(delta: float) -> void:
	animations()

func get_direction() -> Vector2:
	if !Engine.is_editor_hint():
		return Vector2(
			Input.get_action_strength("move_right") - 
			Input.get_action_strength("move_left"),
			-Input.get_action_strength("jump") if can_jump() else 0
	)
	return Vector2(0,0)
	
func can_jump() -> bool:
	if Input.is_action_pressed("jump"):
		return true
	else:
		return false

func calculate_move_acceleration(
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var new_velocity := direction * speed
	return new_velocity

func rotate_player(delta, now_rotations, total_rotations, time_left):

	
	#var rotations = 0
	#if(Input.is_action_just_pressed("gravity_right")):
	#	rotations += 1
	#if(Input.is_action_just_pressed("gravity_up")):
	#	rotations += 2
	#if(Input.is_action_just_pressed("gravity_left")):
	#	rotations += 3
	#	
	#if rotation_timer.is_stopped() and rotations != 0:
	#	total_rotations += rotations
	#	now_rotations = rotations
	#	rotation_timer.start(0.5)
		
	#if !rotation_timer.is_stopped():
	rotation = (total_rotations - now_rotations) * PI/ 2 + now_rotations * (0.5 - time_left) * PI

func animations():
	if Engine.is_editor_hint():
		# We won't be loading frames in the editor.
		return
	
	var crawlAnimation := ""
	if crawling:
		crawlAnimation = "crawl "
	elif Input.is_action_pressed("move_right"):
		_animated_sprite.play(crawlAnimation + "walking")
	elif Input.is_action_pressed("move_left"):
		_animated_sprite.play(crawlAnimation + "walking")
	else:
		_animated_sprite.play(crawlAnimation + "default")

func change_sprite_rotation(direction: Vector2):
	if direction.x > 0:
		_animated_sprite.flip_h = false
	if direction.x < 0:
		_animated_sprite.flip_h = true
		
func get_real_class():
	return "Player"
	
func set_board_cords(newValue):
	board_cords = newValue
	set_position(Vector2(position.x, board_cords.y * 64 + 32 - board_dimensions.y * 32))
	
func set_board_dimensions(newValue):
	board_dimensions = newValue
	set_board_cords(board_cords)

func set_is_falling(new_value):
	is_falling = new_value
	
#func _end_of_rotation():
#	rotation = total_rotations * PI / 2

func _on_finish_detection_area_entered(area):
	print("finish!")
	emit_signal("finished")
