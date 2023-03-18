extends	Node2D
class_name Entity2
@warning_ignore("unused_parameter")
@export var debug := false

@onready var _root := get_tree().root.get_child(0)
@onready var _gravity = get_node("/root/Gravity")

var hitboxes := []

@onready var gravity : Vector2 = _gravity.gravity
var fake_pos := Vector2.ZERO
var friction := Vector2(0.8, 0.90)
var velocity = Vector2.ZERO

var ground := Vector2.DOWN
var on_floor := false

func _ready():
	add_to_group("entity")
	fake_pos = Vector2(
		round(position.x),
		round(position.y),)

func _rotate():
	print("rotates")

func _physics_process(delta: float) -> void:
	if is_colliding():
		print(name + " collided!")

func _process(delta):
	hitboxes = get_tree().get_nodes_in_group("hitboxes")

func unstuck(x := 100):
	var arm = 0
	var start := position
	for i in x:
		for angle in range(0, 360, 90):
			if is_colliding():
				position = start + (Vector2.UP.rotated(angle)) * arm
			else:
				return true
		arm += 1
	position = start
	return false

func move(delta := get_physics_process_delta_time()):
	on_floor = false
	var steps : int = ceil(abs(velocity.x)) + ceil(abs(velocity.y))
	for i in steps:
		var last = position
		var last_fake = fake_pos
		fake_pos.x += velocity.x/steps * delta # burgir hehe
		if update_pos():
			if is_colliding() == true:
				if velocity.x > 0 and ground.x > 0:
					on_floor = true
				elif velocity.x < 0 and ground.x < 0:
					on_floor = true
				velocity.x = 0
				position.x = last.x
				fake_pos.x = last_fake.x
		
		fake_pos.y += velocity.y/steps * delta # burgir hehe
		if update_pos():
			if is_colliding() == true:
				if velocity.y > 0 and ground.y > 0:
					on_floor = true
				elif velocity.y < 0 and ground.y < 0:
					on_floor = true
				
				velocity.y = 0
				position.y = last.y
				fake_pos.y = last_fake.y

func update_pos():
	if round(fake_pos.x) != position.x or round(fake_pos.y) != position.y:
		position.y = round(fake_pos.y)
		position.x = round(fake_pos.x)
		return true
	return false

func debuguj():
	if bool(Input.get_action_strength("ui_accept")):
		fake_pos = get_global_mouse_position()

func is_colliding() -> bool:
	for hitbox in hitboxes:
		if hitbox == $hitbox:
			continue
		elif hitbox.is_colliding_with($hitbox):
			return true
	return false

func round_vec(vec : Vector2):
	return Vector2(
		round(vec.x*100)/100,
		round(vec.y*100)/100)

func rotate_gravity(rotations):
	velocity = Vector2.ZERO
	gravity = gravity.rotated(PI/2*rotations)
	gravity = round_vec(gravity)
	friction = friction.rotated(PI/2*rotations)
	friction = abs(friction)
	friction = round_vec(friction)
	ground = gravity.normalized()
	ground = round_vec(ground)
