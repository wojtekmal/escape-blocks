@tool
extends TextureButton

signal level_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_focus():
		self_modulate = Color(0.6,1,0.6)
	else:
		self_modulate = Color(1,1,1)

func on_pressed():
	emit_signal("level_button_pressed", "Random")
