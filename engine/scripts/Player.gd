extends entity
signal rotate_gravity(rotations_to_perform)
export var walk_speed = 12
export var jump_speed = 60
export var coyote_time = 0.1
export var jump_time = 0.1 
var offset = 10;
var crawling := false

onready var _animated_sprite = $AnimatedSprite
onready var StandingHitBox = $StandingHitBox
onready var CrawlingHitBox = $CrawlingHitBox

func _physics_process(delta: float) -> void:
	calculate_when_character_was_on_floor()
	var	direction := get_direction()
	var acceleration := calculate_move_acceleration(direction, Vector2(walk_speed, jump_speed))
	change_sprite_rotation(direction)
	default_phisics(delta, acceleration)
	if is_colliding():
		if unstuck(200):
			start_crawling()
			unstuck(200)
	if is_colliding():
		print("no nie")

func _process(delta: float) -> void:
	manage_changing_gravity()
	animations()
	if Input.is_action_just_pressed("crawl"):
		if crawling:
			if isOnFloor:
				end_crawling()
		else:
			start_crawling()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - 
		Input.get_action_strength("move_left"),
			-Input.get_action_strength("jump") if can_jump() else 0
	)
	
func can_jump() -> bool:
	if crawling:
		return false
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
	if crawling:
		return
	var rotations = 0
	if(Input.is_action_just_pressed("gravity_right")):
		rotations += 1
	if(Input.is_action_just_pressed("gravity_up")):
		rotations += 2
	if(Input.is_action_just_pressed("gravity_left")):
		rotations += 3
	if rotations != 0:
		emit_signal("rotate_gravity", rotations)
		change_gravity(rotations%4, keep_speed_after_rotation)
		rotation_degrees -= 90 * rotations

func animations():
	var crawlAnimation := ""
	if crawling:
		crawlAnimation = "crawl "
	if not on_floor < coyote_time:
		if _velocity.y >= 0:
			_animated_sprite.play(crawlAnimation + "fallingDown")
		else:
			_animated_sprite.play("fallingUp")
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

func start_crawling():
	StandingHitBox.disabled = true
	CrawlingHitBox.disabled = false
	if is_colliding():
		StandingHitBox.disabled = false
		CrawlingHitBox.disabled = true
	else:
		crawling = true

func end_crawling():
	StandingHitBox.disabled = false
	CrawlingHitBox.disabled = true
	if is_colliding():
		StandingHitBox.disabled = true
		CrawlingHitBox.disabled = false
	else:
		crawling = false
