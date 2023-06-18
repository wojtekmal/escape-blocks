extends Node2D

var dir
var speed = PI * PI * PI * PI
var rotspeed = 1 / PI

func _ready():
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	dir = dir.normalized()
	position = -dir * 5000
	dir = dir.rotated(randf_range(-PI/6, PI/6))
	rotation = randf_range(0, PI)
	rotspeed = randf_range(0, PI)
	speed *= randf_range(.5, 2)
	scale *= randf_range(0.8, 1.2)
	if randi() % 420 == 0:
		$Sprite2D.visible = false
		$Sprite2D2.visible = true

func _process(delta):
	position += dir * delta * speed;
	rotation += rotspeed * delta
	if position.length() > 5000:
		queue_free()
