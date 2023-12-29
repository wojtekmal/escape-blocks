@tool
extends TextureButton

signal level_button_pressed

func _ready():
	pressed.connect(on_pressed)

func _process(delta):
	if has_focus():
		self_modulate = Color8(255,234,84)
	else:
		self_modulate = Color(1,1,1)

func on_pressed():
	emit_signal("level_button_pressed", "MEGA RANDOM")
