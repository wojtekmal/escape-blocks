extends KinematicBody2D
class_name entity

export var air_friction := 0.93
export var floor_friction := 0.75
export var gravity := Vector2(0.0, 60.0)
export var keep_speed_after_rotation = false
export var rotation_speed := 1.0
var isOnFloor := false
var isOnRoof := false
var isOnWall := false
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
	if abs(_velocity.x) < 0.1:
		_velocity.x = 0;
	if abs(_velocity.y) < 0.1:
		_velocity.y = 0;
	
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL, false, 4, PI/4, false)
	
	if is_on_floor():
		isOnFloor = true
	else:
		isOnFloor = false
	#unstuck()

func is_colliding() -> bool:
	var colision = move_and_collide(Vector2.ZERO, true, true, true)
	return false 

func calculate_when_character_was_on_floor():
	if isOnFloor:
		on_floor = 0
		falling_time = 0.0
	else:
		on_floor += get_physics_process_delta_time()

func change_gravity(rotations: int, keep_speed: bool):
	for i in range(rotations):
		position = position.rotated(deg2rad(90))
		_velocity = Vector2.ZERO
		rotation_degrees += 90

func rotate_90_degrees_CCW(vec : Vector2) -> Vector2:
	vec = Vector2(vec.y, -vec.x)
	return vec

func unstuck(force : int = 3) -> bool: # returns true if is still coliding
	var x := 1
	var startPos = position
	while is_colliding() and x <= force:
		position.y += x;
		x += sign(x)
		x = -x
	if is_colliding():
		position = startPos
		return true
	else:
		return false
