extends Node2D
signal rotate

@onready var _gravity = get_node("/root/Gravity")
@onready var entities := []
@onready var ground := Vector2.DOWN

func _ready():
	entities = get_tree().get_nodes_in_group("entity")
#	for entity in entities:
#		entity.rotate.

func _physics_process(delta):
	entities_movement()

func _process(delta):
	change_gravity()

func change_gravity():
	var rotations = 0
	if(Input.is_action_just_pressed("gravity_right")):
		rotations += 3
	if(Input.is_action_just_pressed("gravity_up")):
		rotations += 2
	if(Input.is_action_just_pressed("gravity_left")):
		rotations += 1
	if rotations > 0:
		ground = (ground.rotated(rotations * PI/2))
		ground.x = round(ground.x)
		ground.y = round(ground.y)
		for enitity in entities:
			enitity.rotate_gravity(rotations)
#	_gravity.gravity = _gravity.gravity.rotated(PI/2*rotations)

func heights(a : Object, b: Object):
	if ground == Vector2.DOWN:
		return a.position.y > b.position.y
	elif ground == Vector2.UP:
		return a.position.y < b.position.y
	elif ground == Vector2.LEFT:
		return a.position.x < b.position.x
	elif ground == Vector2.RIGHT:
		return a.position.x > b.position.x
	else:
		print(":c")

func entities_movement():
	entities.sort_custom(heights)
	for entity in entities:
		entity.movement()

