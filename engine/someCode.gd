extends Sprite


var acceleration = 75
var angular_speed = PI * 2
var velocity = Vector2.ZERO

func _init():
	position.x = 400
	position.y = 400

func _process(delta):
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	rotation += angular_speed * direction * delta
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2.UP.rotated(rotation) * acceleration
	if Input.is_action_pressed("ui_down"):
		velocity -= Vector2.UP.rotated(rotation) * acceleration
			
	position += velocity * delta
	velocity = velocity * 0.8
