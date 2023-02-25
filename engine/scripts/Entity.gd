extends KinematicBody2D
class_name entity

export var air_friction := 0.93
export var floor_friction := 0.75
export var gravity := Vector2(0.0, 50.0)
export var keep_speed_after_rotation = false
export var rotation_speed := 1.0
var rotated := 0.0

var falling_time := 0.0 
var on_floor := 0.0
var friction := Vector2(floor_friction, air_friction)

const FLOOR_NORMAL := Vector2.UP
var _velocity := Vector2.ZERO

func _ready():
	pass

func default_phisics(delta: float, acceleration: Vector2 = Vector2(0, 0)) -> void:
	calculate_when_character_was_on_floor()
	if on_floor == 0 or acceleration.x != 0:
		friction.x = floor_friction
	else:
		friction.x = air_friction
	acceleration += gravity
	_velocity += acceleration
	_velocity *= friction
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL, true, 4, 0.785398, false)
	
func calculate_when_character_was_on_floor():
	if is_on_floor():
		on_floor = 0
		falling_time = 0.0
	else:
		on_floor += get_physics_process_delta_time()

func change_gravity(rotations: int, keep_speed: bool):
	position = position.rotated(deg2rad(90))
	_velocity = Vector2.ZERO
	rotation_degrees += 90

func rotate_90_degrees_CCW(vec : Vector2) -> Vector2:
	vec = Vector2(vec.y, -vec.x)
	return vec
