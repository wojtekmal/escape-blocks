extends KinematicBody2D
class_name entity

export var air_friction := 0.93
export var floor_friction := 0.75
export var gravity := Vector2(0.0, 50.0)
export var keep_speed_after_rotation = false

var screen_size : Vector2
var center_of_screen : Vector2

var falling_time := 0.0 
var on_floor := 0.0
var friction := Vector2(floor_friction, air_friction)

const FLOOR_NORMAL := Vector2.UP
var _velocity := Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	center_of_screen = screen_size / 2
	hide()
	show()

func default_phisics(delta: float, acceleration: Vector2 = Vector2(0, 0)) -> void:
	calculate_when_character_was_on_floor()
	if on_floor == 0 or acceleration.x != 0:
		friction.x = floor_friction
	else:
		friction.x = air_friction
	acceleration += gravity
	_velocity += acceleration
	#move_and_collide(_velocity * delta)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL, true, 4, 0.785398, false)
	_velocity *= friction
	#if is_on_floor() a
	
func calculate_when_character_was_on_floor():
	if is_on_floor():
		on_floor = 0
		falling_time = 0.0
	else:
		on_floor += get_physics_process_delta_time()


func rotate_90_degrees_CCW(vec : Vector2) -> Vector2:
	vec = Vector2(vec.y, -vec.x)
	return vec

func change_gravity(rotations: int, keep_speed: bool):
	for i in range(rotations):
		if keep_speed == false:
			_velocity = Vector2.ZERO
		else:
			_velocity = _velocity.rotated(90 * PI / 180)
		position -= center_of_screen
		position = rotate_90_degrees_CCW(position)
		position += center_of_screen
		rotation_degrees -= 90
