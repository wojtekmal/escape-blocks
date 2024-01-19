@tool
extends CharacterBody2D
class_name entity2

@export var air_friction := 0
@export var floor_friction := 0.75
@export var gravity := Vector2(0.0, 60.0)
@export var keep_speed_after_rotation = false
@export var rotation_speed := 1.0
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
	
	_velocity = move(_velocity)
	#unstuck()

func is_colliding() -> bool:
	var colision = move_and_collide(Vector2.ZERO, true, true, true)
	return false 

func move(velocity : Vector2, steps : int = 0) -> Vector2:
	for i in range(abs(velocity.y)):
		if velocity.y > 0:
			var colision = move_and_collide(Vector2.DOWN, true, true, true)
			if colision:
				isOnFloor = true
				velocity.y = 0
				break
			else:
				isOnFloor = false
		elif velocity.y < 0:
			var colision = move_and_collide(Vector2.UP, true, true, true)
			isOnFloor = false
			if colision:
				velocity.y = 0
				break
		
		position.y += sign(velocity.y)  * get_physics_process_delta_time()
	
	for i in range(abs(velocity.x)):
		if velocity.x > 0:
			var colision = move_and_collide(Vector2.RIGHT, true, true, true)
			if colision:
				velocity.x = 0
				break
		elif velocity.x < 0:
			var colision = move_and_collide(Vector2.LEFT, true, true, true)
			if colision:
				velocity.x = 0
				break

		position.x += sign(velocity.x) * get_physics_process_delta_time()
	
	return velocity

func calculate_when_character_was_on_floor():
	if isOnFloor:
		on_floor = 0
		falling_time = 0.0
	else:
		on_floor += get_physics_process_delta_time()

func change_gravity(rotations: int, keep_speed: bool):
	for i in range(rotations):
		position = position.rotated(deg_to_rad(90))
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
