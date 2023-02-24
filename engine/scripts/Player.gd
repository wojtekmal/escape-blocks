extends entity
signal rotate_gravity(rotations_to_perform)

export var walk_speed = 120
export var jump_speed = 500
export var coyote_time = 0.1
export var jump_time = 0.1

func _physics_process(delta: float) -> void:
	calculate_when_character_was_on_floor()
	var	direction := get_direction()
	var acceleration := calculate_move_acceleration(direction, Vector2(walk_speed, jump_speed))
	acceleration
	default_phisics(delta, acceleration)

func _process(delta: float) -> void:
	manage_changing_gravity()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - 
		Input.get_action_strength("move_left"),
			-Input.get_action_strength("jump") if can_jump() else 0
	)

func can_jump() -> bool:
	if Input.is_action_pressed("jump") and on_floor < coyote_time and falling_time < jump_time:
		falling_time += get_physics_process_delta_time()
		return true
	else:
		return false

func calculate_move_acceleration(
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
		
	var new_velocity := direction * speed
	return new_velocity

func manage_changing_gravity():
	var rotations = 0
	if(Input.is_action_just_pressed("gravity_right")):
		rotations += 1
	if(Input.is_action_just_pressed("gravity_up")):
		rotations += 2
	if(Input.is_action_just_pressed("gravity_left")):
		rotations += 3
	change_gravity(rotations%4, keep_speed_after_rotation)
	emit_signal("rotate_gravity", rotations)

	
	
