extends Area2D

export var acceleration = 50
export var jump_power = 120

var screen_size
var friction = 0.8
var _velocity = Vector2.ZERO

func toutching(var x, var y):
	pass

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	show()
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func _process(delta):
	if Input.is_action_pressed("moveright"):
		_velocity.x += acceleration
	if Input.is_action_pressed("move_left"):
		_velocity.x -= acceleration
	if Input.is_action_pressed("jump"):
		_velocity.y -= jump_power
	
	_velocity.y += gravity/10
	_velocity.x *= friction
	
	position += _velocity * delta
	position.x = clamp(position.x, 0, screen_size.x - 31)
	position.y = clamp(position.y, 0, screen_size.y - 31)



func _on_entity_body_entered(body):
	emit_signal("colided")
