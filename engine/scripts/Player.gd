extends KinematicBody2D
export var walk_speed = 60
export var jump_speed = 300
export var coyote_time = 0.1
export var jump_time = 0.1 
var offset = 10;
var crawling := false

onready var _animated_sprite = $AnimatedSprite
onready var StandingHitBox = $StandingHitBox
onready var CrawlingHitBox = $CrawlingHitBox

func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	manage_changing_gravity()
	animations()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - 
		Input.get_action_strength("move_left"),
			-Input.get_action_strength("jump") if can_jump() else 0
	)
	
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

func manage_changing_gravity():
	var dirs := [0, 1, 0, -1] #gives a multiplier for x and y gravity
	var rotations = get_parent().total_rotations
	rotation_degrees = rotations * 90

func animations():
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
