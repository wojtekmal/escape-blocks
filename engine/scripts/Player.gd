class_name Player
extends Area2D

#@export var walk_speed = 60
var jump_speed = 5500
@export var coyote_time = 90.1
@export var jump_time = 0.3
@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var is_falling : bool = true : set = set_is_falling
@export var start_rotations : int = 0
var flying := false

# Player speed
@export var y_speed := 0
@export var x_speed := 0

var WALK_SPEED := 150.0
var friction := 0.65

var offset = 10;

@onready var _animated_sprite = $AnimatedSprite2D
@onready var StandingHitBox = $StandingHitBox

var inputs := [["w", "d"], ["w"], ["d"]]
var tick := 0

func getjumptime():
	return $jumping.time_left

func setjumptime(x := 0.0):
	$jumping.start()

func _process(delta: float) -> void:
	animations()
	walking_sound()

func _physics_process(delta):
	tick += 1
	if Engine.is_editor_hint():
		return
	if Input.is_action_just_pressed("fly"):
		flying = not flying
		if flying:
			WALK_SPEED *= 1.0 + PI/10
		else:
			WALK_SPEED /= 1.0 + PI/10

func can_jump() -> bool:
	return Input.is_action_pressed("jump")

func calculate_move_acceleration(
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var new_velocity := direction * speed
	return new_velocity

func rotate_player(delta, now_rotations, total_rotations, time_left):
	rotation = (total_rotations - now_rotations) * PI/ 2 + now_rotations * (0.5 - time_left) * PI

func animations():
	if Engine.is_editor_hint():
		# We won't be loading frames in the editor.
		return
	
	elif Input.is_action_pressed("move_right") or get_parent().sinput('r'):
		_animated_sprite.play("walking")
		_animated_sprite.flip_h = false
	elif Input.is_action_pressed("move_left") or get_parent().sinput('l'):
		_animated_sprite.flip_h = true	
		_animated_sprite.play("walking")
	else:
		_animated_sprite.play("default")

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

func falling_sound():
	$Landing.play()

func walking_sound():
	if !is_falling && !$Walking.playing && abs(x_speed) >= 0.01:
		$Walking.play()
	elif $Walking.playing && (is_falling || abs(x_speed) < 0.01):
		$Walking.stop()
