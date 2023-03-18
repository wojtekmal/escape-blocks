extends Entity2
class_name test_player

@export var is_falling : bool = true

var coyote := 0.09
var last_floor := 0.0
@export var SPEED := Vector2(45, 155)

#func _physics_process(delta):
#	movement()

func movement(delta := get_physics_process_delta_time()):
	if debug:
		print(on_floor)
	rotation = ground.angle() - PI/2
	if on_floor:
		last_floor = 0.0
	else:
		last_floor += delta
	if is_falling:
		velocity += gravity
	var acceleration = calculate_move_acceleration(get_direction(), SPEED)
	acceleration = acceleration.rotated(
		gravity.angle() - PI/2
	)
	acceleration = round_vec(acceleration)
	velocity += acceleration
	move()
	if is_colliding():
		print("collding " + name)
	velocity *= friction

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - 
		Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if can_jump() else 0
	)

func can_jump() -> bool:
	if Input.is_action_pressed("jump") and last_floor < coyote:
		return true
	else:
		return false

func calculate_move_acceleration(
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	return direction * speed
