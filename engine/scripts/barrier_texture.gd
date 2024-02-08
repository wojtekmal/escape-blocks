extends Sprite2D

var transparent := preload("res://textures/transparent32x32.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		texture = transparent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
